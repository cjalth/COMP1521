#  print the minimum of two integers
# $t0 = x
# $t1 = y

main:
	li		$v0, 5		# scanf("%d", &x);
	syscall				#
	move	$t0, $v0

	li		$v0, 5		# scanf("%d", &y);
	syscall				#
	move	$t1, $v0

check_min:
	bgt		$t1, $t0, print_1	# if (x < y) 

	move	$a0, $t1 	# printf("%d", y);
	li		$v0, 1
	syscall 

	j		end

print_1:
	move	$a0, $t0 	# printf("%d", x);
	li		$v0, 1
	syscall 

end:
	li		$a0, '\n'	# printf("%c", '\n');
	li		$v0, 11
	syscall
	
	li	$v0, 0		# return 0
	jr	$ra
