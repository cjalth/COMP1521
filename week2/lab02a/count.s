# read a number n and print the integers 1..n one per line
#
# Before starting work on this task, make sure you set your tab-width to 8!
# It is also suggested to indent with tabs only.
#
# Caitlin Wong, 3/6/2024

#![tabsize(8)]


main:                 			# int main(void)
	la		$a0, prompt			# printf("Enter a number: ");
	li		$v0, 4
	syscall

	li		$v0, 5				# scanf("%d", number);
	syscall
	move 	$t0, $v0
	
	li		$t1, 1				# int i = 1

loop:
	bgt		$t1, $t0, end		# If i > inputted number, goto finish

	move	$a0, $t1			# printf("%d", i);
	li		$v0, 1
	syscall

	li		$a0, '\n'			# printf("%c", '\n');
	li		$v0, 11
	syscall

	addi	$t1, $t1, 1			# add 1 to i

	b		loop				# goto loop

end:
	li			$v0, 0
	jr			$ra		# return 0

	.data
prompt:
	.asciiz "Enter a number: "
