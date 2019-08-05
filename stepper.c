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
char* get_shstrtab_str(int index);
void load_syntab(void);
void load_strtab(void);
void print_symbols(void);
char* find_symbol_name_by_ra(long);
void dump_call_seq_from_stack(unsigned long);
void track_chaining(unsigned long);

void mcount();

/*this structure allow us to walk on stack frames of chained procedure calls*/
struct __attribute__((packed)) stack_link{
	unsigned long base_pointer_reg;
	unsigned long ra;
};	

//long stack_pointer;

void __attribute__((no_instrument_function)) step(long addr, 
												  long parent, 
												  long stack_parent) {
	
	char buffer[20];
	
	init_elf();
	
	if(init1 == 0){
		printf("==========================================\n");
		printf("Stepper 0.01 - by Andreu Carminati\n");
		printf("==========================================\n");
		print_symbols();
		
		printf("==========================================\n");
		printf("Options: \n");
		printf("run - begin to end execution.\n");
		printf("step - function by function execution.\n");
		
		
		
		exe_file = fopen("/proc/self/exe", "r");
		
		if(!exe_file){
			perror("Erro.");
		}	
		
		fread(&exe_header, sizeof(Elf32_Ehdr), 1, exe_file);
		char* start = find_symbol_name_by_ra(exe_header.e_entry);
		printf("Entry address: 0x%x -> %s \n", exe_header.e_entry, start);
		
		printf("==========================================\n");
		printf("Your option: ");
		scanf("%s", buffer);
		printf("==========================================\n");
		printf("Trace output from main function:\n");
		
		if(strcmp(buffer, "run") == 0){
			mode = 1;	
		} else if(strcmp(buffer, "step") == 0){
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
			if(mode != 1){
                            //gets(buffer);
                            getchar();
			}
			char* name = find_symbol_name_by_ra(addr);
			char* parent_name = find_symbol_name_by_ra(parent);
			//printf("Thread id %d: [%s] <0x%x> call [%s] <0x%x>", syscall(SYS_gettid), parent_name, parent, name, addr);	
			//dump_call_seq_from_stack(stack_parent);	
			
			
			printf("Thread id %d: ", syscall(SYS_gettid));
			track_chaining(stack_parent);
			printf("[%s] <0x%x> ", name, addr);
			//dump_call_seq_from_stack(stack_parent);
			printf("\n");
	}	
	
	
	return;
}

void __attribute__((no_instrument_function)) init_elf(){
	
	if(init == 0){
		exe_file = fopen("/proc/self/exe", "r");
		
		if(!exe_file){
			perror("Error");
		}
		read_elf();
		init = 1;
	}
}		

int __attribute__((no_instrument_function)) read_elf(){
	
	fread((void*)&exe_header, sizeof(Elf64_Ehdr), 1, exe_file);
	
	load_program_headers();
	load_section_headers();
	load_shstrtab();
	load_syntab();
	load_strtab();
}	

void __attribute__((no_instrument_function)) load_program_headers(){
	
	 program_headers = malloc(sizeof(Elf64_Phdr)*exe_header.e_phnum);
	 fseek(exe_file, exe_header.e_phoff, SEEK_SET);
	 fread(program_headers, sizeof(Elf64_Phdr), exe_header.e_phnum, exe_file);
		
	 return;	
}		

void __attribute__((no_instrument_function)) load_section_headers(){
	 
	 section_headers = malloc(sizeof(Elf64_Shdr)*exe_header.e_shnum); 
	 fseek(exe_file, exe_header.e_shoff, SEEK_SET); 
	 fread(section_headers, sizeof(Elf64_Shdr), exe_header.e_shnum, exe_file);	
	 return;	
}

void __attribute__((no_instrument_function)) load_shstrtab(){
		
	Elf64_Shdr* header;	
	
	header = &section_headers[exe_header.e_shstrndx];
	shstrtab = malloc(header->sh_size);
	fseek(exe_file, header->sh_offset, SEEK_SET); 
	fread(shstrtab, header->sh_size, 1, exe_file);
	
	return;				
}

char* __attribute__((no_instrument_function)) get_shstrtab_str(int index){
	return &shstrtab[index];
}

void __attribute__((no_instrument_function)) load_syntab(){
		
	Elf64_Shdr* header = NULL;
	int i;
	
	for(i = 0; i < exe_header.e_shnum; i++){
		header = &section_headers[i];
		if(strcmp(&shstrtab[header->sh_name], ".symtab") == 0){
			n_symbol = header->sh_size / sizeof(Elf64_Sym);
			symbol_table = malloc(header->sh_size);
			fseek(exe_file, header->sh_offset, SEEK_SET);
			if(!fread(symbol_table, header->sh_size, 1, exe_file)){
				printf("error");
			}	 
			
			
			return;
		}		
	}

	printf("Error, no symbol table found\n");
	
	return;				
}

void __attribute__((no_instrument_function)) load_strtab(){
	
	Elf64_Shdr* header = NULL;
	int i;
	
	for(i = 0; i < exe_header.e_shnum; i++){
		header = &section_headers[i];
		if(strcmp(&shstrtab[header->sh_name], ".strtab") == 0){
			strtab = malloc(header->sh_size);
			fseek(exe_file, header->sh_offset, SEEK_SET); 
			fread(strtab, header->sh_size, 1, exe_file);
			
			return;
		}		
	}

	printf("Error, no strtab table found\n");
	
	return;		
}

void __attribute__((no_instrument_function)) print_symbols(){
	
	Elf64_Sym* symb;
	int i;
	
	printf("Number of symbols: %d\nListing functions:\n", n_symbol);
	
	for(i = 0; i < n_symbol; i++){
		symb = &symbol_table[i];
		if(ELF64_ST_TYPE(symb->st_info) == STT_FUNC){
			printf("FUNCTION: %s addr: 0x%x to 0x%x\n", &strtab[symb->st_name], symb->st_value, symb->st_value+ symb->st_size);
		}	
		
		
	}	
}	

char* __attribute__((no_instrument_function)) find_symbol_name_by_ra(long ra){
	
	Elf64_Sym* symb;
	char* symb_name = NULL;
	int i;
	
	for(i = 0; i < n_symbol; i++){
		symb = &symbol_table[i];
		if(ELF64_ST_TYPE(symb->st_info) == STT_FUNC){
			if((ra >= symb->st_value) && (ra < (symb->st_value + symb->st_size))){
				symb_name = &strtab[symb->st_name];
			}	
		}	
		
	}	
	return symb_name;		
}				

void __attribute__((no_instrument_function)) dump_call_seq_from_stack(unsigned long parent){
	
	char* name = NULL;
	struct stack_link* link = (void*) (parent);
	
	printf(" :: sequence call (reverse): {");
	
	do {
		printf("-> ");
		name = find_symbol_name_by_ra(link->ra);
		printf("%s <0x%x> ", name, link->ra);
		link = (void*) link->base_pointer_reg;
	} while(strcmp(name, "main") != 0);
	printf("}\n");	
}


void __attribute__((no_instrument_function)) track_chaining(unsigned long parent){
	
	char* name;
	struct stack_link* link = (void*) (parent);
	int i = 0, j;
	
	//printf("\t");
	do {
		name = find_symbol_name_by_ra(link->ra);
		link = (void*) link->base_pointer_reg;
		i++;
	} while(strcmp(name, "main") != 0);
	
	for(j = 0; j < i; j++){
		printf("    ");
	}
	printf("|->");	
}

void __attribute__((no_instrument_function)) enable_tracing(){
	
	///memcpy(&mcount, )
}

unsigned char ret_inst = 0xC3;

void __attribute__((no_instrument_function)) disable_tracing(){
	
	//memcpy(&mcount, &ret_inst, 1);
}			

