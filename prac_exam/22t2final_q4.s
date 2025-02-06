	.data
numbers:
	.word 0:10	# int numbers[10] = { 0 };

	.text
main:
	li		$t0, 0		# i = 0;

main__input_loop:
	bge		$t0, 10, main__input_finished	# while (i < 10) {

	li		$v0, 5				# syscall 5: read_int
	syscall
	mul		$t1, $t0, 4
	sw		$v0, numbers($t1)	#	scanf("%d", &numbers[i]);
	
	addi	$t0, 1			#	i++;
	b		main__input_loop	# }

main__input_finished:
	li		$t1, 1		# int max_run = 1;
	li		$t2, 1		# int current_run = 1;
	li		$t0, 1		# int i = 1;

loop_2:
	bge		$t0, 10, main__print_42		# while (i < 10)

	mul		$t4, $t0, 4
	sub		$t5, $t4, 4
	lw		$t4, numbers($t4)
	lw		$t5, numbers($t5)
	ble		$t4, $t5, reset_current

	add		$t2, $t2, 1

loop_cont:
	ble		$t2, $t1, loop_add
	move	$t1, $t2

loop_add:
	add		$t0, $t0, 1

	b 		loop_2

reset_current:
	li		$t2, 1

	b 		loop_cont

main__print_42:
	li		$v0, 1		# syscall 1: print_int
	move	$a0, $t1
	syscall			# printf("42");

	li	$v0, 11		# syscall 11: print_char
	li	$a0, '\n'
	syscall			# printf("\n");

	li	$v0, 0
	jr	$ra		# return 0;
