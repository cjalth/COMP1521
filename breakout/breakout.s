########################################################################
# COMP1521 24T2 -- Assignment 1 -- Breakout!
#
#
# !!! IMPORTANT !!!
# Before starting work on the assignment, make sure you set your tab-width to 8!
# It is also suggested to indent with tabs only.
# Instructions to configure your text editor can be found here:
#   https://cgi.cse.unsw.edu.au/~cs1521/24T2/resources/mips-editors.html
# !!! IMPORTANT !!!
#
#
# This program was written by Caitlin Wong (z5477471)
# on 11-06-2024
#
# Version 1.0 (2024-06-11): Team COMP1521 <cs1521@cse.unsw.edu.au>
#
########################################################################

#![tabsize(8)]

# ##########################################################
# ####################### Constants ########################
# ##########################################################

# C constants
FALSE = 0
TRUE  = 1

MAX_GRID_WIDTH = 60
MIN_GRID_WIDTH = 6
GRID_HEIGHT    = 12

BRICK_ROW_START = 2
BRICK_ROW_END   = 7
BRICK_WIDTH     = 3
PADDLE_WIDTH    = 6
PADDLE_ROW      = GRID_HEIGHT - 1

BALL_FRACTION  = 24
BALL_SIM_STEPS = 3
MAX_BALLS      = 3
BALL_NONE      = 'X'
BALL_NORMAL    = 'N'
BALL_SUPER     = 'S'

VERTICAL       = 0
HORIZONTAL     = 1

MAX_SCREEN_UPDATES = 24

KEY_LEFT        = 'a'
KEY_RIGHT       = 'd'
KEY_SUPER_LEFT  = 'A'
KEY_SUPER_RIGHT = 'D'
KEY_STEP        = '.'
KEY_BIG_STEP    = ';'
KEY_SMALL_STEP  = ','
KEY_DEBUG_INFO  = '?'
KEY_SCREEN_UPD  = 's'
KEY_HELP        = 'h'

# NULL is defined in <stdlib.h>
NULL  = 0

# Other useful constants
SIZEOF_CHAR = 1
SIZEOF_INT  = 4

BALL_X_OFFSET      = 0
BALL_Y_OFFSET      = 4
BALL_X_FRAC_OFFSET = 8
BALL_Y_FRAC_OFFSET = 12
BALL_DX_OFFSET     = 16
BALL_DY_OFFSET     = 20
BALL_STATE_OFFSET  = 24
# <implicit 3 bytes of padding>
SIZEOF_BALL = 28

SCREEN_UPDATE_X_OFFSET = 0
SCREEN_UPDATE_Y_OFFSET = 4
SIZEOF_SCREEN_UPDATE   = 8

MANY_BALL_CHAR = '#'
ONE_BALL_CHAR  = '*'
PADDLE_CHAR    = '-'
EMPTY_CHAR     = ' '
GRID_TOP_CHAR  = '='
GRID_SIDE_CHAR = '|'

	.data
# ##########################################################
# #################### Global variables ####################
# ##########################################################

# !!! DO NOT ADD, REMOVE, OR MODIFY ANY OF THESE DEFINITIONS !!!

grid_width:			# int grid_width;
	.word	0

balls:				# struct ball balls[MAX_BALLS];
	.byte	0:MAX_BALLS*SIZEOF_BALL

bricks:				# char bricks[GRID_HEIGHT][MAX_GRID_WIDTH];
	.byte	0:GRID_HEIGHT*MAX_GRID_WIDTH

bricks_destroyed:		# int bricks_destroyed;
	.word	0

total_bricks:			# int total_bricks;
	.word	0

paddle_x:			# int paddle_x;
	.word	0

score:				# int score;
	.word	0

combo_bonus:			# int combo_bonus;
	.word	0

screen_updates:			# struct screen_update screen_updates[MAX_SCREEN_UPDATES];
	.byte	0:MAX_SCREEN_UPDATES*SIZEOF_SCREEN_UPDATE

num_screen_updates:		# int num_screen_updates;
	.word	0

whole_screen_update_needed:	# int whole_screen_update_needed;
	.word	0

no_auto_print:			# int no_auto_print;
	.word	0


# ##########################################################
# ######################### Strings ########################
# ##########################################################

# !!! DO NOT ADD, REMOVE, OR MODIFY ANY OF THESE STRINGS !!!

str_print_welcome_1:
	.asciiz	"Welcome to 1521 breakout! In this game you control a "
str_print_welcome_2:
	.asciiz	"paddle (---) with\nthe "
str_print_welcome_3:	# note: this string is used twice
	.asciiz	" and "
str_print_welcome_4:
	.asciiz	" (or "
str_print_welcome_5:
	.asciiz	" for fast "
str_print_welcome_6:
	.asciiz	"movement) keys, and your goal is\nto bounce the ball ("
str_print_welcome_7:
	.asciiz	") off of the bricks (digits). Every ten "
str_print_welcome_8:
	.asciiz	"bricks\ndestroyed spawns an extra ball. The "
str_print_welcome_9:
	.asciiz	" key will advance time one step.\n\n"

str_read_grid_width_prompt:
	.asciiz	"Enter the width of the playing field: "
str_read_grid_width_out_of_bounds_1:
	.asciiz	"Bad input, the width must be between "
str_read_grid_width_out_of_bounds_2:
	.asciiz	" and "
str_read_grid_width_not_multiple:
	.asciiz	"Bad input, the grid width must be a multiple of "

str_game_loop_win:
	.asciiz	"\nYou win! Congratulations!\n"
str_game_loop_game_over:
	.asciiz	"Game over :(\n"
str_game_loop_final_score:
	.asciiz	"Final score: "

str_print_game_score:
	.asciiz	" SCORE: "

str_hit_brick_bonus_ball:
	.asciiz	"\n!! Bonus ball !!\n"

str_run_command_prompt:
	.asciiz	" >> "
str_run_command_bad_cmd_1:
	.asciiz	"Bad command: '"
str_run_command_bad_cmd_2:
	.asciiz	"'. Run `h` for help.\n"

str_print_debug_info_1:
	.asciiz	"      grid_width = "
str_print_debug_info_2:
	.asciiz	"        paddle_x = "
str_print_debug_info_3:
	.asciiz	"bricks_destroyed = "
str_print_debug_info_4:
	.asciiz	"    total_bricks = "
str_print_debug_info_5:
	.asciiz	"           score = "
str_print_debug_info_6:
	.asciiz	"     combo_bonus = "
str_print_debug_info_7:
	.asciiz	"        num_screen_updates = "
str_print_debug_info_8:
	.asciiz	"whole_screen_update_needed = "
str_print_debug_info_9:
	.asciiz	"ball["
str_print_debug_info_10:
	.asciiz	"  y: "
str_print_debug_info_11:
	.asciiz	", x: "
str_print_debug_info_12:
	.asciiz	"  x_fraction: "
str_print_debug_info_13:
	.asciiz	"  y_fraction: "
str_print_debug_info_14:
	.asciiz	"  dy: "
str_print_debug_info_15:
	.asciiz	", dx: "
str_print_debug_info_16:
	.asciiz	"  state: "
str_print_debug_info_17:
	.asciiz	" ("
str_print_debug_info_18:
	.asciiz	")\n"
str_print_debug_info_19:
	.asciiz	"\nbricks["
str_print_debug_info_20:
	.asciiz	"]: "
str_print_debug_info_21:
	.asciiz	"]:\n"

# !!! Reminder to not not add to or modify any of the above !!!
# !!! strings or any other part of the data segment.        !!!
# !!! If you add more strings you will likely break the     !!!
# !!! autotests and automarking.                            !!!


############################################################
####                                                    ####
####   Your journey begins here, intrepid adventurer!   ####
####                                                    ####
############################################################

################################################################################
#
# Implement the following functions,
# and check these boxes as you finish implementing each function.
#
#  SUBSET 0
#  - [X] print_welcome
#  - [X] main
#  SUBSET 1
#  - [X] read_grid_width
#  - [X] game_loop
#  - [X] initialise_game
#  - [X] move_paddle
#  - [X] count_total_active_balls
#  - [X] print_cell
#  SUBSET 2
#  - [X] register_screen_update
#  - [X] count_balls_at_coordinate
#  - [X] print_game
#  - [X] spawn_new_ball
#  - [X] move_balls
#  SUBSET 3
#  - [X] move_ball_in_axis
#  - [X] hit_brick
#  - [ ] check_ball_paddle_collision
#  - [ ] move_ball_one_cell
#  PROVIDED
#  - [X] print_debug_info
#  - [X] run_command
#  - [X] print_screen_updates


################################################################################
# .TEXT <print_welcome>
        .text
print_welcome:
	# Subset:   0
	#
	# Frame:    [ $ra ] 
	# Uses:     [ $a0, $v0, $ra ]
	# Clobbers: [ $a0, $v0 ]
	#
	# Locals:
	#   - None
	#
	# Structure:
	#   print_welcome
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

print_welcome__prologue:
	begin
	push	$ra

print_welcome__body:
	li		$v0, 4			
	la		$a0, str_print_welcome_1
	syscall								# printf("Welcome to 1521 breakout! In this game you control a ");	

	li		$v0, 4			
	la		$a0, str_print_welcome_2
	syscall								# printf("paddle (---) with\nthe ");

	li		$v0, 11			
	la		$a0, KEY_LEFT
	syscall								# printf("%c", KEY_LEFT);

	li		$v0, 4			
	la		$a0, str_print_welcome_3
	syscall								# printf(" and ");

	li		$v0, 11			
	la		$a0, KEY_RIGHT
	syscall								# printf("%c", KEY_RIGHT);

	li		$v0, 4			
	la		$a0, str_print_welcome_4
	syscall								# printf(" (or ");

	li		$v0, 11			
	la		$a0, KEY_SUPER_LEFT
	syscall								# printf("%c", KEY_SUPER_LEFT);

	li		$v0, 4			
	la		$a0, str_print_welcome_3
	syscall								# printf(" and ");

	li		$v0, 11			
	la		$a0, KEY_SUPER_RIGHT
	syscall								# printf("%c", KEY_SUPER_RIGHT);

	li		$v0, 4			
	la		$a0, str_print_welcome_5
	syscall								# printf(" for fast ");

	li		$v0, 4			
	la		$a0, str_print_welcome_6
	syscall								# printf("movement) keys, and your goal is\nto bounce the ball (");

	li		$v0, 11			
	la		$a0, ONE_BALL_CHAR
	syscall								# printf("%c", ONE_BALL_CHAR);

	li		$v0, 4			
	la		$a0, str_print_welcome_7
	syscall								# printf(") off of the bricks (digits). Every ten ");

	li		$v0, 4			
	la		$a0, str_print_welcome_8
	syscall								# printf("bricks\ndestroyed spawns an extra ball. The ");

	li		$v0, 11			
	la		$a0, KEY_STEP
	syscall								# printf("%c", KEY_STEP);	

	li		$v0, 4			
	la		$a0, str_print_welcome_9
	syscall								# printf(" key will advance time one step.\n\n");

	li		$v0, 0						# return 0;

print_welcome__epilogue:
	pop		$ra
	end
	jr      $ra



################################################################################
# .TEXT <main>
        .text
main:
	# Subset:   0
	#
	# Frame:    [ $ra ]  
	# Uses:     [ $ra, $v0 ]
	# Clobbers: [ $v0 ]
	#
	# Locals:
	#   - None
	#
	# Structure:
	#   main
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

main__prologue:
	begin
	push	$ra

main__body:
	jal		print_welcome		# print_welcome();

	jal		read_grid_width		# read_grid_width();

	jal		initialise_game		# initialise_game();

	jal		game_loop			# game_loop();

	li		$v0, 0				# return 0;

main__epilogue:
	pop		$ra
	end
	jr		$ra


################################################################################
# .TEXT <read_grid_width>
        .text
read_grid_width:
	# Subset:   1
	#
	# Frame:    [ $ra ] 
	# Uses:     [ $ra, $v0, $a0, $t0, $t1 ]
	# Clobbers: [ $v0, $a0, $t0, $t1 ]
	#
	# Locals:           
	#   - $t0: grid_with
	#	- $t1: grid_width % BRICK_WIDTH
	#
	# Structure:       
	#   read_grid_width
	#   -> [prologue]
	#       -> body
	#		  -> out
	#		  -> multiple
	#		-> end
	#   -> [epilogue]

read_grid_width__prologue:
	begin
	push	$ra

read_grid_width__body:	
	li		$v0, 4			
	la		$a0, str_read_grid_width_prompt
	syscall												# printf("Enter the width of the playing field: ");

	li 		$v0, 5         								# scanf("%d", &grid_width);
    syscall
    sw 		$v0, grid_width 

	lw		$t0, grid_width

	bgt  	MIN_GRID_WIDTH, $t0, read_grid_width__out	# (!(MIN_GRID_WIDTH <= grid_width
	blt		MAX_GRID_WIDTH, $t0, read_grid_width__out	# ... && grid_width <= MAX_GRID_WIDTH))

	rem 	$t1, $t0, BRICK_WIDTH

	bnez	$t1, read_grid_width__multiple				# else if (grid_width % BRICK_WIDTH != 0)

	j		read_grid_width__end

read_grid_width__out:
	li		$v0, 4			
	la		$a0, str_read_grid_width_out_of_bounds_1
	syscall												# printf("Bad input, the width must be between ");

	li		$v0, 1			
	la		$a0, MIN_GRID_WIDTH
	syscall												# printf("%d", MIN_GRID_WIDTH);

	li		$v0, 4			
	la		$a0, str_read_grid_width_out_of_bounds_2
	syscall												# printf(" and ");

	li		$v0, 1			
	la		$a0, MAX_GRID_WIDTH
	syscall												# printf("%d", MAX_GRID_WIDTH);

	li		$a0, '\n'									# printf("%c", '\n');
	li		$v0, 11
	syscall	

	j 		read_grid_width__body

read_grid_width__multiple:
	li		$v0, 4			
	la		$a0, str_read_grid_width_not_multiple
	syscall												# printf("Bad input, the grid width must be a multiple of ");

	li		$v0, 1			
	la		$a0, BRICK_WIDTH
	syscall												# printf("%d", BRICK_WIDTH);

	li		$a0, '\n'									# printf("%c", '\n');
	li		$v0, 11
	syscall	

	j 		read_grid_width__body

read_grid_width__end:
	li		$a0, '\n'									# printf("%c", '\n');
	li		$v0, 11
	syscall	

read_grid_width__epilogue:
	pop		$ra
	end
	jr		$ra


################################################################################
# .TEXT <game_loop>
        .text
game_loop:
	# Subset:   1
	#
	# Frame:    [ $ra ]  
	# Uses:     [ $t0, $t1, $t2, $t3, $v0, $ra, $a0 ]
	# Clobbers: [ $t0, $t1, $t2, $t3, $v0, $a0 ]
	#
	# Locals:          
	#   - $t0: int bricks_destroyed 
	#	- $t1: int total_bricks
	#	- $t2: count_total_active_balls() 
	#	- $t3: int score
	#
	# Structure:       
	#   game_loop
	#   -> [prologue]
	#       -> body
	#		-> stop
	#		  -> win
	#		-> no_print
	#		-> end
	#   -> [epilogue]

game_loop__prologue:
	begin
	push	$ra

game_loop__body:
	lw		$t0, bricks_destroyed
	lw		$t1, total_bricks

	bge		$t0, $t1, game_loop__stop	# bricks_destroyed < total_bricks

	jal 	count_total_active_balls   
    move 	$t2, $v0 

	blez 	$t2, game_loop__stop		# ... && count_total_active_balls() > 0

	lw		$t3, no_auto_print

	bnez	$t3, game_loop__no_print	#  if (!no_auto_print)

	jal		print_game					# print_game();

game_loop__no_print:
	jal		run_command					#  while (!run_command()) ;

	beqz 	$v0, game_loop__no_print

	j 		game_loop__body

game_loop__stop:
	lw		$t0, bricks_destroyed
	lw		$t1, total_bricks

	beq		$t0, $t1, game_loop__win	#  if (bricks_destroyed == total_bricks)

	li		$v0, 4			
	la		$a0, str_game_loop_game_over
	syscall								# printf("Game over :(\n");		

	j  		game_loop__end

game_loop__win:
	li		$v0, 4			
	la		$a0, str_game_loop_win
	syscall								# printf("\nYou win! Congratulations!\n");

	j 		game_loop__end

game_loop__end:
	li		$v0, 4			
	la		$a0, str_game_loop_final_score
	syscall								# printf("Final score: ");

	lw		$t3, score

	li		$v0, 1			
	move	$a0, $t3
	syscall								# printf("%d", score);

	li		$a0, '\n'					# printf("%c", '\n');
	li		$v0, 11
	syscall	

game_loop__epilogue:
	pop		$ra
	end
	jr		$ra


################################################################################
# .TEXT <initialise_game>
        .text
initialise_game:
	# Subset:   1
	#
	# Frame:    [ $ra, $s1, $s2 ]   
	# Uses:     [ $ra, $s1, $s2, $t0, $t1, $t3, $t4, $t5, $t6 ]
	# Clobbers: [ $t0, $t1, $t3, $t4, $t5, $t6 ]
	#
	# Locals:           
	#   - $t0: int row, int i, paddle_x
	#	- $t1: address of balls, total_bricks
	#	- $t3: &bricks, i * SIZEOF_BALL + &balls, grid_width / BRICK_WIDTH
	# 	- $t4: &bricks[row][col], balls[i].state, BRICK_ROW_END
	#	- $t5: value of bricks[rows][col], BALL_NONE, 0
	#	- $t6: TRUE
	#	- $s1: int col
	#	- $s2: grid_width
	#
	# Structure:
	#   initialise_game
	#   -> [prologue]
	#       -> body
	#		  -> row_loop
	#			-> col_loop
	#			-> col_zero 
	#		  -> row_add 
	# 		-> balls
	# 		  -> balls_loop 
	#		-> end
	#   -> [epilogue]

initialise_game__prologue:
	begin
	push	$ra
	push	$s1
	push	$s2

initialise_game__body:
	li		$t0, 0								# int row = 0

initialise_game__row_loop:
	bge		$t0, GRID_HEIGHT, initialise_game__balls 

	li		$s1, 0								# int col = 0

	j 		initialise_game__col_loop

initialise_game__row_add:
	add		$t0, $t0, 1							# row++
	j 		initialise_game__row_loop

initialise_game__col_loop:
	lw		$s2, grid_width	
	bge		$s1, $s2, initialise_game__row_add	# col < grid_width

	la		$t3, bricks							# load bricks address
	mul		$t4, $t0, MAX_GRID_WIDTH			# row * MAX_GRID_WIDTH
	add		$t4, $t4, $s1						# row * MAX_GRID_WIDTH + col
	add 	$t4, $t4, $t3       				# $t4 = &bricks[row][col]

	bgt		BRICK_ROW_START, $t0, initialise_game__col_zero
	bgt		$t0, BRICK_ROW_END, initialise_game__col_zero

	div		$t5, $s1, BRICK_WIDTH				# col / BRICK_WIDTH
	rem		$t5, $t5, 10						# (col / BRICK_WIDTH) % 10
	addi	$t5, $t5, 1							# 1 + ((col / BRICK_WIDTH) % 10)
	sb		$t5, ($t4)							# ... = bricks[row][col];

	add		$s1, $s1, 1							# col++
	j 		initialise_game__col_loop

initialise_game__col_zero: 
	li		$t5, 0								# $t5 = 0
	sb		$t5, ($t4)							# bricks[row][col] = 0;

	add		$s1, $s1, 1							# col++
	j 		initialise_game__col_loop	

initialise_game__balls:
	li		$t0, 0								# int i = 0

initialise_game__balls_loop:
	bge		$t0, MAX_BALLS, initialise_game__end	
	
	la		$t1, balls							# load address of balls
	mul		$t3, $t0, SIZEOF_BALL				# i * SIZEOF_BALL
	add		$t3, $t3, $t1						# I * SIZEOF_BALLS + address of balls
	add		$t4, $t3, BALL_STATE_OFFSET			# balls[i].state + offset

	li		$t5, BALL_NONE						# load BALL_NONE into $t5

	sb		$t5, ($t4)							# balls[i].state = BALL_NONE;

	add		$t0, $t0, 1							# i++

	j 		initialise_game__balls_loop

initialise_game__end:	
	jal		spawn_new_ball						# spawn_new_ball();

	sub		$t0, $s2, PADDLE_WIDTH				# grid_width - PADDLE_WIDTH
	add		$t0, $t0, 1							# grid_width - PADDLE_WIDTH + 1
	div		$t0, $t0, 2							# (grid_width - PADDLE_WIDTH + 1) / 2;

    sw 		$t0, paddle_x						# paddle_x = (grid_width - PADDLE_WIDTH + 1) / 2;

	li		$t5, 0								# loads zero into $t5

	sw		$t5, score							# score = 0;
	sw		$t5, bricks_destroyed				# bricks_destroyed = 0;

	li		$t4, BRICK_ROW_END					# load BRICK_ROW_END into $t4
	
	sub		$t1, $t4, BRICK_ROW_START			# (BRICK_ROW_END - BRICK_ROW_START
	add		$t1, $t1, 1							#  ... + 1
	div		$t3, $s2, BRICK_WIDTH				# grid_width / BRICK_WIDTH
	mul		$t1, $t1, $t3						#  ... * (BRICK_ROW_END - BRICK_ROW_START + 1);

	sw		$t1, total_bricks					# ... = total_bricks 

	li		$t6, TRUE							# loads TRUE into $t6

	sw		$t5, num_screen_updates				# num_screen_updates = 0;
	sw		$t6, whole_screen_update_needed		# whole_screen_update_needed = TRUE;
	sw		$t5, no_auto_print					# no_auto_print = 0;

initialise_game__epilogue:
	pop		$s2
	pop		$s1
	pop		$ra
	end
	jr		$ra


################################################################################
# .TEXT <move_paddle>
        .text
move_paddle:
	# Subset:   1
	#
	# Frame:    [ $ra, $s0, $s1, $s2, $s3, $s4, $s5, $s6 ]
	# Uses:     [ $ra, $s0, $s1, $s2, $s3, $s4, $s5, $s6, $a0, $a1, $t4 ]
	# Clobbers: [ $a0, $a1, $t4 ]
	#
	# Locals:
	#   - $s0: paddle_x
	#   - $s1: int direction_indicator
	#   - $s2: paddle_x - direction_indicator
	#   - $s3: PADDLE_ROW
	#   - $s4: int direction
	#   - $s5: direction + paddle_x
	#   - $s6: paddle_x + PADDLE_WIDTH
	#   - $t4: grid_width
	#
	# Structure:
	#   move_paddle
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

move_paddle__prologue:
	begin
	push	$ra
	push	$s1
	push	$s2
	push	$s3
	push	$s4
	push	$s5
	push	$s6
	push	$s0

move_paddle__body:
	move	$s4, $a0						# int direction

	lw		$s0, paddle_x
	add		$s5, $s0, $s4

	bltz	$s5, move_paddle__epilogue		# paddle_x < 0

	add		$s6, $s5, PADDLE_WIDTH			# paddle_x + PADDLE_WIDTH
	lw		$t4, grid_width

	bgt		$s6, $t4, move_paddle__epilogue	# paddle_x + PADDLE_WIDTH > grid_width

	sw		$s5, paddle_x					# paddle_x += direction;

	jal		check_ball_paddle_collision		# check_ball_paddle_collision();

	add		$s1, $s4, 2						# direction + 2
	div		$s1, $s1, 2						# int direction_indicator = (direction + 2) / 2;

	sub		$s2, $s5, $s1					# $a0: paddle_x - direction_indicator
	move	$a0, $s2				
	li		$s3, PADDLE_ROW					# $a1: PADDLE_ROW
	move	$a1, $s3	

	jal		register_screen_update			# register_screen_update($a0, $a1);

	sub		$s2, $s6, $s1					
	move	$a0, $s2						# $a0: paddle_x + PADDLE_WIDTH - direction_indicator
	move	$a1, $s3						# $a1: PADDLE_ROW

	jal		register_screen_update			# register_screen_update($a0, $a1);

	j 		move_paddle__epilogue

move_paddle__epilogue:
	pop		$s0 
	pop		$s6
	pop		$s5
	pop		$s4
	pop		$s3
	pop		$s2
	pop		$s1
	pop		$ra
	end
	jr		$ra


################################################################################
# .TEXT <count_total_active_balls>
        .text
count_total_active_balls:
	# Subset:   1
	#
	# Frame:    [ $ra ]  
	# Uses:     [ $ra, $t0, $t1, $t3, $t4, $v0 ]
	# Clobbers: [ $t0, $t1, $t3, $t4, $v0 ]
	#
	# Locals:    
	#	- $t0: int count
	#	- $t1: int i
	#	- $t3: i * SIZEOF_BALL
	#	- $t4: balls[i].state
	#
	# Structure:
	#   count_total_active_balls
	#   -> [prologue]
	#       -> body
	#		  -> loop
	#		  -> add
	#		-> end
	#   -> [epilogue]

count_total_active_balls__prologue:
	begin
	push	$ra

count_total_active_balls__body:
	li		$t0, 0											# int count = 0;
	li		$t1, 0											# int i = 0

count_total_active_balls__loop:
	bge		$t1, MAX_BALLS, count_total_active_balls__end

	mul		$t3, $t1, SIZEOF_BALL							# i * SIZEOF_BALL
	add		$t4, $t3, BALL_STATE_OFFSET						# balls[i].state + offset
	lb      $t4, balls($t4)

	beq		$t4, BALL_NONE, count_total_active_balls__add	# if (balls[i].state != BALL_NONE)

	add		$t0, $t0, 1										# count++;

	j 		count_total_active_balls__add

count_total_active_balls__add:	
	add		$t1, $t1, 1										# i++;
	j 		count_total_active_balls__loop

count_total_active_balls__end:
	move	$v0, $t0										# return count

count_total_active_balls__epilogue:
	pop		$ra
	end
	jr		$ra


################################################################################
# .TEXT <print_cell>
        .text
print_cell:
	# Subset:   1
	#
	# Frame:    [ $ra, $s0, $s1 ] 
	# Uses:     [ $ra, $s0, $s1, $t0, $t1, $t2, $t3, 
	#			  $t4, $t5, $t6. $a0, $a1, $v0 ]
	# Clobbers: [ $t0, $t1, $t2, $t3, 
	#			  $t4, $t5, $t6. $a0, $a1, $v0 ]
	#
	# Locals: 
	#   - $s0: int row
	#	- $s1: int col
	#	- $t0: int ball_count
	#	- $t1: paddle_x
	#	- $t2: paddle_x + PADDLE_WIDTH
	#	- $t3: address of bricks
	#	- $t4: &bricks[row][col]
	#	- $t5: bricks[row][col]
	#	- $t6: PADDLE_CHAR, MANY_BALL_CHAR, ONE_BALL_CHAR, 
	#	       '0' + (bricks[row][col] - 1)
	#
	# Structure: 
	#   print_cell
	#   -> [prologue]
	#       -> body
	#		  -> many 
	#		  -> one 
	#		  -> bricks
	# 			-> empty
	#   -> [epilogue]

print_cell__prologue:
	begin
	push	$ra
	push	$s0
	push	$s1

print_cell__body:
	move	$s0, $a0
	move	$s1, $a1

	jal		count_balls_at_coordinate
	move	$t0, $v0							# int ball_count = count_balls_at_coordinate(row, col);

	bgt		$t0, 1, print_cell__many			# if (ball_count > 1)
	beq		$t0, 1, print_cell__one				# else if (ball_count == 1)

	bne 	$s0, PADDLE_ROW, print_cell__bricks	# if (row == PADDLE_ROW)
	lw		$t1, paddle_x
	bgt		$t1, $s1, print_cell__bricks		# paddle_x <= col
	add		$t2, $t1, PADDLE_WIDTH
	bge		$s1, $t2, print_cell__bricks		# col < paddle_x + PADDLE_WIDTH

	li		$t6, PADDLE_CHAR					# return PADDLE_CHAR;
	move	$v0, $t6
	j 		print_cell__epilogue

print_cell__many:
	li		$t6, MANY_BALL_CHAR					# return MANY_BALL_CHAR;
	move	$v0, $t6
	j 		print_cell__epilogue

print_cell__one:
	li		$t6, ONE_BALL_CHAR					# return ONE_BALL_CHAR;
	move	$v0, $t6
	j 		print_cell__epilogue

print_cell__bricks:
	la		$t3, bricks							# load bricks address
	mul		$t4, $s0, MAX_GRID_WIDTH			# row * MAX_GRID_WIDTH
	add		$t4, $t4, $s1						# row * MAX_GRID_WIDTH + col
	add 	$t4, $t4, $t3       				# $t4 = &bricks[row][col]
	lb		$t5, ($t4)	

	beqz 	$t5, print_cell__empty  			# if (bricks[row][col])

	sub		$t6, $t5, 1							# bricks[row][col] - 1
	add		$t6, $t6, '0'						# '0' + (bricks[row][col] - 1)

	move	$v0, $t6				
	j 		print_cell__epilogue

print_cell__empty:
	li		$t6, EMPTY_CHAR
	move	$v0, $t6

print_cell__epilogue:
	pop		$s1
	pop		$s0
	pop		$ra
	end
	jr		$ra


################################################################################
# .TEXT <register_screen_update>
        .text
register_screen_update:
	# Subset:   2
	#
	# Frame:    [ $ra ] 
	# Uses:     [ $ra, $t0, $t1, $t2, $t3, $t4, $t5, $t6, $a0, $a1 ]
	# Clobbers: [ $t0, $t1, $t2, $t3, $t4, $t5, $t6, $a0, $a1 ]
	#
	# Locals:          
	#   - $t0: int whole_screen_update_needed
	#   - $t1: int num_screen_updates
	#   - $t2: num_screen_updates * SIZEOF_SCREEN_UPDATE, TRUE
	#   - $t3: &screen_updates[num_screen_updates].x
	#   - $t4: screen_updates[num_screen_updates].x, int x
	#   - $t5: &screen_updates[num_screen_updates].y
	#   - $t6: screen_updates[num_screen_updates].y, int y
	#
	# Structure:      
	#   register_screen_update
	#   -> [prologue]
	#       -> body
	#		-> true
	#   -> [epilogue]

register_screen_update__prologue:
	begin
	push	$ra

register_screen_update__body:
	lw		$t0, whole_screen_update_needed

	beq 	$t0, 1, register_screen_update__epilogue

	lw		$t1, num_screen_updates
	bge 	$t1, MAX_SCREEN_UPDATES, register_screen_update__true

	mul		$t2, $t1, SIZEOF_SCREEN_UPDATE		# num_screen_updates * SIZEOF_SCREEN_UPDATE
	add		$t3, $t2, SCREEN_UPDATE_X_OFFSET	# add them
	lw		$t4, screen_updates($t3)			# loads screen_updates[num_screen_updates].x

	add		$t5, $t2, SCREEN_UPDATE_Y_OFFSET
	lw		$t6, screen_updates($t5)			# loads screen_updates[num_screen_updates].y

	move	$t4, $a0
	move	$t6, $a1

	sw		$t4, screen_updates($t3)			# screen_updates[num_screen_updates].x = x;
	sw		$t6, screen_updates($t5)			# screen_updates[num_screen_updates].y = y;

	add		$t1, $t1, 1
	sw		$t1, num_screen_updates				# num_screen_updates++;

	j 		register_screen_update__epilogue

register_screen_update__true:
	li		$t2, TRUE
	sw		$t2, whole_screen_update_needed

	j 		register_screen_update__epilogue

register_screen_update__epilogue:
	pop		$ra
	end
	jr		$ra


################################################################################
# .TEXT <count_balls_at_coordinate>
        .text
count_balls_at_coordinate:
	# Subset:   2
	#
	# Frame:    [ $ra ] 
	# Uses:     [ $ra, $t0, $t1, $t3, $t4, $t5, $t6, $t7, $a0, $a1, $v0 ]
	# Clobbers: [ $t0, $t1, $t3, $t4, $t5, $t6, $t7, $a0, $a1, $v0 ]
	#
	# Locals:          
	#   - $t0: int count
	#   - $t1: int i
	#   - $t3: i * SIZEOF_BALL
	#   - $t4: &balls[i].state, &balls[i].y, &balls[i].x
	#   - $t5: balls[i].state
	#   - $t6: balls[i].y	
	#	- $t7: balls[i].x
	#
	# Structure:       
	#   count_balls_at_coordinate
	#   -> [prologue]
	#       -> body
	#		  -> loop
	#		  -> add
	#		  -> end
	#   -> [epilogue]

count_balls_at_coordinate__prologue:
	begin
	push	$ra

count_balls_at_coordinate__body:
	li 		$t0, 0							# int count = 0;
	li		$t1, 0							# int i = 0;

count_balls_at_coordinate__loop:
	bge		$t1, MAX_BALLS, count_balls_at_coordinate__end

	mul		$t3, $t1, SIZEOF_BALL			# i * SIZEOF_BALL
	add		$t4, $t3, BALL_STATE_OFFSET		# balls[i].state 
	lb      $t5, balls($t4)

	beq		$t5, BALL_NONE, count_balls_at_coordinate__add

	add		$t4, $t3, BALL_Y_OFFSET			# balls[i].y	
	lw      $t6, balls($t4)

	bne 	$t6, $a0, count_balls_at_coordinate__add

	add		$t4, $t3, BALL_X_OFFSET			# balls[i].x	
	lw      $t7, balls($t4)

	bne 	$t7, $a1, count_balls_at_coordinate__add

	add		$t0, $t0, 1

count_balls_at_coordinate__add:
	add		$t1, $t1, 1
	j 		count_balls_at_coordinate__loop

count_balls_at_coordinate__end:
	move	$v0, $t0

count_balls_at_coordinate__epilogue:
	pop		$ra
	end
	jr		$ra


################################################################################
# .TEXT <print_game>
        .text
print_game:
	# Subset:   2
	#
	# Frame:    [ $ra, $s0, $s1 ]  
	# Uses:     [ $ra, $s0, $s1, $t0, $t3, $v0, $a0, $a1 ]
	# Clobbers: [ $s0, $s1, $t0, $t3, $v0, $a0, $a1 ]
	#
	# Locals:          
	#   - $s0: int row
	#	- $s1: int col
	#	- $t0: int score
	#	- $t3: int grid_width
	#
	# Structure:       
	#   print_game
	#   -> [prologue]
	#       -> body
	#		  -> row_loop
	#			-> col_loop
	#			  -> top_char
	#			  -> side_char
	#			-> col_add 
	#		  -> row_add
	#   -> [epilogue]

print_game__prologue:
	begin
	push	$ra
	push 	$s0
	push 	$s1

print_game__body:
	li		$v0, 4			
	la		$a0, str_print_game_score
	syscall									# printf(" SCORE: ");

	lw		$t0, score

	li		$v0, 1			
	move	$a0, $t0
	syscall									# printf("%d", score);

	li		$a0, '\n'						# printf("%c", '\n');
	li		$v0, 11
	syscall

	li		$s0, -1							# int row = -1

print_game__row_loop:
	bge		$s0, GRID_HEIGHT, print_game__epilogue
	
	li		$s1, -1							# int col = -1

print_game__col_loop:
	lw		$t3, grid_width

	bgt		$s1, $t3, print_game__row_add	# col <= grid_width

	beq		$s0, -1, print_game__top_char	# if (row == -1)
	beq		$s1, -1, print_game__side_char	# else if (col == -1)
	beq 	$s1, $t3, print_game__side_char # else if (col == grid_width)

	move	$a0, $s0
	move	$a1, $s1

	jal 	print_cell

	move	$a0, $v0						# putchar(print_cell(row, col));
	li		$v0, 11
	syscall

	j 		print_game__col_add

print_game__top_char:
	li		$a0, GRID_TOP_CHAR				# putchar(GRID_TOP_CHAR);
	li		$v0, 11
	syscall

	j 		print_game__col_add

print_game__side_char:
	li		$a0, GRID_SIDE_CHAR				# putchar(GRID_SIDE_CHAR);
	li		$v0, 11
	syscall

	j 		print_game__col_add

print_game__col_add:
	add		$s1, $s1, 1
	j 		print_game__col_loop

print_game__row_add:
	li		$a0, '\n'						# putchar('\n');
	li		$v0, 11
	syscall

	add		$s0, $s0, 1
	j 		print_game__row_loop

print_game__epilogue:
	pop 	$s1
	pop 	$s0
	pop		$ra
	end
	jr		$ra


################################################################################
# .TEXT <spawn_new_ball>
        .text
spawn_new_ball:
	# Subset:   2
	#
	# Frame:    [ $ra, $s0, $s1 ]  
	# Uses:     [ $ra, $s0, $s1, $t0, $t1, $t2, $t3, $t4, $t5, $t6, 
	#			  $t7, $t8, $a0, $a1, $v0 ]
	# Clobbers: [ $t0, $t1, $t2, $t3, $t4, $t5, $t6, 
	#			  $t7, $t8, $a0, $a1, $v0 ]
	#
	# Locals:    
	#	- $s0: struct ball *new_ball
	#	- $s1: grid_width
	#   - $t0: int i
	#   - $t1: address of balls, BALL_NORMAL
	#   - $t2: i * SIZEOF_BAL, PADDLE_ROW - 1
	#   - $t3: &balls[i]
	#   - $t4: &balls[i].state, grid_width / 2, TRUE, NULL
	#   - $t5: balls[i].state, BALL_FRACTION
	#   - $t6: BALL_NONE, BALL_FRACTION / BALL_SIM_STEPS
	#	- $t7: -BALL_FRACTION / BALL_SIM_STEPS
	# 	- $t8: BALL_FRACTION / 2
	#
	# Structure:       
	#   spawn_new_ball
	#   -> [prologue]
	#       -> body
	#		  -> loop
	#			-> no_ball 
	#		  -> loop_end
	#		-> true 
	#		-> null
	#   -> [epilogue]

spawn_new_ball__prologue:
	begin
	push	$ra
	push 	$s0
	push	$s1

spawn_new_ball__body:
	li		$s0, NULL

	li 		$t0, 0 							# int i = 0;

spawn_new_ball__loop:
	bge 	$t0, MAX_BALLS, spawn_new_ball__loop_end

	la		$t1, balls						# load address of balls
	mul		$t2, $t0, SIZEOF_BALL			# i * SIZEOF_BALL
	add		$t3, $t2, $t1					# address of balls[i];
	add		$t4, $t3, BALL_STATE_OFFSET		# balls[i].state + offset

	lb      $t5, ($t4)						# balls[i].state
	li		$t6, BALL_NONE

	beq		$t5, $t6, spawn_new_ball__no_ball

	add		$t0, $t0, 1
	j 		spawn_new_ball__loop

spawn_new_ball__no_ball:
	move	$s0, $t3

spawn_new_ball__loop_end:
	beq		$s0, NULL, spawn_new_ball__null

	li		$t1, BALL_NORMAL				# new_ball->state = BALL_NORMAL;
	sb		$t1, BALL_STATE_OFFSET($s0)

	li		$t2, PADDLE_ROW					# new_ball->y = PADDLE_ROW - 1;
	sub		$t2, $t2, 1
	sw		$t2, BALL_Y_OFFSET($s0)

	lw		$s1, grid_width					# new_ball->x = grid_width / 2;
	div		$t4, $s1, 2
	sw		$t4, BALL_X_OFFSET($s0)

	li		$t5, BALL_FRACTION
	div		$t8, $t5, 2
	sw		$t8, BALL_X_FRAC_OFFSET($s0)	# new_ball->x_fraction = BALL_FRACTION / 2;
	sw		$t8, BALL_Y_FRAC_OFFSET($s0)	# new_ball->y_fraction = BALL_FRACTION / 2;

	move	$a0, $t4
	move	$a1, $t2

	jal 	register_screen_update			# register_screen_update(new_ball->x, new_ball->y);

	li		$t6, BALL_SIM_STEPS
	div		$t6, $t5, $t6
	mul		$t7, $t6, -1
	sw 		$t7, BALL_DY_OFFSET($s0)		# new_ball->dy = -BALL_FRACTION / BALL_SIM_STEPS;

	div		$t6, $t6, 4
	sw 		$t6, BALL_DX_OFFSET($s0)		# new_ball->dx = BALL_FRACTION / BALL_SIM_STEPS / 4;

	rem		$s1, $s1, 2
	bnez	$s1, spawn_new_ball__true		# if (grid_width % 2 == 0)

	mul		$t6, $t6, -1
	sw 		$t6, BALL_DX_OFFSET($s0)		# new_ball->dx *= -1;

spawn_new_ball__true:
	li 		$t4, TRUE
	move	$v0, $t4
	j 		spawn_new_ball__epilogue

spawn_new_ball__null:
	li 		$t4, NULL
	move	$v0, $t4

spawn_new_ball__epilogue:
	pop		$s1
	pop 	$s0
	pop		$ra
	end
	jr		$ra


################################################################################
# .TEXT <move_balls>
        .text
move_balls:
	# Subset:   2
	#
	# Frame:    [ $ra, $s0, $s1, $s2, $s3 ]
	# Uses:     [ $a0, $a1, $a2, $a3, $v0, $s0, $s1, $s2, 
	#			  $s3, $t1, $t3, $t4, $t5, $t6, $t7, $ra ]
	# Clobbers: [ $a0, $a1, $a2, $a3, $t1 ]
	#
	# Locals:        
	# 	- $s0: struct ball *ball
	#   - $s1: int sim_steps 
	# 	- $s2: int i
	# 	- $s3: int step 
	#
	# Structure:        
	#   move_balls
	#   -> [prologue]
	#       -> body
	#	      -> step_loop 
	#			-> i_loop 
	#			-> i_add 
	#		  -> step_add
	#   -> [epilogue]

move_balls__prologue:
	begin
	push	$ra
	push	$s0
	push	$s1
	push	$s2
	push	$s3

move_balls__body:
	li		$s3, 0							# int step = 0;
	move	$s1, $a0						# sim_steps

move_balls__step_loop:
	bge		$s3, $s1, move_balls__epilogue	
	li		$s2, 0							# int i = 0;

move_balls__i_loop:
	bge		$s2, MAX_BALLS, move_balls__step_add

	la		$t1, balls						# load address of balls
	mul		$t3, $s2, SIZEOF_BALL			# i * SIZEOF_BALL
	add		$s0, $t3, $t1					# struct ball *ball = &balls[i];

	add		$t4, $s0, BALL_STATE_OFFSET		# balls[i].state + offset
	lb      $t5, ($t4)						# balls[i].state
	li		$t6, BALL_NONE
	beq		$t5, $t6, move_balls__i_add

	move	$a0, $s0 						# ball
	li		$a1, VERTICAL
	add		$a2, $s0, BALL_Y_FRAC_OFFSET	# &ball->y_fraction
	lw 		$a3, BALL_DY_OFFSET($s0)		# ball->dy
	jal		move_ball_in_axis

	move	$a0, $s0 						# ball
	li		$a1, HORIZONTAL
	add		$a2, $s0, BALL_X_FRAC_OFFSET	# &ball->x_fraction
	lw 		$a3, BALL_DX_OFFSET($s0)		# ball->dx
	jal		move_ball_in_axis

	li		$t1, GRID_HEIGHT
	lw		$t7, BALL_Y_OFFSET($s0)

	ble 	$t7, $t1, move_balls__i_add		# if (ball->y > GRID_HEIGHT)

	li		$t6, BALL_NONE
	sb		$t6, BALL_STATE_OFFSET($s0)		# ball->state = BALL_NONE;

move_balls__i_add:
	add		$s2, $s2, 1
	j 		move_balls__i_loop

move_balls__step_add:
	add		$s3, $s3, 1
	j 		move_balls__step_loop

move_balls__epilogue:
	pop		$s3
	pop		$s2
	pop 	$s1
	pop		$s0
	pop		$ra
	end
	jr		$ra


################################################################################
# .TEXT <move_ball_in_axis>
        .text
move_ball_in_axis:
	# Subset:   3
	#
	# Frame:    [ $ra, $s0 ]  
	# Uses:     [ $ra, $s0 ]
	# Clobbers: [...]
	#
	# Locals:          
	#   - $s0: int *fraction
	#
	# Structure:       
	#   move_ball_in_axis
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

move_ball_in_axis__prologue:
	begin
	push	$ra
	push	$s0

move_ball_in_axis__body:
	lw		$s0, ($a2)
	add		$s0, $s0, $a3				# *fraction += delta;
	move	$a3, $a2

move_ball_in_axis__loop: 
	blt		$s0, 0, move_ball_in_axis__plus				# if (*fraction < 0)
	bge		$s0, BALL_FRACTION, move_ball_in_axis__sub	# else if (*fraction >= BALL_FRACTION) 

	sw   	$s0, ($a3) 
	j 		move_ball_in_axis__epilogue					# break;

move_ball_in_axis__plus:
	add		$s0, $s0, BALL_FRACTION		# *fraction += BALL_FRACTION;
	sw   	$s0, ($a3)
	li		$a2, -1

	jal		move_ball_one_cell			# move_ball_one_cell(ball, axis, -1);

	j 		move_ball_in_axis__loop

move_ball_in_axis__sub:
	sub		$s0, $s0, BALL_FRACTION		# *fraction -= BALL_FRACTION;
	sw   	$s0, ($a3)
	li		$a2, 1

	jal		move_ball_one_cell			# move_ball_one_cell(ball, axis, 1);

	j 		move_ball_in_axis__loop

move_ball_in_axis__epilogue:
	pop		$s0
	pop		$ra
	end
	jr		$ra


################################################################################
# .TEXT <hit_brick>
        .text
hit_brick:
	# Subset:   3
	#
	# Frame:    [ $ra, $s0, $s1, $s2, $s3 ]  
	# Uses:     [ $ra, $s0, $s1, $s2, $s3, $t0, $t1, $t2, $t3, $t4, $a0, $a1, $v0 ]
	# Clobbers: [ $t0, $t1, $t2, $t3, $t4, $a0, $a1, $v0 ]
	#
	# Locals:          
	#	- $s0: int row
	#	- $s1: int original_col
	#	- $s2: int brick_num
	#	- $s3: int col
	#   - $t0: address of bricks, bricks_destroyed 
	#   - $t1: &bricks[row][original_col], &bricks[row][col]
	#   - $t2: bricks[row][col]
	#   - $t3: grid_width
	#   - $t4: 0
	#
	# Structure:       
	#   hit_brick
	#   -> [prologue]
	#       -> body
	#		  -> right_loop 
	#		  -> left_start 
	#		  -> left_loop 
	#		-> cont
	#   -> [epilogue]

hit_brick__prologue:
	begin
	push	$ra
	push	$s0
	push	$s1
	push	$s2
	push	$s3

hit_brick__body:
	move	$s0, $a0
	move	$s1, $a1

	la		$t0, bricks					# load bricks address
	mul		$t1, $s0, MAX_GRID_WIDTH	# row * MAX_GRID_WIDTH
	add		$t1, $t1, $s1				# row * MAX_GRID_WIDTH + original_col
	add 	$t1, $t1, $t0       		# $t1 = &bricks[row][original_col]
	lb		$s2, ($t1)	

	move	$s3, $s1					# int col = original_col

hit_brick__right_loop:
	lw		$t3, grid_width

	bge		$s3, $t3, hit_brick__left_start

	la		$t0, bricks					# load bricks address
	mul		$t1, $s0, MAX_GRID_WIDTH	# row * MAX_GRID_WIDTH
	add		$t1, $t1, $s3				# row * MAX_GRID_WIDTH + col
	add 	$t1, $t1, $t0       		# $t1 = &bricks[row][col]
	lb		$t2, ($t1)

	bne		$t2, $s2, hit_brick__left_start

	li		$t4, 0						# $t4 = 0
	sb		$t4, ($t1)					# bricks[row][col] = 0;

	move	$a0, $s3
	move	$a1, $s0

	jal		register_screen_update		# register_screen_update(col, row);

	add		$s3, $s3, 1					# col++;

	j 		hit_brick__right_loop

hit_brick__left_start:
	move	$s3, $s1
	sub		$s3, $s3, 1

hit_brick__left_loop:
	blt		$s3, $zero, hit_brick__cont

	la		$t0, bricks					# load bricks address
	mul		$t1, $s0, MAX_GRID_WIDTH	# row * MAX_GRID_WIDTH
	add		$t1, $t1, $s3				# row * MAX_GRID_WIDTH + col
	add 	$t1, $t1, $t0       		# $t1= &bricks[row][col]
	lb		$t2, ($t1)

	bne		$t2, $s2, hit_brick__cont

	li		$t4, 0						# $t4 = 0
	sb		$t4, ($t1)					# bricks[row][col] = 0;

	move	$a0, $s3
	move	$a1, $s0

	jal		register_screen_update		# register_screen_update(col, row);

	sub		$s3, $s3, 1					# col--;

	j 		hit_brick__left_loop

hit_brick__cont:
	lw		$t0, bricks_destroyed
	add		$t0, $t0, 1
	sw		$t0, bricks_destroyed		# bricks_destroyed++;

	rem		$t1, $t0, 10
	bnez	$t1, hit_brick__epilogue	# if (bricks_destroyed % 10 == 0 ...

	jal		spawn_new_ball

	beqz	$v0, hit_brick__epilogue	# ... && spawn_new_ball()) 

	li		$v0, 4			
	la		$a0, str_hit_brick_bonus_ball
	syscall								#  printf("\n!! Bonus ball !!\n");

hit_brick__epilogue:
	pop		$s3
	pop		$s2
	pop		$s1
	pop		$s0
	pop		$ra
	end
	jr		$ra


################################################################################
# .TEXT <check_ball_paddle_collision>
        .text
check_ball_paddle_collision:
	# Subset:   3
	#
	# Frame:    [...]  
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:          
	#   - ...
	#
	# Structure:       
	#   check_ball_paddle_collision
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

check_ball_paddle_collision__prologue:
	begin
	push	$ra

check_ball_paddle_collision__body:

check_ball_paddle_collision__epilogue:
	pop		$ra
	end
	jr		$ra


################################################################################
# .TEXT <move_ball_one_cell>
        .text
move_ball_one_cell:
	# Subset:   3
	#
	# Frame:    [...]  
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:          
	#   - ...
	#
	# Structure:       
	#   move_ball_one_cell
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

move_ball_one_cell__prologue:
	begin
	push	$ra

move_ball_one_cell__body:

move_ball_one_cell__epilogue:
	pop		$ra
	end
	jr		$ra


################################################################################
################################################################################
###                   PROVIDED FUNCTIONS — DO NOT CHANGE                     ###
################################################################################
################################################################################

################################################################################
# .TEXT <run_command>
        .text
run_command:
	# Provided
	#
	# Frame:    [$ra]
	# Uses:     [$ra, $t0, $a0, $v0]
	# Clobbers: [$t0, $a0, $v0]
	#
	# Locals:
	#   - $t0: char command
	#
	# Structure:
	#   run_command
	#   -> [prologue]
	#     -> body
	#       -> cmd_a
	#       -> cmd_d
	#       -> cmd_A
	#       -> cmd_D
	#       -> cmd_dot
	#       -> cmd_semicolon
	#       -> cmd_comma
	#       -> cmd_question_mark
	#       -> cmd_s
	#       -> cmd_h
	#       -> cmd_p
	#       -> cmd_q
	#       -> bad_cmd
	#       -> ret_true
	#   -> [epilogue]

run_command__prologue:
	push	$ra

run_command__body:
	li	$v0, 4						# syscall 4: print_string
	li	$a0, str_run_command_prompt			# " >> "
	syscall							# printf(" >> ");

	li	$v0, 12						# syscall 4: read_character
	syscall							# scanf(" %c",
	move	$t0, $v0					#              &command);

	beq	$t0, 'a', run_command__cmd_a			# if (command == 'a') { ...
	beq	$t0, 'd', run_command__cmd_d			# } else if (command == 'd') { ...
	beq	$t0, 'A', run_command__cmd_A			# } else if (command == 'A') { ...
	beq	$t0, 'D', run_command__cmd_D			# } else if (command == 'D') { ...
	beq	$t0, '.', run_command__cmd_dot			# } else if (command == '.') { ...
	beq	$t0, ';', run_command__cmd_semicolon		# } else if (command == ';') { ...
	beq	$t0, ',', run_command__cmd_comma		# } else if (command == ',') { ...
	beq	$t0, '?', run_command__cmd_question_mark	# } else if (command == '?') { ...
	beq	$t0, 's', run_command__cmd_s			# } else if (command == 's') { ...
	beq	$t0, 'h', run_command__cmd_h			# } else if (command == 'h') { ...
	beq	$t0, 'p', run_command__cmd_p			# } else if (command == 'p') { ...
	beq	$t0, 'q', run_command__cmd_q			# } else if (command == 'q') { ...
	b	run_command__bad_cmd				# } else { ...

run_command__cmd_a:						# if (command == 'a') {
	li	$a0, -1
	jal	move_paddle					#   move_paddle(-1);
	b	run_command__ret_true

run_command__cmd_d:						# } else if (command == 'd') { ...
	li	$a0, 1
	jal	move_paddle					#   move_paddle(1);
	b	run_command__ret_true

run_command__cmd_A:						# } else if (command == 'A') { ...
	li	$a0, -1
	jal	move_paddle					#   move_paddle(-1);
	li	$a0, -1
	jal	move_paddle					#   move_paddle(-1);
	li	$a0, -1
	jal	move_paddle					#   move_paddle(-1);
	b	run_command__ret_true

run_command__cmd_D:						# } else if (command == 'D') { ...
	li	$a0, 1
	jal	move_paddle					#   move_paddle(1);
	li	$a0, 1
	jal	move_paddle					#   move_paddle(1);
	li	$a0, 1
	jal	move_paddle					#   move_paddle(1);
	b	run_command__ret_true

run_command__cmd_dot:						# } else if (command == '.') { ...
	li	$a0, BALL_SIM_STEPS
	jal	move_balls					#   move_balls(BALL_SIM_STEPS);
	b	run_command__ret_true

run_command__cmd_semicolon:					# } else if (command == ';') { ...
	li	$a0, BALL_SIM_STEPS
	mul	$a0, $a0, 3					#   BALL_SIM_STEPS * 3
	jal	move_balls					#   move_balls(BALL_SIM_STEPS * 3);
	b	run_command__ret_true

run_command__cmd_comma:						# } else if (command == ',') { ...
	li	$a0, 1
	jal	move_balls					#   move_balls(1);
	b	run_command__ret_true

run_command__cmd_question_mark:					# } else if (command == '?') { ...
	jal	print_debug_info				#   print_debug_info();
	b	run_command__ret_true

run_command__cmd_s:						# } else if (command == 's') { ...
	jal	print_screen_updates				#   print_screen_updates();
	b	run_command__ret_true

run_command__cmd_h:						# } else if (command == 'h') { ...
	jal	print_welcome					#   print_welcome();
	b	run_command__ret_true

run_command__cmd_p:						# } else if (command == 'p') { ...
	li	$a0, TRUE
	sw	$a0, no_auto_print				#   no_auto_print = 1;
	jal	print_game					#   print_game();
	b	run_command__ret_true

run_command__cmd_q:						# } else if (command == 'q') { ...
	li	$v0, 10						#   syscall 10: exit
	syscall							#   exit(0);

run_command__bad_cmd:						# } else { ...

	li	$v0, 4						#   syscall 4: print_string
	li	$a0, str_run_command_bad_cmd_1			#   "Bad command: '"
	syscall							#   printf("Bad command: '");

	li	$v0, 11						#   syscall 11: print_character
	move	$a0, $t0					#           command
	syscall							#   putchar(       );

	li	$v0, 4						#   syscall 4: print_string
	li	$a0, str_run_command_bad_cmd_2			#   "'. Run `h` for help.\n"
	syscall							#   printf("'. Run `h` for help.\n");

	li	$v0, FALSE
	b	run_command__epilogue				#   return FALSE;

run_command__ret_true:						# }
	li	$v0, TRUE					# return TRUE;

run_command__epilogue:
	pop	$ra
	jr	$ra

################################################################################
# .TEXT <print_debug_info>
        .text
print_debug_info:
	# Provided
	#
	# Frame:    []
	# Uses:     [$v0, $a0, $t0, $t1, $t2, $t3]
	# Clobbers: [$v0, $a0, $t0, $t1, $t2, $t3]
	#
	# Locals:
	#   - $t0: int i, int row
	#   - $t1: struct ball *ball, int col
	#   - $t2: temporary copy of grid_width
	#   - $t3: temporary bricks[row][col] address calculations
	#
	# Structure:
	#   print_debug_info
	#   -> [prologue]
	#     -> body
	#       -> ball_loop_init
	#       -> ball_loop_cond
	#       -> ball_loop_body
	#       -> ball_loop_step
	#       -> row_loop_init
	#       -> row_loop_cond
	#       -> row_loop_body
	#         -> row_loop_init
	#         -> row_loop_cond
	#         -> row_loop_body
	#         -> row_loop_step
	#         -> row_loop_end
	#       -> row_loop_step
	#       -> row_loop_end
	#   -> [epilogue]

print_debug_info__prologue:

print_debug_info__body:
	li	$v0, 4				# syscall 4: print_string
	li	$a0, str_print_debug_info_1	# "      grid_width = "
	syscall					# printf("      grid_width = ");

	li	$v0, 1				# sycall 1: print_int
	lw	$a0, grid_width			#              grid_width
	syscall					# printf("%d",           );

	li	$v0, 11				# syscall 11: print_character
	li	$a0, '\n'
	syscall					# putchar('\n');


	li	$v0, 4				# syscall 4: print_string
	li	$a0, str_print_debug_info_2	# "        paddle_x = "
	syscall					# printf("        paddle_x = ");

	li	$v0, 1				# sycall 1: print_int
	lw	$a0, paddle_x			#              paddle_x
	syscall					# printf("%d",         );

	li	$v0, 11				# syscall 11: print_character
	li	$a0, '\n'
	syscall					# putchar('\n');


	li	$v0, 4				# syscall 4: print_string
	li	$a0, str_print_debug_info_3	# "bricks_destroyed = "
	syscall					# printf("bricks_destroyed = ");

	li	$v0, 1				# sycall 1: print_int
	lw	$a0, bricks_destroyed		#              bricks_destroyed
	syscall					# printf("%d",                 );

	li	$v0, 11				# syscall 11: print_character
	li	$a0, '\n'
	syscall					# putchar('\n');


	li	$v0, 4				# syscall 4: print_string
	li	$a0, str_print_debug_info_4	# "    total_bricks = "
	syscall					# printf("    total_bricks = ");

	li	$v0, 1				# sycall 1: print_int
	lw	$a0, total_bricks		#              total_bricks
	syscall					# printf("%d",             );

	li	$v0, 11				# syscall 11: print_character
	li	$a0, '\n'
	syscall					# putchar('\n');


	li	$v0, 4				# syscall 4: print_string
	li	$a0, str_print_debug_info_5	# "           score = "
	syscall					# printf("           score = ");

	li	$v0, 1				# sycall 1: print_int
	lw	$a0, score			#              score
	syscall					# printf("%d",      );

	li	$v0, 11				# syscall 11: print_character
	li	$a0, '\n'
	syscall					# putchar('\n');


	li	$v0, 4				# syscall 4: print_string
	li	$a0, str_print_debug_info_6	# "     combo_bonus = "
	syscall					# printf("     combo_bonus = ");

	li	$v0, 1				# sycall 1: print_int
	lw	$a0, combo_bonus		#              combo_bonus
	syscall					# printf("%d",            );

	li	$v0, 11				# syscall 11: print_character
	li	$a0, '\n'
	syscall					# putchar('\n');
	syscall					# putchar('\n');


	li	$v0, 4				# syscall 4: print_string
	li	$a0, str_print_debug_info_7	# "        num_screen_updates = "
	syscall					# printf("        num_screen_updates = ");

	li	$v0, 1				# sycall 1: print_int
	lw	$a0, num_screen_updates		#              num_screen_updates
	syscall					# printf("%d",                   );

	li	$v0, 11				# syscall 11: print_character
	li	$a0, '\n'
	syscall					# putchar('\n');


	li	$v0, 4				# syscall 4: print_string
	li	$a0, str_print_debug_info_8	# "whole_screen_update_needed = "
	syscall					# printf("whole_screen_update_needed = ");

	li	$v0, 1				# sycall 1: print_int
	lw	$a0, whole_screen_update_needed	#              whole_screen_update_needed
	syscall					# printf("%d",                           );

	li	$v0, 11				# syscall 11: print_character
	li	$a0, '\n'
	syscall					# putchar('\n');
	syscall					# putchar('\n');

print_debug_info__ball_loop_init:
	li	$t0, 0				# int i = 0;

print_debug_info__ball_loop_cond:		# while (i < MAX_BALLS) {
	bge	$t0, MAX_BALLS, print_debug_info__ball_loop_end

print_debug_info__ball_loop_body:
	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_9	#   "ball["
	syscall					#   printf("ball[");

	li	$v0, 1				#   sycall 1: print_int
	move	$a0, $t0			#                i
	syscall					#   printf("%d",  );

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_21	#   "]:\n"
	syscall					#   printf("]:\n");

	mul	$t1, $t0, SIZEOF_BALL		#   i * sizeof(struct ball)
	addi	$t1, $t1, balls			#   ball = &balls[i]

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_10	#   "  y: "
	syscall					#   printf("  y: ");

	li	$v0, 1				#   sycall 1: print_int
	lw	$a0, BALL_Y_OFFSET($t1)		#   ball->y
	syscall					#   printf("%d", ball->y);

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_11	#   "  x: "
	syscall					#   printf("  x: ");

	li	$v0, 1				#   sycall 1: print_int
	lw	$a0, BALL_X_OFFSET($t1)		#   ball->x
	syscall					#   printf("%d", ball->x);

	li	$v0, 11				#   syscall 11: print_character
	li	$a0, '\n'
	syscall					#   putchar('\n');

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_12	#   "  x_fraction: "
	syscall					#   printf("  x_fraction: ");

	li	$v0, 1				#   sycall 1: print_int
	lw	$a0, BALL_X_FRAC_OFFSET($t1)	#   ball->x_fraction
	syscall					#   printf("%d", ball->x_fraction);

	li	$v0, 11				#   syscall 11: print_character
	li	$a0, '\n'
	syscall					#   putchar('\n');

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_13	#   "  y_fraction: "
	syscall					#   printf("  y_fraction: ");

	li	$v0, 1				#   sycall 1: print_int
	lw	$a0, BALL_Y_FRAC_OFFSET($t1)	#   ball->y_fraction
	syscall					#   printf("%d", ball->y_fraction);

	li	$v0, 11				#   syscall 11: print_character
	li	$a0, '\n'
	syscall					#   putchar('\n');

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_14	#   "  dy: "
	syscall					#   printf("  dy: ");

	li	$v0, 1				#   sycall 1: print_int
	lw	$a0, BALL_DY_OFFSET($t1)	#   ball->dy
	syscall					#   printf("%d", ball->dy);

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_15	#   "  dx: "
	syscall					#   printf("  dx: ");

	li	$v0, 1				#   sycall 1: print_int
	lw	$a0, BALL_DX_OFFSET($t1)	#   ball->dx
	syscall					#   printf("%d", ball->dx);

	li	$v0, 11				#   syscall 11: print_character
	li	$a0, '\n'
	syscall					#   putchar('\n');

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_16	#   "  state: "
	syscall					#   printf("  state: ");

	li	$v0, 1				#   sycall 1: print_int
	lb	$a0, BALL_STATE_OFFSET($t1)	#   ball->state
	syscall					#   printf("%d", ball->state);

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_17	#   " ("
	syscall					#   printf(" (");

	li	$v0, 11				#   sycall 11: print_character
	lb	$a0, BALL_STATE_OFFSET($t1)	#   ball->state
	syscall					#   printf("%c", ball->state);

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_18	#   ")\n"
	syscall					#   printf(")\n");

print_debug_info__ball_loop_step:
	addi	$t0, $t0, 1			#   i++;
	b	print_debug_info__ball_loop_cond

print_debug_info__ball_loop_end:		# }


print_debug_info__row_loop_init:
	li	$t0, 0				# int row = 0;

print_debug_info__row_loop_cond:		# while (row < GRID_HEIGHT) {
	bge	$t0, GRID_HEIGHT, print_debug_info__row_loop_end

print_debug_info__row_loop_body:
	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_19	#   "\nbricks["
	syscall					#   printf("\nbricks[");

	li	$v0, 1				#   sycall 1: print_int
	move	$a0, $t0			#                i
	syscall					#   printf("%d",  );

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_20	#   "]: "
	syscall					#   printf("]: ");

print_debug_info__col_loop_init:
	li	$t1, 0				#   int col = 0;

print_debug_info__col_loop_cond:		#   while (col < grid_width) {
	lw	$t2, grid_width
	bge	$t1, $t2, print_debug_info__col_loop_end

print_debug_info__col_loop_body:
	mul	$t3, $t0, MAX_GRID_WIDTH	#     row * MAX_GRID_WIDTH
	add	$t3, $t3, $t1			#     row * MAX_GRID_WIDTH + row
	addi	$t3, $t3, bricks		#     &bricks[row][col]

	li	$v0, 1				#     sycall 1: print_int
	lb	$a0, ($t3)			#     bricks[row][col]
	syscall					#     printf("%d", bricks[row][col]);

	li	$v0, 11				#     sycall 11: print_character
	li	$a0, ' '
	syscall					#     printf(" ");

print_debug_info__col_loop_step:
	addi	$t1, $t1, 1			#     row++;
	b	print_debug_info__col_loop_cond

print_debug_info__col_loop_end:			#   }

print_debug_info__row_loop_step:
	addi	$t0, $t0, 1			#   row++;
	b	print_debug_info__row_loop_cond

print_debug_info__row_loop_end:			# }
	li	$v0, 11				#   syscall 11: print_character
	li	$a0, '\n'
	syscall					#   putchar('\n');

print_debug_info__epilogue:
	jr	$ra


################################################################################
# .TEXT <print_screen_updates>
        .text
print_screen_updates:
	# Provided
	#
	# Frame:    [$ra, $s0, $s1, $s2]
	# Uses:     [$ra, $s0, $s1, $s2, $t0, $t1, $t2, $t3, $t4, $v0, $a0]
	# Clobbers: [$t0, $t1, $t2, $t3, $t4, $v0, $a0]
	#
	# Locals:
	#   - $t0: print_cell return value, temporary screen_updates address calculations
	#   - $t1: copy of num_screen_updates
	#   - $t2: copy of whole_screen_update_needed
	#   - $t3: copy of grid_width
	#   - $t4: FALSE/0
	#   - $s0: int row, int i
	#   - $s1: int col, int y
	#   - $s2: int x
	#
	# Structure:
	#   print_screen_updates
	#   -> [prologue]
	#       -> body
	#       -> whole_screen
	#         -> row_loop_init
	#         -> row_loop_cond
	#         -> row_loop_body
	#           -> col_loop_init
	#           -> col_loop_cond
	#           -> col_loop_body
	#           -> col_loop_step
	#           -> col_loop_end
	#         -> row_loop_step
	#         -> row_loop_end
	#       -> not_whole_screen
	#         -> update_loop_init
	#         -> update_loop_cond
	#         -> update_loop_body
	#         -> update_loop_step
	#         -> update_loop_end
	#       -> final_newline
	#   -> [epilogue]

print_screen_updates__prologue:
	push	$ra
	push	$s0
	push	$s1
	push	$s2

print_screen_updates__body:
	li	$v0, 11							# sycall 11: print_character
	li	$a0, '&'
	syscall								# putchar('&');

	li	$v0, 1							#   syscall 1: print_int
	lw	$a0, score						#                score
	syscall								#   printf("%d",      );

	lw	$t2, whole_screen_update_needed

	beqz	$t2, print_screen_updates__not_whole_screen		# if (whole_screen_update_needed) {

print_screen_updates__whole_screen:
print_screen_updates__row_loop_init:
	li	$s0, 0							#   int row = 0;

print_screen_updates__row_loop_cond:
	bge	$s0, GRID_HEIGHT, print_screen_updates__row_loop_end	#   while (row < GRID_HEIGHT) {

print_screen_updates__row_loop_body:
print_screen_updates__col_loop_init:
	li	$s1, 0							#     int col = 0;

print_screen_updates__col_loop_cond:
	lw	$t3, grid_width
	bge	$s1, $t3, print_screen_updates__col_loop_end		#     while (col < grid_width) {

print_screen_updates__col_loop_body:
	move	$a0, $s0						#       row
	move	$a1, $s1						#       col
	jal	print_cell						#       print_cell(row, col);
	move	$t0, $v0

	li	$v0, 11							#       sycall 11: print_character
	li	$a0, ' '
	syscall								#       printf(" ");

	li	$v0, 1							#       sycall 1: print_int
	move	$a0, $s0						#                    row
	syscall								#       printf("%d",    );

	li	$v0, 11							#       sycall 11: print_character
	li	$a0, ' '
	syscall								#       printf(" ");

	li	$v0, 1							#       sycall 1: print_int
	move	$a0, $s1						#                    col
	syscall								#       printf("%d",    );

	li	$v0, 11							#       sycall 11: print_character
	li	$a0, ' '
	syscall								#       printf(" ");

	li	$v0, 1							#       sycall 1: print_int
	move	$a0, $t0						#                    print_cell(...)
	syscall								#       printf("%d",                );

print_screen_updates__col_loop_step:

	addi	$s1, $s1, 1						#       col++;
	b	print_screen_updates__col_loop_cond			#     }

print_screen_updates__col_loop_end:
print_screen_updates__row_loop_step:
	addi	$s0, $s0, 1						#     row++;
	b	print_screen_updates__row_loop_cond			#   }


print_screen_updates__row_loop_end:
	b	print_screen_updates__final_newline			# } else {

print_screen_updates__not_whole_screen:
print_screen_updates__update_loop_init:
	li	$s0, 0							#   int i = 0;

print_screen_updates__update_loop_cond:
	lw	$t1, num_screen_updates
	bge	$s0, $t1, print_screen_updates__update_loop_end		#   while (i < num_screen_updates) {

print_screen_updates__update_loop_body:
	mul	$t0, $s0, SIZEOF_SCREEN_UPDATE				#     i * sizeof(struct screen_update)
	addi	$t0, $t0, screen_updates				#     &screen_updates[i]

	lw	$s1, SCREEN_UPDATE_Y_OFFSET($t0)			#     int y = screen_updates[i].y;
	lw	$s2, SCREEN_UPDATE_X_OFFSET($t0)			#     int x = screen_updates[i].x;

									#     if (y >= GRID_HEIGHT) continue;
	bge	$s1, GRID_HEIGHT, print_screen_updates__update_loop_step

	bltz	$s2, print_screen_updates__update_loop_step		#     if (x < 0) continue;

									#     if (x >= MAX_GRID_WIDTH) continue;
	bge	$s2, MAX_GRID_WIDTH, print_screen_updates__update_loop_step

	move	$a0, $s1						#     y
	move	$a1, $s2						#     x
	jal	print_cell						#     print_cell(y, x);
	move	$t0, $v0

	li	$v0, 11							#     sycall 11: print_character
	li	$a0, ' '
	syscall								#     printf(" ");

	li	$v0, 1							#     sycall 1: print_int
	move	$a0, $s1						#                  y
	syscall								#     printf("%d",  );

	li	$v0, 11							#     sycall 11: print_character
	li	$a0, ' '
	syscall								#     printf(" ");

	li	$v0, 1							#     sycall 1: print_int
	move	$a0, $s2						#                  x
	syscall								#     printf("%d",  );

	li	$v0, 11							#     sycall 11: print_character
	li	$a0, ' '
	syscall								#     printf(" ");

	li	$v0, 1							#     sycall 1: print_int
	move	$a0, $t0						#                  print_cell(...)
	syscall								#     printf("%d",                );

print_screen_updates__update_loop_step:
	addi	$s0, $s0, 1						#     col++;
	b	print_screen_updates__update_loop_cond			#   }

print_screen_updates__update_loop_end:
print_screen_updates__final_newline:					# }
	li	$v0, 11							# syscall 11: print_character
	li	$a0, '\n'
	syscall								# putchar('\n');

	li	$t4, FALSE
	sw	$t4, whole_screen_update_needed				# whole_screen_update_needed = FALSE;

	li	$t4, 0
	sw	$t4, num_screen_updates					# num_screen_updates = 0;

print_screen_updates__epilogue:
	pop	$s2
	pop	$s1
	pop	$s0
	pop	$ra

	jr	$ra
