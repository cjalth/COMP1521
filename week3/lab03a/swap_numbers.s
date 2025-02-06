# Reads 10 numbers into an array,
# swaps any pairs of of number which are out of order
# and then prints the 10 numbers
# Caitlin Wong, 12/06/2024

# Constants
ARRAY_LEN = 10

main:
	# Registers:
	#  - $t0: int i
	#  - $t1: temporary result
	#  - $t2: temporary result
	#  - $t3: temporary result
	#  - $t4: temp result
	#  - $t5: numbers[i] 
	#  - $t6: numbers[i - 1]

scan_loop__init:
	li		$t0, 0				# i = 0;

scan_loop__cond:
	bge		$t0, ARRAY_LEN, scan_loop__end	# while (i < ARRAY_LEN) {

scan_loop__body:
	li		$v0, 5				#   syscall 5: read_int
	syscall						#   
								#
	mul		$t1, $t0, 4			#   calculate &numbers[i] == numbers + 4 * i
	la		$t2, numbers		#	load address of numbers[i] to $t2
	add		$t3, $t2, $t1		#	
	sw		$v0, ($t3)			#   scanf("%d", &numbers[i]);

	addi	$t0, $t0, 1			#   i++;
	j		scan_loop__cond		# }

scan_loop__end:
	li		$t0, 1				# i = 1;

swap_loop:
	bge		$t0, ARRAY_LEN, swap_end	# while (i < ARRAY_LEN) {

	mul		$t1, $t0, 4			#   calculate &numbers[i] == numbers + 4 * i
	la		$t2, numbers		#
	add		$t3, $t2, $t1		#	
	lw		$t5, ($t3)			#	int x = numbers[i]

	addi	$t4, $t3, -4		# 	make $t4 = &numbers[i - 1]
	lw		$t6, ($t4)			# 	$t6 = numbers[i - 1]

	bgt		$t6, $t5, swap		# if (x < y)

	addi	$t0, $t0, 1			# i++;
	j		swap_loop

swap:
	sw		$t6, ($t3)			# $t6 = numbers[i]
	sw		$t5, ($t4)			# $t5 = numbers[i - 1]
	j		swap_loop

swap_end:
	li		$t0, 0

print: 
	bge		$t0, ARRAY_LEN, print_end	# while (i < ARRAY_LEN) {

	mul		$t1, $t0, 4			#   calculate &numbers[i] == numbers + 4 * i
	la		$t2, numbers		#
	add		$t3, $t2, $t1		#
	lw		$a0, ($t3)			#
	li		$v0, 1				#   syscall 1: print_int
	syscall						#   printf("%d", numbers[i]);

	li		$a0, '\n'			#   printf("%c", '\n');
	li		$v0, 11				#   syscall 11: print_char
	syscall						

	addi	$t0, $t0, 1			#   i++
	j		print				# }

print_end:
	li	$v0, 0
	jr	$ra						# return 0;

	.data
numbers:
	.word	0:ARRAY_LEN			# int numbers[ARRAY_LEN] = {0};
