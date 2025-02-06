# COMP1521 22T3 ... final exam, question 2

# The provided code reads one integer and prints it.
# Modify it so that it reads two integers and prints
# the sum of their squares.

main:
	li	$v0, 5		# syscall 5: read_int
	syscall			#
	move	$t0, $v0	# scanf("%d", &a);

	# TODO: complete this code so that its behaviour
	#       matches the provided C code

	li	$v0, 5		# syscall 5: read_int
	syscall			#
	move	$t1, $v0	# scanf("%d", &b);

	mul	$t0, $t0, $t0
	mul	$t1, $t1, $t1
	add	$t2, $t0, $t1

	li	$v0, 1		# syscall 1: print_int
	move	$a0, $t2	#
	syscall			# printf("%d", a);

	li	$v0, 11		# syscall 11: print_char
	li	$a0, '\n'	#
	syscall			# printf("\n");

	li	$v0, 0
	jr	$ra		# return 0;
