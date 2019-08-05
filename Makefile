CC=gcc
CFLAGS='-pg'

demo: stepper.o mcount_wrapper.o sort-demo.o
	$(CC) -o demo mcount_wrapper.o sort-demo.o stepper.o -pg

clean:
	rm -rf *.o 
