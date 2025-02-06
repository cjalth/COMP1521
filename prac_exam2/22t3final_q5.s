# COMP1521 22T3 ... final exam, question 5

# Modify the program below such that its output
# matches that of 22t3final_q4.

main:
	li	$v0, 5				# syscall 5: read_int
	syscall					#
	move	$t0, $v0			# scanf("%d, &x);

	# ADD YOUR CODE HERE


	li	$v0, 1				# syscall 1: print_int
	li	$a0, 42				#
	syscall					# printf("%d", 42);

	li	$v0, 11				# syscall 11: print_char
	li	$a0, '\n'			#
	syscall					# putchar('\n');

	li	$v0, 0				#
	jr	$ra				# return 0;
