# Caitlin Wong, z5477471, 8/10/2023

########################################################################
# .DATA
# Here are some handy strings for use in your code.

	.data
prompt_str:
	.asciiz "Enter a random seed: "
result_str:
	.asciiz "The random result is: "

########################################################################
# .TEXT <main>
	.text
main:

	# Args: void
	# Returns: int
	#
	# Frame:	[...]
	# Uses: 	[...]
	# Clobbers:	[...]
	#
	# Locals:
	#   - ...
	#
	# Structure:
	#   - main
	#     -> [prologue]
	#     -> [body]
	#     -> [epilogue]

main__prologue:
	begin
	# TODO: add code to set up your stack frame here 
	push	$ra
	push	$s0

main__body:
	# TODO: complete your function body here

	li	$v0, 4
	la	$a0, prompt_str
	syscall			# printf("Enter a random seed: ");

	li	$v0, 5
	syscall			# scanf("%d", &random_seed);
	move	$a0, $v0	# int random_seed;

	jal	seed_rand	# seed_rand(random_seed);

	li	$a0, 100	# int value = rand(100);
	jal	rand
	move	$s0, $v0

	move 	$a0, $s0 	
	jal 	add_rand 	# value = add_rand(value);
	move 	$s0, $v0 

	move 	$a0, $s0 	# value = sub_rand(value);
	jal 	sub_rand 
	move 	$s0, $v0 

	move 	$a0, $s0 	# value = seq_rand(value);
	jal 	seq_rand 
	move 	$s0, $v0 

	la 	$a0, result_str 
	li 	$v0,4 
	syscall 		# printf("The random result is: ");

	move 	$a0, $s0 
	li 	$v0, 1 
	syscall 		# printf("%d", value);

	li 	$a0, '\n'
	li 	$v0,11 
	syscall			# printf("%c", '\n');

main__epilogue:
	# TODO: add code to clean up stack frame here
	pop	$s0
	pop	$ra
	end

	li	$v0, 0
	jr	$ra				# return 0;

########################################################################
# .TEXT <add_rand>
	.text
add_rand:
	# Args:
	#   - $a0: int value
	# Returns: int
	#
	# Frame:	[...]
	# Uses: 	[...]
	# Clobbers:	[...]
	#
	# Locals:
	#   - ...
	#
	# Structure:
	#   - add_rand
	#     -> [prologue]
	#     -> [body]
	#     -> [epilogue]

add_rand__prologue:
	begin
	# TODO: add code to set up your stack frame here
	push	$ra
	push	$a0

add_rand__body:
	# TODO: complete your function body here
	li	$a0, 0xFFFF
	jal	rand			# rand(0xFFFF);

	pop	$a0
	add	$v0, $v0, $a0

add_rand__epilogue:
	# TODO: add code to clean up stack frame here
	pop	$ra
	end

	jr	$ra			# return value


########################################################################
# .TEXT <sub_rand>
	.text
sub_rand:
	# Args:
	#   - $a0: int value
	# Returns: int
	#
	# Frame:	[...]
	# Uses: 	[...]
	# Clobbers:	[...]
	#
	# Locals:
	#   - ...
	#
	# Structure:
	#   - sub_rand
	#     -> [prologue]
	#     -> [body]
	#     -> [epilogue]

sub_rand__prologue:
	begin
	# TODO: add code to set up your stack frame here
	push	$ra
	push	$a0

sub_rand__body:
	# TODO: complete your function body here
	jal	rand			# rand(value);

	pop	$a0
	sub	$v0, $a0, $v0		# value - rand(value);

sub_rand__epilogue:
	# TODO: add code to clean up stack frame here
	pop	$ra
	end

	jr	$ra

########################################################################
# .TEXT <seq_rand>
	.text
seq_rand:
	# Args:
	#   - $a0: int value
	# Returns: int
	#
	# Frame:	[...]
	# Uses: 	[...]
	# Clobbers:	[...]
	#
	# Locals:
	#   - ...
	#
	# Structure:
	#   - seq_rand
	#     -> [prologue]
	#     -> [body]
	#     -> [epilogue]

seq_rand__prologue:
	begin
	# TODO: add code to set up your stack frame here
	push	$ra
	push	$s0
	push	$s1
	push	$s2

seq_rand__body:
	# TODO: complete your function body here
	move	$s0, $a0	
	li	$a0, 100	
	jal	rand		
	move	$s1, $v0	# limit = rand(100);

	li	$s2, 0		# int i = 0;
seq_rand__loop:
	bge	$s2, $s1, seq_rand__epilogue	# i < limit

	move	$a0, $s0	
	jal	add_rand
	move	$s0, $v0	# value = add_rand(value);

	addi	$s2, $s2, 1	# i++;
	j	seq_rand__loop

seq_rand__epilogue:
	# TODO: add code to clean up stack frame here
	move	$v0, $s0
	pop	$s2
	pop	$s1
	pop	$s0
	pop	$ra
	end
	
	jr	$ra



##
## The following are two utility functions, provided for you.
##
## You don't need to modify any of the following,
## but you may find it useful to read through.
## You'll be calling these functions from your code.
##

OFFLINE_SEED = 0x7F10FB5B

########################################################################
# .DATA
	.data
	
# int random_seed;
	.align 2
random_seed:
	.space 4


########################################################################
# .TEXT <seed_rand>
	.text
seed_rand:
# DO NOT CHANGE THIS FUNCTION

	# Args:
	#   - $a0: unsigned int seed
	# Returns: void
	#
	# Frame:	[]
	# Uses:		[$a0, $t0]
	# Clobbers:	[$t0]
	#
	# Locals:
	#   - $t0: offline_seed
	#
	# Structure:
	#   - seed_rand

	li	$t0, OFFLINE_SEED		# const unsigned int offline_seed = OFFLINE_SEED;
	xor	$t0, $a0			# random_seed = seed ^ offline_seed;
	sw	$t0, random_seed

	jr	$ra				# return;

########################################################################
# .TEXT <rand>
	.text
rand:
# DO NOT CHANGE THIS FUNCTION

	# Args:
	#   - $a0: unsigned int n
	# Returns:
	#   - $v0: int
	#
	# Frame:    []
	# Uses:     [$a0, $v0, $t0]
	# Clobbers: [$v0, $t0]
	#
	# Locals:
	#   - $t0: int rand
	#
	# Structure:
	#   - rand

	lw	$t0, random_seed 		# unsigned int rand = random_seed;
	multu	$t0, 0x5bd1e995  		# rand *= 0x5bd1e995;
	mflo	$t0
	addiu	$t0, 12345       		# rand += 12345;
	sw	$t0, random_seed 		# random_seed = rand;

	remu	$v0, $t0, $a0    
	jr	$ra              		# return rand % n;
