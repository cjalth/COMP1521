// Pretty Print Command Line Arguments
// my_args.c
//
// Written by Caitlin Wong (z5477471)
// on 14/09/2023
//
// This program reads command line arguments are 
// prints it in a nice format. 

#include <stdio.h>

int main(int argc, char *argv[]) {
	printf("Program name: %s\n", argv[0]);
	int i = 2;
	int j = 1;
	if (argc <= 1) {
		printf("There are no other arguments\n");
	} else if (argc >= 2){
		printf("There are %d arguments:\n", argc - 1);
		while (i <= argc) {
			printf("\tArgument %d is \"%s\"\n", j, argv[j]);
			i++;
			j++;
		}
	}
	return 0;
}
