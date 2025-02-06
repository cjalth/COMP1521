# Reads a line and prints whether it is a palindrome or not

LINE_LEN = 256

########################################################################
# .TEXT <main>
main:
	# Locals:
	#   - ...

	li		$v0, 4			
	la		$a0, line_prompt_str		
	syscall								# printf("Enter a line of input: ");

	li		$v0, 8				
	la		$a0, line			
	la		$a1, LINE_LEN			
	syscall								# fgets(buffer, LINE_LEN, stdin)

	li		$t0, 0						# int i = 0;

loop_1:
	la		$t1, line					# load address of line
	add		$t1, $t1, $t0				# $t2 becomes address of line[i]
	lb		$t2, ($t1)					# loads value of line[i]

	beqz	$t2, cont					# while (line[i] != 0) {

	add		$t0, $t0, 1					# i++;

	j		loop_1

cont:
	li		$t3, 0						# int j = 0;
	sub		$t4, $t0, 2					# int k = i - 2

loop_2:
	bge		$t3, $t4, results_pal

	la		$t1, line					# load address of line
	add		$t1, $t1, $t3				# $t2 becomes address of line[j]
	lb		$t2, ($t1)					# loads value of line[j]

	la		$t5, line					# load address of line
	add		$t5, $t5, $t4				# $t2 becomes address of line[k]
	lb		$t6, ($t5)					# loads value of line[k]

	bne		$t2, $t6, results_not_pal	# if (line[j] != line[k])

	add		$t3, $t3, 1					# j++;
	sub		$t4, $t4, 1					# k--;

	j		loop_2

results_not_pal:
	li		$v0, 4			
	la		$a0, result_not_palindrome_str	
	syscall					# printf("not palindrome\n");

	j		epilogue

results_pal:
	li		$v0, 4				
	la		$a0, result_palindrome_str	
	syscall					# printf("palindrome\n");

epilogue: 
	li		$v0, 0
	jr		$ra				# return 0;


########################################################################
# .DATA
	.data
# String literals
line_prompt_str:
	.asciiz	"Enter a line of input: "
result_not_palindrome_str:
	.asciiz	"not palindrome\n"
result_palindrome_str:
	.asciiz	"palindrome\n"

# Line of input stored here
line:
	.space	LINE_LEN

