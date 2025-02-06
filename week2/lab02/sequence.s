# Read three numbers `start`, `stop`, `step`
# Print the integers bwtween `start` and `stop` moving in increments of size `step`
#
# Before starting work on this task, make sure you set your tab-width to 8!
# It is also suggested to indent with tabs only.
#
# Caitlin Wong, 24/09/2023


main:							# int main(void)
	la		$a0, prompt1		# printf("Enter the starting number: ");
	li		$v0, 4
	syscall
	li		$v0, 5				# scanf("%d", number);
	syscall
	move	$t0, $v0			# starting number = $t0
	move	$t3, $t0			# i = starting number

	la		$a0, prompt2		# printf("Enter the stopping number: ");
	li		$v0, 4
	syscall
	li		$v0, 5				# scanf("%d", number);
	syscall
	move	$t1, $v0			# stopping number = $t1

	la		$a0, prompt3		# printf("Enter the step size: ");
	li		$v0, 4
	syscall
	li		$v0, 5				# scanf("%d", number);
	syscall
	move	$t2, $v0			# step number = $t2



	bgt		$t1, $t0, pos_loop	# if start < stop, goto positive loop
	blt		$t1, $t0, neg_loop	# if start > stop, goto negative loop

	b		end

pos_loop:
	ble		$t2, 0, end
	bge		$t3, $t1, end

	move	$a0, $t3			# printf("%d", i);
	li		$v0, 1
	syscall

	li		$a0, '\n'			# printf("%c", '\n');
	li		$v0, 11
	syscall

	add		$t3, $t3, $t2		# i = i + step number

	b		pos_loop

neg_loop:
	bge		$t2, 0, end
	ble		$t3, $t1, end

	move	$a0, $t3			# printf("%d", 42);
	li		$v0, 1
	syscall

	li		$a0, '\n'			# printf("%c", '\n');
	li		$v0, 11
	syscall

	add		$t3, $t3, $t2		# i = i + step number

	b		neg_loop

end:
	li		$v0, 0
	jr		$ra					# return 0

	.data
prompt1:
	.asciiz "Enter the starting number: "
prompt2:
	.asciiz "Enter the stopping number: "
prompt3:
	.asciiz "Enter the step size: "
