# Constants
ARRAY_LEN = 10

main:
	# Registers:
	#   - $t0: int x
	#   - $t2: int n_seen
	#   - $t3: temporary result
	#   - $t4: temporary result

slow_loop__init:
	li		$t2, 0			
slow_loop__cond:
	bge		$t2, ARRAY_LEN, slow_loop__end	

slow_loop__body:
	li		$v0, 4				
	la		$a0, prompt_str			
	syscall					

	li		$v0, 5				
	syscall					
	move	$t0, $v0			

	li		$t3, 0			

	j		mini_loop

slow_loop__if:
	bne		$t3, $t2, slow_loop__cond

	mul		$t3, $t2, 4			
	sw		$t0, numbers($t3)		

	addi	$t2, $t2, 1			
	j		slow_loop__cond

slow_loop__end:					

	li		$v0, 4				
	la		$a0, result_str			
	syscall						# printf("10th different number was: ");

	li		$v0, 1				
	move	$a0, $t0			
	syscall						# printf("%d", x);

	li		$v0, 11					
	li		$a0, '\n'			
	syscall						# putchar('\n');

	j		epilogue

mini_loop:
	bge		$t3, $t2, slow_loop__if		# while (i < n_seen)

	la		$t4, numbers
	mul		$t5, $t3, 4
	add		$t4, $t4, $t5
	lw		$t6, ($t4)

	beq		$t0, $t6, slow_loop__if		# if (x == numbers[i])

	add		$t3, $t3, 1			# i++;

	j		mini_loop

epilogue:
	li		$v0, 0
	jr		$ra				# return 0;

########################################################################
# .DATA
	.data
numbers:
	.space 4 * ARRAY_LEN			# int numbers[ARRAY_LEN];
prompt_str:
	.asciiz	"Enter a number: "
result_str:
	.asciiz	"10th different number was: "
