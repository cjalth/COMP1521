# prints the integers between x and y except 13

main:
	li		$v0, 5			# scanf("%d", &x);
	syscall					#
	move	$t0, $v0

	li		$v0, 5			# scanf("%d", &y);
	syscall					#
	move	$t1, $v0

	addi	$t2, $t0, 1		# i = x + 1

loop_check:
	bge		$t2, $t1, end

	bne		$t2, 13, print

	addi	$t2, $t2, 1		# i++
	j		loop_check

print: 
	move	$a0, $t2		# printf("%d\n", i);
	li		$v0, 1
	syscall	

	li		$a0, '\n'		# printf("%c", '\n');
	li		$v0, 11
	syscall	

	addi	$t2, $t2, 1		# i++

	j		loop_check

end:
	li	$v0, 0         # return 0
	jr	$ra
