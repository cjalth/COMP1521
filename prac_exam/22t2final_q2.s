# COMP1521 22T2 ... final exam, question 2

main:
	li		$v0, 5		# syscall 5: read_int
	syscall
	move	$t0, $v0	# read integer into $t0


	# THESE LINES JUST PRINT 42\n
	# REPLACE THE LINES BELOW WITH YOUR CODE

	li		$t1, 0			# int result = 0;
	li		$t2, 0			# int i = 0;

main_loop:
	sllv	$t3, 1, $t2		# 1u << i
	and		$t4, $t0, $t3	# x & (1u << i)
	bnez	$t4, step		# ! (x & (1u << i))
	addi	$t1, $t1, 1		# result++

step:
	addi	$t2, $t2, 1			# i++;
	blt		$t2, 32, main_loop	# check if i < 32	

	li	$v0, 1		# syscall 1: print_int
	move	$a0, $t1
	syscall			# printf("%d", result);

	li	$v0, 11		# syscall 11: print_char
	li	$a0, '\n'
	syscall			# printf("\n");
	# REPLACE THE LINES ABOVE WITH YOUR CODE

main__end:
	li	$v0, 0		# return 0;
	jr	$ra

