# read a mark and print the corresponding UNSW grade
#
# Before starting work on this task, make sure you set your tab-width to 8!
# It is also suggested to indent with tabs only.
#
# Caitlin Wong, 24/09/2023

main:
	# Locals:
	# - $t0: int n

	la		$a0, prompt		# printf("Enter a mark: ");
	li		$v0, 4
	syscall

	li		$v0, 5			# scanf("%d", mark);
	syscall
	move	$t0, $v0

	blt		$v0, 50, fail		# if mark < 50
	blt		$v0, 65, pass		# if mark < 50
	blt		$v0, 75, credit		# if mark < 50
	blt		$v0, 85, dinst		# if mark < 50

	li		$v0, 4			# syscall 4: print_string
	la		$a0, hd
	syscall					# printf("HD\n");

	b 		epilogue

fail:
	li		$v0, 4			# syscall 4: print_string
	la		$a0, fl
	syscall					# printf("FL\n");

	b 		epilogue

pass:
	li		$v0, 4			# syscall 4: print_string
	la		$a0, ps
	syscall					# printf("PS\n");

	b 		epilogue

credit:
	li		$v0, 4			# syscall 4: print_string
	la		$a0, cr
	syscall					# printf("CR\n");

	b 		epilogue

dinst:
	li		$v0, 4			# syscall 4: print_string
	la		$a0, dn
	syscall					# printf("DN\n");

	b 		epilogue

epilogue:
	li		$v0, 0
	jr		$ra				# return 0

	.data
prompt:
	.asciiz "Enter a mark: "
fl:
	.asciiz "FL\n"
ps:
	.asciiz "PS\n"
cr:
	.asciiz "CR\n"
dn:
	.asciiz "DN\n"
hd:
	.asciiz "HD\n"
