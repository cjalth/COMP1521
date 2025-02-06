# Sieve of Eratosthenes
# https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes
# Caitlin Wong, z5477471, 8/10/2023

# Constants
ARRAY_LEN = 1000

main:
	# TODO: add your code here
	li	$t0, 2				# int i = 2;

loop:
	bge	$t0, ARRAY_LEN, epilogue	# i < ARRAY_LEN

	la	$t2, prime			# getting &prime[i]
	add	$t3, $t2, $t0			# 
	lb	$t4, ($t3)			# prime[i] loaded into $t3
	bne	$t4, 1, done			# if (prime[i])

	move	$a0, $t0			
	li	$v0, 1
	syscall					# printf("%d", i);

	li	$a0, '\n'
	li	$v0, 11
	syscall					# printf("%c", '\n'); 

	mul	$t1, $t0, 2			# int j = 2 * i

inner_loop:
	bge	$t1, ARRAY_LEN, done		# j < ARRAY_LEN
	la	$t2, prime			# get &prime[j]
	add	$t3, $t2, $t1
	sb	$0, ($t3)			# prime[j] = 0;

	add	$t1, $t1, $t0			# j++;
	j	inner_loop

done:
	add	$t0, $t0, 1			# i++;
	j	loop	

epilogue:
	li	$v0, 0
	jr	$ra			# return 0;

	.data
prime:
	.byte	1:ARRAY_LEN		# uint8_t prime[ARRAY_LEN] = {1, 1, ...};
