# A simple MIPS program that calculates the Gaussian sum between two numbers

# Written by Caitlin Wong (z5477471)
# on the 27/05/2024

# int main(void)
# {
#   int number1, number2;
#
#   printf("Enter first number: ");
#   scanf("%d", &number1);
#
#   printf("Enter second number: ");
#   scanf("%d", &number2);
#
#   int gaussian_sum = ((number2 - number1 + 1) * (number1 + number2)) / 2;
#
#   printf("The sum of all numbers between %d and %d (inclusive) is: %d\n", number1, number2, gaussian_sum);
#
#   return 0;
# }

main:
  la   $a0, prompt1   # printf("Enter first number: ");
  li   $v0, 4
  syscall

	li		$v0, 5				# scanf("%d", number1);
	syscall
  move	$t0, $v0			# first number = $t0

  la   $a0, prompt2   # printf("Enter second number: ");
  li   $v0, 4
  syscall

	li		$v0, 5				# scanf("%d", number2);
	syscall
  move	$t1, $v0			# second number = $t1

  sub   $t2, $t1, $t0 # number2 - number1
  add   $t2, $t2, 1   # number2 - number1 + 1

  add   $t3, $t0, $t1 # number1 + number2
  mul   $t4, $t2, $t3 # (number2 - number1 + 1) * (number1 + number2)
  div   $t5, $t4, 2

  la   $a0, answer1   # printf("The sum of all numbers between ");
  li   $v0, 4
  syscall

  move   $a0, $t0     # printf("%d", number1);
  li   $v0, 1
  syscall

  la   $a0, answer2   # printf(" and ");
  li   $v0, 4
  syscall

  move    $a0, $t1     # printf("%d", number2);
  li      $v0, 1
  syscall

  la   $a0, answer3   # printf(" (inclusive) is: ");
  li   $v0, 4
  syscall

  move    $a0, $t5     # printf("%d", gaussian_sum);
  li      $v0, 1
  syscall

  li		$a0, '\n'			# printf("%c", '\n');
	li		$v0, 11
	syscall

  li   $v0, 0
  jr   $ra          # return


.data
  prompt1: .asciiz "Enter first number: "
  prompt2: .asciiz "Enter second number: "

  answer1: .asciiz "The sum of all numbers between "
  answer2: .asciiz " and "
  answer3: .asciiz " (inclusive) is: "
