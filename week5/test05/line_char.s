#  Reads a line from stdin and an integer n,
#  and then prints the character in the nth-position

LINE_LEN = 256

########################################################################
# .TEXT <main>
main:
	# Locals:
	#   - $t0: int n
	#   - $t1: line address
	#	- $t2: line[n] address
	#	- $t3: value of line[n]

	li		$v0, 4			
	la		$a0, line_prompt_str	
	syscall					# printf("Enter a line of input: ");

	li		$v0, 8			
	la		$a0, line		
	la		$a1, LINE_LEN		
	syscall					# fgets(buffer, LINE_LEN, stdin)

	li		$v0, 4			
	la		$a0, pos_prompt_str	
	syscall					# printf("Enter a position: ");

	li		$v0, 5			
	syscall				
	move	$t0, $v0		# scanf("%d", &n);

	li		$v0, 4			
	la		$a0, result_str		
	syscall					# printf("Character is: ");

	la		$t1, line		# load address of line
	add		$t2, $t1, $t0	# $t2 becomes address of line[n]
	lb		$t3, ($t2)		# loads value of line[n]

	li		$v0, 11			
	move	$a0, $t3		
	syscall					# putchar(line[n]);

	li		$v0, 11			
	li		$a0, '\n'		
	syscall					# putchar('\n');

	li		$v0, 0
	jr		$ra				# return 0;

########################################################################
# .DATA
	.data
# String literals
line_prompt_str:
	.asciiz	"Enter a line of input: "
pos_prompt_str:
	.asciiz	"Enter a position: "
result_str:
	.asciiz	"Character is: "

# Line of input stored here
line:
	.space	LINE_LEN

