# Reads a line and print its length

LINE_LEN = 256

########################################################################
# .TEXT <main>
main:
	# Locals:
	#   - $t0, $t1, $t2, $t3

	li		$v0, 4			
	la		$a0, line_prompt_str	
	syscall					# printf("Enter a line of input: ");

	li		$v0, 8			
	la		$a0, line		
	la		$a1, LINE_LEN		
	syscall					# fgets(buffer, LINE_LEN, stdin)

	li		$t0, 0			# int i = 0;

loop:	
	la		$t1, line		# load address of line
	add		$t2, $t1, $t0	# $t2 becomes address of line[i]
	lb		$t3, ($t2)		# loads value of line[i]

	beqz	$t3, results	# while (line[i] != 0) {

	add		$t0, $t0, 1		# i++;

	j		loop

results:
	li		$v0, 4			
	la		$a0, result_str		
	syscall				# printf("Line length: ");

	li		$v0, 1
	move	$a0, $t0				
	syscall				# printf("%d", i);

	li		$v0, 11			
	li		$a0, '\n'		
	syscall				# putchar('\n');

	li		$v0, 0
	jr		$ra			# return 0;

########################################################################
# .DATA
	.data
# String literals
line_prompt_str:
	.asciiz	"Enter a line of input: "
result_str:
	.asciiz	"Line length: "

# Line of input stored here
line:
	.space	LINE_LEN

