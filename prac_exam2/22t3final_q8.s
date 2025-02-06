# COMP1521 22T3 ... final exam, question 8

# The provided code reads a line of input from the user,
# and then prints out 'T' on a new line.
# Modify it so that it evaluates the inputted boolean
# expression such that it matches 22t3final_q8.c 

#################################################################################
# .DATA
# DO NOT MODIFY THE DATA SEGMENT
	.data
buffer:
	.space	10000

s:
	.space	4

# Useful strings
msg_result_false:
	.asciiz	"F\n"
msg_result_true:
	.asciiz	"T\n"
#################################################################################
# .TEXT <main>
	.text
main:
	li	$v0, 8			# syscall 8: read_string
	la	$a0, buffer		#
	la	$a1, 10000		#
	syscall				# fgets(buffer, 256, stdin)

	# ADD/MODIFY CODE BELOW

	li	$v0, 4			# syscall 11: print_character
	la	$a0, msg_result_true	#
	syscall				# printf("%s", "T");

	li	$v0, 0			#
	jr	$ra			# return 0;


#################################################################################
# .TEXT <expression>
expression:
	# COMPLETE THIS FUNCTION
	jr	$ra

#################################################################################
# .TEXT <term>
term:
	# COMPLETE THIS FUNCTION
	jr	$ra

#################################################################################
# .TEXT <value>
value:
	# COMPLETE THIS FUNCTION
	jr	$ra



