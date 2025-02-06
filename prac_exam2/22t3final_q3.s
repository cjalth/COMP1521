# COMP1521 22T3 ... final exam, question 3

# this code reads 1 integer and prints it
# change it to read integers until their sum is >= 42
# and then print their sum

main:
	li	$t0, 0		# int sum = 0;

loop: 
	bge	$t0, 42, print	
	li	$v0, 5		#   scanf("%d", &x);
	syscall			#
	move	$t1, $v0	

	add	$t0, $t0, $t1

	b	loop

print:
	li	$v0, 1
	move	$a0, $t0
	syscall

	li	$a0, '\n'	#   printf("%c", '\n');
	li	$v0, 11
	syscall

	li	$v0, 0		# return 0
	jr	$ra
