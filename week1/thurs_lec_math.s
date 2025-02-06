# The mips translation of thurs_lec_maths.c

main:
	# Locals:
	# - $t0: int x
	# - $t1: int y
	# - $t2: int z

	li	    $t0, 17		    # int x = 17;
	li	    $t1, 25		    # int y = 25;

	li	    $v0, 1		    # syscall 1: print_int
	add	    $t2, $t0, $t1	# int z = x + y;
	mul	    $t2, $t2, 2 	# z = z * 2;	
	syscall			        # printf("%d", 2 * (x + y));

	li	    $v0, 11		    # syscall 11: print_char
	li	    $a0, '\n'	    #
	syscall			        # putchar('\n');

	li	    $v0, 0
	jr	    $ra		        # return 0;