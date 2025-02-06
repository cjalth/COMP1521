// Statistical Analysis of Command Line Arguments
// arg_stats.c
//
// Written by Caitlin Wong (z5477471)
// on 27/05/2024
//
// This program reads command line arguments and prints 
// the minimum and maximum values, the sum and product of 
// all the values, and the mean of all the values.

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
	int min = atoi(argv[1]);
	int max = atoi(argv[1]);
	int prod = 1;
	int sum = 0;
	int i = 1;

	while (i < argc) {
		sum = sum + atoi(argv[i]);
		prod = prod * atoi(argv[i]);
		
		// Finds minimum and maximum number
		if (min > atoi(argv[i])) {
			min = atoi(argv[i]);
		}
		if (max < atoi(argv[i])) {
			max = atoi(argv[i]);
		}	
		i++;
	}

	printf("MIN:  %d\n", min);
	printf("MAX:  %d\n", max);
	printf("SUM:  %d\n", sum);
	printf("PROD: %d\n", prod);
	printf("MEAN: %d\n", sum / (argc - 1));

	return 0;
}