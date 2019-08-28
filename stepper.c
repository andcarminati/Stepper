/*
Stepper
Copyright (C) 2019  Andreu Carminati
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#define _GNU_SOURCE
#include <sys/syscall.h>  
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <elf.h>
#include <string.h>
#include <sys/types.h>

//from https://wiki.osdev.org/DWARF

typedef struct __attribute__((packed)) {
    uint32_t length;
    uint16_t version;
    uint32_t header_length;
    uint8_t min_instruction_length;
    uint8_t default_is_stmt;
    int8_t line_base;
    uint8_t line_range;
    uint8_t opcode_base;
    uint8_t std_opcode_lengths[12];
}
debug_line_header;

int init = 0;
int init1 = 0;
int mode = 0;

/*elf header of the executable*/
Elf64_Ehdr exe_header;

/*binary file descriptor*/
FILE *exe_file = NULL;
/*sections name string table*/
char* shstrtab = NULL;
/*symbol table string table*/
char* strtab = NULL;
/*debug  string table*/
char* debug_str = NULL;
/*debug line data*/
char* debug_line = NULL;
int debug_line_size;

/*program headers (not used yet)*/
Elf64_Shdr* section_headers = NULL;
/*section headers (string tables, symbol tables)*/
Elf64_Phdr* program_headers = NULL;

/*number of symbols in this executable*/
int n_symbol;
/*symbol table readed from elf*/
Elf64_Sym* symbol_table = NULL;

void init_elf(void);
int read_elf(void);
void load_program_headers(void);
void load_section_headers(void);
void load_shstrtab(void);
void load_dwarf_data(void);
char* get_shstrtab_str(int index);
void load_syntab(void);
void load_strtab(void);
void print_symbols(void);
unsigned long find_address_by_name(char* func);
char* find_symbol_name_by_ra(long);
void dump_call_seq_from_stack(unsigned long);
void track_chaining(unsigned long);
void dwarf_parse_line_info();
void init_line_info_table();
void print_line_info(unsigned long addr);

void mcount();
void _start();

/*this structure allow us to walk on stack frames of chained procedure calls*/
struct __attribute__((packed)) stack_link {
    unsigned long base_pointer_reg;
    unsigned long ra;
};

unsigned long offset = 0;
//long stack_pointer;

void __attribute__((no_instrument_function)) step(long addr,
        long parent,
        long stack_parent) {

    char buffer[20];

    init_elf();

    if (init1 == 0) {
        printf("==========================================\n");
        printf("Stepper 0.02 - by Andreu Carminati\n");
        printf("==========================================\n");
        //print_symbols();

        printf("==========================================\n");
        printf("Options: \n");
        printf("run - begin to end execution.\n");
        printf("step - function by function execution.\n");



        exe_file = fopen("/proc/self/exe", "r");

        if (!exe_file) {
            perror("Erro.");
        }

        fread(&exe_header, sizeof (Elf32_Ehdr), 1, exe_file);
        char* start = find_symbol_name_by_ra(exe_header.e_entry);
        printf("Entry address: 0x%lx -> %s \n", exe_header.e_entry, start);
        
        
        offset = (unsigned long)_start - exe_header.e_entry;

        printf("==========================================\n");
        printf("Your option: ");
        scanf("%s", buffer);
        printf("==========================================\n");
        printf("Trace output from main function:\n");

        if (strcmp(buffer, "run") == 0) {
            mode = 1;
        } else if (strcmp(buffer, "step") == 0) {
            mode = 2;
        } else {
            printf("invalid option\n");
            exit(-1);
        }

        init1 = 1;
        //gets(buffer);
        getchar();
        return;
    } else {
        if (mode != 1) {
            //gets(buffer);
            getchar();
        }
        char* name = find_symbol_name_by_ra(addr);
        char* parent_name = find_symbol_name_by_ra(parent);
        unsigned long addr;
        struct stack_link* link = (void*) (stack_parent);
        addr = link->ra;
        //printf("Thread id %d: [%s] <0x%x> call [%s] <0x%x>", syscall(SYS_gettid), parent_name, parent, name, addr);	
        //dump_call_seq_from_stack(stack_parent);	


        printf("Thread id %ld: ", syscall(SYS_gettid));
        track_chaining(stack_parent);
        printf("[%s] <0x%lx> ", name, addr);
        //dump_call_seq_from_stack(stack_parent);
        print_line_info(addr);
        printf("\n");
    }


    return;
}

void __attribute__((no_instrument_function)) init_elf() {

    if (init == 0) {
        exe_file = fopen("/proc/self/exe", "r");

        if (!exe_file) {
            perror("Error");
        }
        read_elf();
        init = 1;
    }
}

int __attribute__((no_instrument_function)) read_elf() {

    fread((void*) &exe_header, sizeof (Elf64_Ehdr), 1, exe_file);

    load_program_headers();
    load_section_headers();
    load_shstrtab();
    load_syntab();
    load_strtab();
    load_dwarf_data();
    //dwarf_parse_line_info();
    return 0;
}

void __attribute__((no_instrument_function)) load_program_headers() {

    program_headers = malloc(sizeof (Elf64_Phdr) * exe_header.e_phnum);
    fseek(exe_file, exe_header.e_phoff, SEEK_SET);
    fread(program_headers, sizeof (Elf64_Phdr), exe_header.e_phnum, exe_file);

    return;
}

void __attribute__((no_instrument_function)) load_section_headers() {

    section_headers = malloc(sizeof (Elf64_Shdr) * exe_header.e_shnum);
    fseek(exe_file, exe_header.e_shoff, SEEK_SET);
    fread(section_headers, sizeof (Elf64_Shdr), exe_header.e_shnum, exe_file);
    return;
}

void __attribute__((no_instrument_function)) load_shstrtab() {

    Elf64_Shdr* header;

    header = &section_headers[exe_header.e_shstrndx];
    shstrtab = malloc(header->sh_size);
    fseek(exe_file, header->sh_offset, SEEK_SET);
    fread(shstrtab, header->sh_size, 1, exe_file);

    return;
}

char* __attribute__((no_instrument_function)) get_shstrtab_str(int index) {
    return &shstrtab[index];
}

void __attribute__((no_instrument_function)) load_syntab() {

    Elf64_Shdr* header = NULL;
    int i;

    for (i = 0; i < exe_header.e_shnum; i++) {
        header = &section_headers[i];
        if (strcmp(&shstrtab[header->sh_name], ".symtab") == 0) {
            n_symbol = header->sh_size / sizeof (Elf64_Sym);
            symbol_table = malloc(header->sh_size);
            fseek(exe_file, header->sh_offset, SEEK_SET);
            if (!fread(symbol_table, header->sh_size, 1, exe_file)) {
                printf("error");
            }


            return;
        }
    }

    printf("Error, no symbol table found\n");

    return;
}

void __attribute__((no_instrument_function)) load_strtab() {

    Elf64_Shdr* header = NULL;
    int i;

    for (i = 0; i < exe_header.e_shnum; i++) {
        header = &section_headers[i];
        if (strcmp(&shstrtab[header->sh_name], ".strtab") == 0) {
            strtab = malloc(header->sh_size);
            fseek(exe_file, header->sh_offset, SEEK_SET);
            fread(strtab, header->sh_size, 1, exe_file);

            return;
        }
    }

    printf("Error, no strtab table found\n");

    return;
}

void __attribute__((no_instrument_function)) load_dwarf_data() {

    Elf64_Shdr* header = NULL;
    int i;
    int size = 0;
    for (i = 0; i < exe_header.e_shnum; i++) {
        header = &section_headers[i];
        if (strcmp(&shstrtab[header->sh_name], ".debug_line") == 0) {
            debug_line = malloc(header->sh_size);
            fseek(exe_file, header->sh_offset, SEEK_SET);
            fread(debug_line, header->sh_size, 1, exe_file);
            //printf("Dwarf debug line size: %d\n", header->sh_size);
            size = header->sh_size;
            debug_line_size = header->sh_size;
            break;
        }
    }

    for (i = 0; i < exe_header.e_shnum; i++) {
        header = &section_headers[i];
        if (strcmp(&shstrtab[header->sh_name], ".debug_str") == 0) {
            debug_str = malloc(header->sh_size);
            fseek(exe_file, header->sh_offset, SEEK_SET);
            fread(debug_str, header->sh_size, 1, exe_file);
            //size = header->sh_size;
            //printf("Dwarf debug strings size: %d\n", header->sh_size);
            break;
        }
    }

    //for(i = 0; i < size; i++){
    //    printf("%c", debug_line[i]);
    // }

    if (debug_line && debug_str) {
        init_line_info_table();
        dwarf_parse_line_info();
        return;
    }

    printf("Error, no dwarf data\n");

    return;
}

void __attribute__((no_instrument_function)) print_symbols() {

    Elf64_Sym* symb;
    int i;

    printf("Number of symbols: %d\nListing functions:\n", n_symbol);

    for (i = 0; i < n_symbol; i++) {
        symb = &symbol_table[i];
        if (ELF64_ST_TYPE(symb->st_info) == STT_FUNC) {
            printf("FUNCTION: %s addr: 0x%lx to 0x%lx\n", &strtab[symb->st_name], symb->st_value, symb->st_value + symb->st_size);
        }


    }
}

unsigned long __attribute__((no_instrument_function)) find_address_by_name(char* func) {

    Elf64_Sym* symb;
    int i;

    for (i = 0; i < n_symbol; i++) {
        symb = &symbol_table[i];
        if (ELF64_ST_TYPE(symb->st_info) == STT_FUNC) {
            if(strcmp(func, &strtab[symb->st_name]) == 0){
                return symb->st_value;
            }
        }
    }
    return 0;
}

char* __attribute__((no_instrument_function)) find_symbol_name_by_ra(long ra) {

    Elf64_Sym* symb;
    char* symb_name = NULL;
    int i;
    ra-=offset;

    for (i = 0; i < n_symbol; i++) {
        symb = &symbol_table[i];
        if (ELF64_ST_TYPE(symb->st_info) == STT_FUNC) {
            if ((ra >= symb->st_value) && (ra < (symb->st_value + symb->st_size))) {
                symb_name = &strtab[symb->st_name];
            }
        }

    }
    return symb_name;
}

void __attribute__((no_instrument_function)) dump_call_seq_from_stack(unsigned long parent) {

    char* name = NULL;
    struct stack_link* link = (void*) (parent);

    printf(" :: sequence call (reverse): {");

    do {
        printf("-> ");
        name = find_symbol_name_by_ra(link->ra);
        printf("%s <0x%lx> ", name, link->ra);
        link = (void*) link->base_pointer_reg;
    } while (strcmp(name, "main") != 0);
    printf("}\n");
}

void __attribute__((no_instrument_function)) track_chaining(unsigned long parent) {

    char* name;
    struct stack_link* link = (void*) (parent);
    int i = 0, j;

    //printf("\t");
    do {
        name = find_symbol_name_by_ra(link->ra);
        link = (void*) link->base_pointer_reg;
        i++;
    } while (strcmp(name, "main") != 0);

    for (j = 0; j < i; j++) {
        printf("    ");
    }
    printf("|->");
}

void __attribute__((no_instrument_function)) enable_tracing() {

    ///memcpy(&mcount, )
}

unsigned char ret_inst = 0xC3;

void __attribute__((no_instrument_function)) disable_tracing() {

    //memcpy(&mcount, &ret_inst, 1);
}


#define DW_LNS_copy 1
#define DW_LNS_advance_pc 2
#define DW_LNS_advance_line 3
#define DW_LNS_set_file 4
#define DW_LNS_set_column 5
#define DW_LNS_negate_stmt 6
#define DW_LNS_set_basic_block 7
#define DW_LNS_const_add_pc 8
#define DW_LNS_fixed_advance_pc 9

#define DW_LNE_end_sequence 1
#define DW_LNE_set_address 2
#define DW_LNE_define_file 3
#define DW_LNE_set_discriminator 4 // dwarfv4

//adapted from addr2line
char* __attribute__((no_instrument_function)) ULEB128_read(char* buff, unsigned long *val) {
    int result = 0;
    int shift = 0;

    while (1) {
        char byte = buff[0];
        buff++;
        result |= (byte & 0x7f) << shift;
        if ((byte & 0x80) == 0) {
            break;
        }
        shift += 7;
    }
    *val = result;
    return buff;
}

// adapted from gcc (https://github.com/gcc-mirror/gcc/blob/master/include/leb128.h))
char* __attribute__((no_instrument_function)) SLEB128_read(char* buff, long *val) {
    unsigned long result = 0;
    char *p = buff;
    unsigned int shift = 0;
    unsigned char byte;

    while (1) {

        byte = *p++;
        result |= ((uint64_t) (byte & 0x7f)) << shift;
        shift += 7;
        if ((byte & 0x80) == 0)
            break;
    }
    if (shift < (sizeof (*val) * 8) && (byte & 0x40) != 0)
        result |= -(((uint64_t) 1) << shift);

    *val = result;
    return p;
}

typedef struct line_info{
    long addr;
    int line;
    int column;
    char* file;
} line_info;

line_info* lineinfo = NULL;
int line_info_size;
int line_info_used;

void __attribute__((no_instrument_function)) init_line_info_table(){
    
    line_info_size = 200;
    line_info_used = 0;
    lineinfo = malloc(sizeof(line_info)*line_info_size);
}

void __attribute__((no_instrument_function)) check_line_info_table(){
    
    if(line_info_used == line_info_size){
        line_info_size += 200;
        lineinfo = realloc(lineinfo, line_info_size*sizeof(line_info));
    }
}

void __attribute__((no_instrument_function))add_line_point(long addr, int line, int column, char* file) {

    //printf("0x%04x --> %s:%d\n", addr, file, line);
    check_line_info_table();
    
    lineinfo[line_info_used].addr = addr;
    lineinfo[line_info_used].file = file;
    lineinfo[line_info_used].line = line;
    lineinfo[line_info_used].column = column;
    line_info_used++;
}

void __attribute__((no_instrument_function))print_line_info(unsigned long addr){
    
    if(!lineinfo){
        return;
    }
    
    int i;
    for(i = 0; i < line_info_used-1; i++){
        //printf("target 0x%04x - actual 0x%04x\n", addr, lineinfo[i].addr);
        if(addr >= lineinfo[i].addr && addr < lineinfo[i+1].addr){
            printf("  called by %s:[line %d, column: %d]", lineinfo[i-1].file,
                    lineinfo[i-1].line, lineinfo[i-1].column );
        }
    }
}

void __attribute__((no_instrument_function)) dwarf_parse_line_info() {

    if (!debug_line) {
        return;
    }

    char* debug_line_begin = debug_line;
    char* debug_line_end = debug_line + debug_line_size;

    while (debug_line_begin < debug_line_end) {


        debug_line_header* header = (debug_line_header*) debug_line_begin;
        /*
        printf("--------DW line--------\n");
        printf("Length: \t%d\n", header->length);
        printf("Dwarf version: \t%d\n", header->version);
        printf("Dwarf prologue length: \t%d\n", header->header_length);
        printf("Dwarf min. instruction length: \t%d\n", header->min_instruction_length);
        printf("Dwarf base line: \t%d\n", header->line_base);
        printf("Dwarf base opcode: \t%d\n\n", header->opcode_base);

        printf("Opcodes:\n");
        printf("Opcode 1 has %d arguments\n", header->std_opcode_lengths[0]);
        printf("Opcode 2 has %d arguments\n", header->std_opcode_lengths[1]);
        printf("Opcode 3 has %d arguments\n", header->std_opcode_lengths[2]);
        printf("Opcode 4 has %d arguments\n", header->std_opcode_lengths[3]);
        printf("Opcode 5 has %d arguments\n", header->std_opcode_lengths[4]);
        printf("Opcode 6 has %d arguments\n", header->std_opcode_lengths[5]);
        printf("Opcode 7 has %d arguments\n", header->std_opcode_lengths[6]);
        printf("Opcode 8 has %d arguments\n", header->std_opcode_lengths[7]);
        printf("Opcode 9 has %d arguments\n", header->std_opcode_lengths[8]);
        printf("Opcode 10 has %d arguments\n", header->std_opcode_lengths[9]);
        printf("Opcode 11 has %d arguments\n", header->std_opcode_lengths[10]);
        printf("Opcode 12 has %d arguments\n", header->std_opcode_lengths[11]);
         */

        //printf("\nDirectories:\n", header->std_opcode_lengths[11]);
        char* dirs = debug_line_begin + sizeof (debug_line_header);
        int counter = 1;

        while (dirs[0] != '\0') {
            char* actual_dir = dirs;
            //printf("%d - %s\n", counter++, actual_dir);
            dirs += (strlen(actual_dir) + 1);
        }

        //printf("\nFiles:\n", header->std_opcode_lengths[11]);
        char* files = dirs + 1;
        counter = 1;

        char* main_file = files;

        while (files[0] != '\0') {
            char* actual_file = files;
            char* conf = files + (strlen(actual_file) + 1);
            unsigned long dir;
            unsigned long time;
            unsigned long tam;

            conf = ULEB128_read(conf, &dir);
            conf = ULEB128_read(conf, &time);
            conf = ULEB128_read(conf, &tam);

            //printf("%d - %s - %d - %d - %d\n", counter++, actual_file, dir, time, tam);

            files = conf;
        }
        char* lines = files + 1;
        unsigned long address;
        int line = 1;
        int column = 1;
        int has_more = 1;

        while (has_more) {
            unsigned char op = lines[0];
            lines++;
            switch (op) {
                case DW_LNS_copy:
                {
                    add_line_point(address, line, column, main_file);
                    //printf("copy\n");
                    break;
                }
                case DW_LNS_advance_pc:
                {
                    unsigned long a;
                    lines = ULEB128_read(lines, &a);
                    //printf("Advancing pc by %d to %d\n", a, address+a);
                    address += a;
                    break;
                }
                case DW_LNS_advance_line:
                {
                    long a;
                    lines = SLEB128_read(lines, &a);
                    //printf("Advancing line from %d to %d\n", line, line + a);
                    line += a;
                    break;
                }
                case DW_LNS_set_file:
                    break;
                case DW_LNS_set_column:
                {
                    unsigned long c;
                    lines = ULEB128_read(lines, &c);
                    column = c;
                    //printf("set col %d.\n", c);
                    break;
                }

                case DW_LNS_negate_stmt:
                    break;
                case DW_LNS_set_basic_block:
                    break;
                case DW_LNS_const_add_pc:
                {
                    long a;
                    a = ((255 - header->opcode_base) / header->line_range) *
                            header->min_instruction_length;
                    //printf("Advancing pc by const %d to %04x\n", a, address+a);
                    address += a;
                    break;
                }
                case DW_LNS_fixed_advance_pc:
                    break;
                case 0:
                {
                    unsigned long a = *(unsigned char *) lines++;
                    int op_ext = *(unsigned char *) lines++;

                    switch (op_ext) {
                        case DW_LNE_end_sequence:
                        {
                            add_line_point(address, line, column, main_file);
                            has_more = 0;
                            break;
                        }
                        case DW_LNE_set_address:
                        {
                            unsigned long ad = *(unsigned long *) lines;
                            lines += sizeof (unsigned long);
                            //printf("set pc to %04x\n", ad);
                            address = ad;
                            break;
                        }
                        case DW_LNE_set_discriminator:
                        {
                            lines = ULEB128_read(lines, &a);
                            break;
                        }
                        default:
                            printf("Unknown extended opcode: %d\n", op_ext);
                            break;
                    }
                    break;

                }
                default:
                {
                    //printf("special opcode:\n");
                    unsigned long addr_incr;
                    unsigned long line_incr;
                    long a = op - header->opcode_base;
                    addr_incr = (a / header->line_range) * header->min_instruction_length;
                    line_incr = header->line_base + (a % header->line_range);
                    address += (unsigned int) addr_incr;
                    line += (unsigned int) line_incr;
                    //printf("address %04x (+ %d)- line %d (+ %d)\n", address, addr_incr, line, line_incr);
                    add_line_point(address, line, column, main_file);
                    break;
                }
            }
            debug_line_begin = lines;
        }
    }
}