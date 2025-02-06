# Reads 10 numbers into an array
# printing 0 if they are in non-decreasing order
# or 1 otherwise.
# Caitlin Wong, 29/09/2023

# Constants
ARRAY_LEN = 10

main:
	# Registers:
	#  - $t0: int i
	#  - $t1: temporary result
	#  - $t2: temporary result
	#  - $t5: swapped

	li		$t0, 0				# i = 0;

scan_loop__cond:
	bge		$t0, ARRAY_LEN, scan_loop__end	# while (i < ARRAY_LEN) {

scan_loop__body:
	li		$v0, 5				#   syscall 5: read_int
	syscall						#   
								#
	mul		$t1, $t0, 4			#   calculate &numbers[i] == numbers + 4 * i
	la		$t2, numbers		#
	add		$t3, $t2, $t1		#
	sw		$v0, ($t3)			#   scanf("%d", &numbers[i]);

	addi	$t0, $t0, 1			#   i++;
	j		scan_loop__cond		# }
scan_loop__end:

	li		$t5, 0
	li		$t0, 1				# i = 1

check_loop:

	bge		$t0, 10, epilogue	# when i < 10

	mul		$t1, $t0, 4			# calculate &numbers[i] == numbers + 4 * i
	la		$t2, numbers		#
	add		$t3, $t2, $t1		#
	lw		$t6, ($t3)			# $t6 = numbers[i]

	addi	$t4, $t3, -4		# $t4 = numbers[i - 1]
	lw		$t7, ($t4)			# $t7 = numbers[i - 1]

	bge		$t6, $t7, continue	# checks if $t6 < $t7
	li		$t5, 1

continue:
	addi	$t0, $t0, 1
	b		check_loop

epilogue:

	move	$a0, $t5		
	li		$v0, 1
	syscall

	li		$a0, '\n'
	li		$v0, 11
	syscall

	li	$v0, 0
	jr	$ra				# return 0;

	.data
numbers:
	.word	0:ARRAY_LEN			# int numbers[ARRAY_LEN] = {0};
