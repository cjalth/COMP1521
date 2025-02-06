# print a square of asterisks

main:
	li		$v0, 5		# scanf("%d", &x);
	syscall				
	move	$t0, $v0

	li		$t1, 0		# j = 1
	li		$t2, 0		# i = 1


loop1:
	bge		$t1, $t0, loop1_end		

	li		$a0, '*'		# printf("%c", '*');
	li		$v0, 11
	syscall 

	addi	$t1, $t1, 1		# j++
	j		loop1

loop1_end:
	li	$a0, '\n'			# printf("%c", '\n');
	li	$v0, 11
	syscall	

	addi	$t2, $t2, 1		# i++

	bge		$t2, $t0, end

	li		$t1, 0			# j = 0
	j		loop1

end:

	li	$v0, 0		# return 0
	jr	$ra
