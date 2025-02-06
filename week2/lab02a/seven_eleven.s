# Read a number and print positive multiples of 7 or 11 < n
#
# Before starting work on this task, make sure you set your tab-width to 8!
# It is also suggested to indent with tabs only.
#
# Caitlin Wong, 3/6/2024

#![tabsize(8)]

main:						# int main(void) {

	la		$a0, prompt		# printf("Enter a number: ");
	li		$v0, 4
	syscall

	li		$v0, 5			# scanf("%d", number);
	syscall
	move 	$t0, $v0

	li		$t1, 7			# int i = 7;

loop:

	bge		$t1, $t0, end	# If i >= inputted number, goto end

	move	$a0, $t1		# printf("%d", i);
	li		$v0, 1
	syscall

	li		$a0, '\n'		# printf("%c", '\n');
	li		$v0, 11
	syscall

	b		check

check: 

	addi	$t1, $t1, 1		# i = i + 1

	rem		$v0, $t1, 11
	beq		$v0, 0, loop

	rem		$v0, $t1, 7
	beq		$v0, 0, loop
	bne		$v0, 0, check

end:
	li		$v0, 0
	jr		$ra		# return 0

	.data
prompt:
	.asciiz "Enter a number: "

