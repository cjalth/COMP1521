# Prints hello world in MIPS 
# When writing assembly, do comments on the same line

# li = load immediate: for immediate, fixed values that you need to load into a register with an instruction
# la = load address: for loading fixed addresses into a register
# move is for copying values between two registers

    .text
main:

	li	    $v0, 4			        # syscall 4: print_string
	la	    $a0, hello_world_msg	# label: an easy way to refer to the place the string lives in memory
	syscall				            # printf("Hello world\n");


	li	    $v0, 0
	jr	    $ra			# return 0;

	.data

hello_world_msg:
	.asciiz	"Hello world\n"