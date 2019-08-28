CC=gcc
CFLAGS=-pg -g

demo: stepper.o mcount_wrapper.o sort-demo.o
	$(CC) -o demo mcount_wrapper.o sort-demo.o stepper.o -pg -g

clean:
	rm -rf *.o 
