########################################################################
# COMP1521 23T3 -- Assignment 1 -- Tetris!
#
#
# !!! IMPORTANT !!!
# Before starting work on the assignment, make sure you set your tab-width to 8!
# It is also suggested to indent with tabs only.
# Instructions to configure your text editor can be found here:
#   https://cgi.cse.unsw.edu.au/~cs1521/23T3/resources/mips-editors.html
# !!! IMPORTANT !!!
#
#
# This program was written by Caitlin Wong (z5477471)
# on 03/10/2023
#
# Version 1.0 (2023-09-25): Team COMP1521 <cs1521@cse.unsw.edu.au>
#
########################################################################

#![tabsize(8)]

# ##########################################################
# ####################### Constants ########################
# ##########################################################

# C constants
FIELD_WIDTH  = 9
FIELD_HEIGHT = 15
PIECE_SIZE   = 4
NUM_SHAPES   = 7

FALSE = 0
TRUE  = 1

EMPTY = ' '

# NULL is defined in <stdlib.h>
NULL  = 0

# Other useful constants
SIZEOF_INT = 4

COORDINATE_X_OFFSET = 0
COORDINATE_Y_OFFSET = 4
SIZEOF_COORDINATE = 8

SHAPE_SYMBOL_OFFSET = 0
SHAPE_COORDINATES_OFFSET = 4
SIZEOF_SHAPE = SHAPE_COORDINATES_OFFSET + SIZEOF_COORDINATE * PIECE_SIZE


	.data
# ##########################################################
# #################### Global variables ####################
# ##########################################################

# !!! DO NOT ADD, REMOVE, OR MODIFY ANY OF THESE DEFINITIONS !!!

shapes:				# struct shape shapes[NUM_SHAPES] = ...
	.byte 'I'
	.word -1,  0,  0,  0,  1,  0,  2,  0
	.byte 'J'
	.word -1, -1, -1,  0,  0,  0,  1,  0
	.byte 'L'
	.word -1,  0,  0,  0,  1,  0,  1, -1
	.byte 'O'
	.word  0,  0,  0,  1,  1,  1,  1,  0
	.byte 'S'
	.word  0,  0, -1,  0,  0, -1,  1, -1
	.byte 'T'
	.word  0,  0,  0, -1, -1,  0,  1,  0
	.byte 'Z'
	.word  0,  0,  1,  0,  0, -1, -1, -1

# Note that semantically global variables without
# an explicit initial value should be be zero-initialised.
# However to make testing earlier functions in this
# assignment easier, some global variables have been
# initialised with other values. Correct translations
# will always write to those variables befor reading,
# meaning the difference shouldn't matter to a finished
# translation.

next_shape_index:		# int next_shape_index = 0;
	.word 0

shape_coordinates:		# struct coordinate shape_coordinates[PIECE_SIZE];
	.word -1,  0,  0,  0,  1,  0,  2,  0

piece_symbol:			# char piece_symbol;
	.byte	'I'

piece_x:			# int piece_x;
	.word	3

piece_y:			# int piece_y;
	.word	1

piece_rotation:			# int piece_rotation;
	.word	0

score:				# int score = 0;
	.word	0

game_running:			# int game_running = TRUE;
	.word	TRUE

field:				# char field[FIELD_HEIGHT][FIELD_WIDTH];
	.byte	0:FIELD_HEIGHT * FIELD_WIDTH


# ##########################################################
# ######################### Strings ########################
# ##########################################################

# !!! DO NOT ADD, REMOVE, OR MODIFY ANY OF THESE STRINGS !!!

str__print_field__header:
	.asciiz	"\n/= Field =\\    SCORE: "
str__print_field__next:
	.asciiz	"     NEXT: "
str__print_field__footer:
	.asciiz	"\\=========/\n"

str__new_piece__game_over:
	.asciiz	"Game over :[\n"
str__new_piece__appeared:
	.asciiz	"A new piece has appeared: "

str__compute_points_for_line__tetris:
	.asciiz	"\n*** TETRIS! ***\n\n"

str__choose_next_shape__prompt:
	.asciiz	"Enter new next shape: "
str__choose_next_shape__not_found:
	.asciiz	"No shape found for "

str__main__welcome:
	.asciiz	"Welcome to 1521 tetris!\n"

str__show_debug_info__next_shape_index:
	.asciiz	"next_shape_index = "
str__show_debug_info__piece_symbol:
	.asciiz	"piece_symbol     = "
str__show_debug_info__piece_x:
	.asciiz	"piece_x          = "
str__show_debug_info__piece_y:
	.asciiz	"piece_y          = "
str__show_debug_info__game_running:
	.asciiz	"game_running     = "
str__show_debug_info__piece_rotation:
	.asciiz	"piece_rotation   = "
str__show_debug_info__coordinates_1:
	.asciiz	"coordinates["
str__show_debug_info__coordinates_2:
	.asciiz	"]   = { "
str__show_debug_info__coordinates_3:
	.asciiz	", "
str__show_debug_info__coordinates_4:
	.asciiz	" }\n"
str__show_debug_info__field:
	.asciiz	"\nField:\n"
str__show_debug_info__field_indent:
	.asciiz	":  "

str__game_loop__prompt:
	.asciiz	"  > "
str__game_loop__quitting:
	.asciiz	"Quitting...\n"
str__game_loop__unknown_command:
	.asciiz	"Unknown command!\n"
str__game_loop__goodbye:
	.asciiz	"\nGoodbye!\n"

# !!! Reminder to not not add to or modify any of the above !!!
# !!! strings or any other part of the data segment.        !!!



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
#  - [X] main
#  - [X] rotate_left
#  - [X] move_piece
#  SUBSET 1
#  - [X] compute_points_for_line
#  - [X] setup_field
#  - [X] choose_next_shape
#  SUBSET 2
#  - [X] print_field
#  - [X] piece_hit_test
#  - [ ] piece_intersects_field
#  - [X] rotate_right
#  SUBSET 3
#  - [ ] place_piece
#  - [ ] new_piece
#  - [ ] consume_lines
#  PROVIDED
#  - [X] show_debug_info
#  - [X] game_loop
#  - [X] read_char


################################################################################
# .TEXT <main>
        .text
main:
        # Subset:   0
        #
        # Args:     None
        #
        # Returns:  $v0: int
        #
        # Frame:    [...]
        # Uses:     [$a0, $v0, $ra]
        # Clobbers: [...]
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
	li	$v0, 4
	li	$a0, str__main__welcome
	syscall				# printf("Welcome to 1521 tetris!\n");

	jal	setup_field		# setup_frield();
	
	li	$a0, FALSE
	jal	new_piece		# new_piece(FALSE);

	jal	game_loop		# game_loop();

	li	$v0, 0			# return 0;

main__epilogue:
	pop	$ra
	end
	jr	$ra


################################################################################
# .TEXT <rotate_left>
        .text
rotate_left:
        # Subset:   0
        #
        # Args:     None
        #
        # Returns:  None
        #
        # Frame:    [...]
        # Uses:     [$ra]
        # Clobbers: [...]
        #
        # Locals:
        #   - None
        #
        # Structure:
        #   rotate_left
        #   -> [prologue]
        #       -> body
        #   -> [epilogue]

rotate_left__prologue:
	begin
	push	$ra

rotate_left__body:
	jal	rotate_right		# rotate_right();
	jal	rotate_right		# rotate_right();
	jal	rotate_right		# rotate_right();

rotate_left__epilogue:
	pop	$ra
	end
	jr      $ra



################################################################################
# .TEXT <move_piece>
        .text
move_piece:
        # Subset:   0
        #
        # Args:
        #    - $a0: int dx
        #    - $a1: int dy
        #
        # Returns:  $v0 (either FALSE or TRUE)
        #
        # Frame:    [...]
        # Uses:     [$ra, $a0, $a1, $t0, $t1]
        # Clobbers: [$t0, $t1]
        #
        # Locals:
        #   - $t0: piece_x
	#   - $t1: piece_y
        #
        # Structure:
        #   move_piece
        #   -> [prologue]
        #       -> body
	#	    -> if
        #   -> [epilogue]

move_piece__prologue:
	begin
	push	$ra
	push	$a0
	push	$a1

move_piece__body:
	lw	$t0, piece_x		# loads piece_x and piece_y
	lw	$t1, piece_y

	add 	$t0, $t0, $a0		# piece_x += dx;
	sw 	$t0, piece_x

	add 	$t1, $t1, $a1		# piece_y += dy;
	sw 	$t1, piece_y

	jal	piece_intersects_field

	pop	$a1
	pop	$a0

	beqz	$v0, move_piece__if

	lw	$t0, piece_x		# loads piece_x and piee_y
	lw	$t1, piece_y

	sub 	$t0, $t0, $a0    	# piece_x -= dx
	sw  	$t0, piece_x

	sub 	$t1, $t1, $a1    	# piece_y -= dy
	sw  	$t1, piece_y

	li	$v0, 0		 	# return FALSE;
	j	move_piece__epilogue

move_piece__if:
	li 	$v0, 1	     		# return TRUE;

move_piece__epilogue:
	pop	$ra
	end
	jr      $ra



################################################################################
# .TEXT <compute_points_for_line>
        .text
compute_points_for_line:
        # Subset:   1
        #
        # Args:
        #    - $a0: int bonus
        #
        # Returns:  $v0: int
        #
        # Frame:    [...]
        # Uses:     [$v0, $ra, $t0, $a0]
        # Clobbers: [$t0]
        #
        # Locals:
        #   - $t0: int bonus
        #
        # Structure:
        #   compute_points_for_line
        #   -> [prologue]
        #       -> body
	#	   -> reward
        #   -> [epilogue]

compute_points_for_line__prologue:
	begin
	push	$ra

compute_points_for_line__body:
	move	$t0, $a0 		# int bonus

	bne	$t0, 4, compute_points_for_line__reward	# if (bonus != 4)

	li	$v0, 4
	la	$a0, str__compute_points_for_line__tetris
	syscall				# printf("\n*** TETRIS! ***\n\n");

compute_points_for_line__reward:
	sub	$t0, $t0, 1		# $t0 = (bonus - 1)
	mul	$t0, $t0, $t0		# $t0 = (bonus - 1) * (bonus - 1)
	mul	$t0, $t0, 40		# $t0 = 40 * $t0
	add	$v0, $t0, 100		# $v0 = $t0 + 100

compute_points_for_line__epilogue:
	pop	$ra
	end
        jr      $ra



################################################################################
# .TEXT <setup_field>
        .text
setup_field:
        # Subset:   1
        #
        # Args:     None
        #
        # Returns:  None
        #
        # Frame:    [...]
        # Uses:     [$ra, $t0, $t1, $t2, $t3]
        # Clobbers: [$t0, $t1, $t2]
        #
        # Locals:
        #   - $t0: int row
	#   - $t1: int col
	#   - $t2: &field[row][col]
	#   - $t3: EMPTY
        #
        # Structure:
        #   setup_field
        #   -> [prologue]
        #       -> body
	#	    -> row_loop
	#		-> col_loop
	#	    -> row_loop_add
        #   -> [epilogue]

setup_field__prologue:
	begin
	push	$ra

setup_field__body:
	li	$t0, 0			# int row = 0;
	li	$t1, 0			# int col = 0;

setup_field__row_loop:
	bge	$t0, FIELD_HEIGHT, setup_field__epilogue

	li	$t1, 0			# col = 0;
	jal	setup_field__col_loop

setup_field__row_loop_add:
	add	$t0, $t0, 1		# row+;
	j	setup_field__row_loop

setup_field__col_loop:
	bge	$t1, FIELD_WIDTH, setup_field__row_loop_add

	la	$t2, field		# load field address
	mul	$t2, $t0, FIELD_WIDTH	# row * FIELD_WIDTH
	add	$t2, $t2, $t1		# $t2 = row * FIELD_WIDTH + col
	add 	$t2, $t2, field        	# $t2 = &field[row][col]

	li	$t3, EMPTY		# $t3 = EMPTY
	sb	$t3, ($t2)		# field[row][col] = EMPTY;

	add	$t1, $t1, 1		# col++

	j	setup_field__col_loop

setup_field__epilogue:
	pop	$ra
	end
        jr      $ra

################################################################################
# .TEXT <choose_next_shape>
        .text
choose_next_shape:
        # Subset:   1
        #
        # Args:     None
        #
        # Returns:  None
        #
        # Frame:    [...]
        # Uses:     [$ra, $s0, $v0, $a0, $t0, $t1, $t2, $t3, $t4, $t5]
        # Clobbers: [$ra, $t0, $t1, $t2, $t3, $t4, $t5]
        #
        # Locals:
        #   - $t0: char symbol
	#   - $t1: int i
	#   - $t2: i * SIZEOF_SHAPE
	#   - $t3: shapes address
	#   - $t4: address of shape + i * SIZEOF_SHAPE
	#   - $t5: data from memory address $t4
        #
        # Structure:
        #   choose_next_shape
        #   -> [prologue]
        #       -> body
	#	    -> loop
	#		-> has
	#	    -> gone
        #   -> [epilogue]

choose_next_shape__prologue:
	begin
	push 	$ra
	push	$s0

choose_next_shape__body:
	# Hint for translating shapes[i].symbol:
	#    You can compute the address of shapes[i] by using
	#      `i`, the address of `shapes`, and SHAPE_SIZE.
	#    You can then use that address to find the address of
	#      shapes[i].symbol with SHAPE_SYMBOL_OFFSET.
	#    Once you have the address of shapes[i].symbol you
	#      can use a memory load instruction to find its value.

	li	$v0, 4
	la	$a0, str__choose_next_shape__prompt
	syscall					# printf("Enter new next shape: ");

	jal	read_char
	move	$t0, $v0			# char symbol = read_char();

	li	$t1, 0				# int i = 0;

choose_next_shape__loop:
	beq	$t1, NUM_SHAPES, choose_next_shape__gone	# while (i != NUM_SHAPES)

	la	$t3, shapes			# address of shapes
	mul	$t2, $t1, SIZEOF_SHAPE		# $t2 = i * SIZEOF_SHAPE	
	add	$t4, $t3, $t2			# $t4 = address of shape + i * SIZEOF_SHAPE

	lb	$t5, SHAPE_SYMBOL_OFFSET($t4)	# $t5 = data from memory address

	beq	$t0, $t5, choose_next_shape__has

	add	$t1, $t1, 1			# i++;

	j	choose_next_shape__loop

choose_next_shape__has:
	move	$s0, $t1			
	sw	$s0, next_shape_index		# next_shape_index = i;

	j	choose_next_shape__epilogue

choose_next_shape__gone:
	li	$v0, 4
	li	$a0, str__choose_next_shape__not_found
	syscall					# printf("No shape found for ");

	li	$v0, 11
	move	$a0, $t0			# printf("%c", symbol);
	syscall

	li	$v0, 11				# syscall 11: print_char
	li	$a0, '\n'			# printf("%c", '\n');
	syscall	

choose_next_shape__epilogue:
	pop	$s0
	pop	$ra
	end
        jr      $ra



################################################################################
# .TEXT <print_field>
        .text
print_field:
        # Subset:   2
        #
        # Args:     None
        #
        # Returns:  None
        #
        # Frame:    [...]
        # Uses:     [$ra, $s0, $s1, $t5, $t8, $t1, $t2, $t3, $t4, $t7, $a0, $a1, $a2]
        # Clobbers: [$ra, $t5, $t8, $t1, $t2, $t3, $t4, $t7, $a0]
        #
        # Locals:
        #   - $s0: int row
	#   - $s1: int col
	#   - $t1: adress of shapes
	#   - $t2: next_shape_index * SIZEOF_SHAPE
	#   - $t3: $t2 * SHAPE_SYMBOL_OFFSET
	#   - $t4: data from memory address $t3
	#   - $t5: score
	#   - $t7: piece_symbol
	#   - $t8: next_shape_index
        #
        # Structure:
        #   print_field
        #   -> [prologue]
        #       -> body
	#	   -> row_loop
	#	       -> row next
        #                  -> row_cond
        #              -> row_next
        #              -> col_loop
        #                  -> col_next
        #          -> end
        #   -> [epilogue]

print_field__prologue:
	begin
	push	$ra
	push	$s1
	push	$s0

print_field__body:
	li	$v0, 4
	la	$a0, str__print_field__header
	syscall				# printf("\n/= Field =\\    SCORE: ");

	lw	$t5, score		# load score into $t5

	li	$v0, 1
	move	$a0, $t5
	syscall				# printf("%d", score);

	li 	$v0, 11
    	li 	$a0, '\n'
    	syscall				# printf('\n');

	li	$s0, 0			# int row = 0;
print_field__row_loop:
	bge	$s0, FIELD_HEIGHT, print_field__end	

	li	$s1, 0			# int col = 0;

	li 	$v0, 11
    	li 	$a0, '|'
    	syscall				# putchar('|');

	j	print_field__col_loop

print_field__row_next:
	li 	$v0, 11
    	li 	$a0, '|'
    	syscall				# putchar('|');	

	beq	$s0, 1, print_field__row_cond	#  if (row == 1)

	li 	$v0, 11
    	li 	$a0, '\n'
    	syscall				# putchar('\n');

	add	$s0, $s0, 1		# row++;

	j	print_field__row_loop

print_field__row_cond:
	li	$v0, 4
	la	$a0, str__print_field__next
	syscall				# printf("     NEXT: ");

	lw	$t8, next_shape_index	# loads next_shape_index

	la	$t1, shapes		# shapes address
	mul	$t2, $t8, SIZEOF_SHAPE	# $t2 = next_shape_index * SIZEOF_SHAPE
	add	$t2, $t2, $t1		# add shapes address to $t2
	add	$t3, $t2, SHAPE_SYMBOL_OFFSET	# $t2 + SHAPW_SYMBOL_OFFSET

	lb	$t4, ($t3)		# load shapes[next_shape_index].symbol

	li	$v0, 11
	move	$a0, $t4
	syscall				# printf("%c", shapes[next_shape_index].symbol);	

	li 	$v0, 11
    	li 	$a0, '\n'
    	syscall				# putchar('\n');

	add	$s0, $s0, 1		# row++;

	j	print_field__row_loop

print_field__col_loop:
	bge	$s1, FIELD_WIDTH, print_field__row_next	# if (col < FIELD_WIDTH)

	la	$a0, shape_coordinates	# loads shape coordinates
	move	$a1, $s0		# $a1 = row
	move	$a2, $s1		# a2 = col

	jal	piece_hit_test

	beqz	$v0, print_field__col_next	# if (piece_hit_test(shape_coordinates, row, col)

	lb	$t7, piece_symbol	# load piece_symbol

	li	$v0, 11
	move	$a0, $t7
	syscall				# putchar(piece_symbol);

	add	$s1, $s1, 1		# col++;

	j	print_field__col_loop

print_field__col_next:

	mul	$t3, $s0, FIELD_WIDTH	# field_width * row
	add	$t2, $s1, $t3		# field_width * row + col
	add	$t4, field, $t2		# field[row][col]

	lb	$a0, ($t4)		# putchar(field[row][col]);
	li	$v0, 11
	syscall

	add	$s1, $s1, 1		# col++;

	j	print_field__col_loop	

print_field__end:
	li	$v0, 4
	la	$a0, str__print_field__footer
	syscall				# printf("\\=========/\n");

print_field__epilogue:
	pop	$s0
	pop	$s1
	pop	$ra
	end
        jr      $ra



################################################################################
# .TEXT <piece_hit_test>
        .text
piece_hit_test:
        # Subset:   2
        #
        # Args:
        #    - $a0: struct coordinate coordinates[PIECE_SIZE]
        #    - $a1: int row
        #    - $a2: int col
        #
        # Returns:  $v0: struct coordinate *
        #
        # Frame:    [...]
        # Uses:     [$ra, $t0, $t1, $t2, $t3, $t4, $t5, $t6]
        # Clobbers: [$ra, $t0, $t1, $t2, $t3, $t4, $t5, $t6]
        #
        # Locals:
        #   - $t0: int i
	#   - $t1: address of struct coordinate coordinates[PIECE_SIZE]
	#   - $t2: i * SIZEOF_COORDINATE
	#   - $t3: COORDINATE_OFFSET + $t1 + $t2
	#   - $t4: coordinates[i].x/y
	#   - $t5: piece_x/y
	#   - $t6: $t4 + $t5
        #
        # Structure:
        #   piece_hit_test
        #   -> [prologue]
        #       -> body
	#	    -> loop
	#		-> next
	#	    -> end
	#	-> null
        #   -> [epilogue]

piece_hit_test__prologue:
	begin
	push	$ra

piece_hit_test__body:
	li	$t0, 0				# int i = 0;

piece_hit_test__loop:
	bge	$t0, PIECE_SIZE, piece_hit_test__null	#  i < PIECE_SIZE

	la	$t1, ($a0)			# address of coordinates[PIECE_SIZE]
	mul	$t2, $t0, SIZEOF_COORDINATE	# i * SIZEOF_COORDINATE
	add	$t2, $t2, $t1			# i * SIZEOF_COORDINATE + $t1
	add	$t3, $t2, COORDINATE_X_OFFSET	# $t3 = coordinates[i].x + offset

	lw	$t4, ($t3)			# load coordinates[i].x
	lw	$t5, piece_x			# load piece_x

	add	$t6, $t5, $t4			# $t6 = coordinates[i].x + piece_x

	beq	$t6, $a2, piece_hit_test__next	# if (coordinates[i].x + piece_x == col)

	add	$t0, $t0, 1			# i++;

	j	piece_hit_test__loop		

piece_hit_test__next:
	la	$t1, ($a0)			# address of coordinates[PIECE_SIZE]
	mul	$t2, $t0, SIZEOF_COORDINATE	# i * SIZEOF_COORDINATE
	add	$t2, $t2, $t1			# i * SIZEOF_COORDINATE + $t1
	add	$t3, $t2, COORDINATE_Y_OFFSET	# $t3 = coordinates[i].y + offset

	lw	$t4, ($t3)			# load coordinates[i].y
	lw	$t5, piece_y			# load piece_y

	add	$t6, $t5, $t4			# $t6 = coordinates[i].y + piece_y

	beq	$t6, $a1, piece_hit_test__end	# if (coordinates[i].y + piece_y == row)

	add	$t0, $t0, 1			# i++

	j	piece_hit_test__loop

piece_hit_test__end:
	la	$t1, ($a0)			# address of struct coordinate coordinates[PIECE_SIZE]
	mul	$t2, $t0, NUM_SHAPES		# i * NUM_SHAPES
	add	$t2, $t2, $t1			# i * NUM_SHAPES + coordinates address
	add	$t2, $t2, $t0			# i * NUM_SHAPES + coordinates address + i
	move	$v0, $t2			# move to $v0 to be returned

	j	piece_hit_test__epilogue

piece_hit_test__null:
	li	$v0, 0				# return NULL;

piece_hit_test__epilogue:
	pop	$ra
	end
        jr      $ra



################################################################################
# .TEXT <piece_intersects_field>
        .text
piece_intersects_field:
        # Subset:   2
        #
        # Args:     None
        #
        # Returns:  $v0: int
        #
        # Frame:    [...]
        # Uses:     [$ra, $t0, $t1, $t2, $t3, $t4, $t7, $t8]
        # Clobbers: [$ra, $t0, $t1, $t2, $t3, $t4, $t7, $t8]
        #
        # Locals:
	#   - $t0: int i
	#   - $t1: piece_x
	#   - $t2: i * SIZEOF_COORDINATE
	#   - $t3: i * SIZEOF_COORDINATE + COORDINATE_(X/Y)_OFFSET
	#   - $t4: shape_coordinates[i].x
	#   - $t7: piece_y
	#   - $t8: shape_coordinates[i].y
        #
        # Structure:
        #   piece_intersects_field
        #   -> [prologue]
        #       -> body
	#	    -> false
	#	    -> true
        #   -> [epilogue]

piece_intersects_field__prologue:
	begin
	push	$ra

	li	$v0, 0
	li	$t0, 1				# int i = 0;

piece_intersects_field__body:
	bge	$t0, PIECE_SIZE, piece_intersects_field__false

	mul	$t2, $t0, SIZEOF_COORDINATE	# i * SIZEOF_COORDINATE
	add	$t3, $t2, COORDINATE_X_OFFSET	# add them

	lw	$t1, piece_x			# loads piece_x
	lw	$t4, shape_coordinates($t3)	# loads shape_coordinates[i].x

	add	$t4, $t4, $t1			# int x = shape_coordinates[i].x + piece_x;

	mul	$t2, $t0, SIZEOF_COORDINATE	# mul i and size of coordinate
	add	$t3, $t2, COORDINATE_Y_OFFSET	# add them

	lw	$t7, piece_y			# loads piece_y
	lw	$t8, shape_coordinates($t3)	# loads shape_coordinates[i].y

	add	$t8, $t8, $t7			# int y = shape_coordinates[i].y + piece_y;

	bltz	$t4, piece_intersects_field__true		# if (x < 0
	bge	$t4, FIELD_WIDTH, piece_intersects_field__true	# x >= FIELD_WIDTH

	bltz	$t8, piece_intersects_field__true		# if (y < 0
	bge	$t8, FIELD_HEIGHT, piece_intersects_field__true	# y >= FIELD_HEIGHT

	la	$t2, field			# load address of field
	mul	$t2, $t8, FIELD_WIDTH		# y * FIELD_WIDTH
	add	$t2, $t2, $t4			# y * FIELD_WIDTH + x
	add 	$t2, $t2, field        		# $t2 = &field[row][col]

	sb	$t3, ($t2)

	bne	$t3, EMPTY, piece_intersects_field__true	# if (field[y][x] != EMPTY)

	add	$t0, $t0, 1			# i++;

	j	piece_intersects_field__body

piece_intersects_field__false:
	li	$v0, 0				# return FALSE;

	j	piece_intersects_field__epilogue

piece_intersects_field__true:
	li	$v0, 1				# return TRUE;

piece_intersects_field__epilogue:
	pop	$ra
	end
        jr      $ra



################################################################################
# .TEXT <rotate_right>
        .text
rotate_right:
        # Subset:   2
        #
        # Args:     None
        #
        # Returns:  None
        #
        # Frame:    [...]
	# Uses:     [$ra, $s0, $s1, $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8, $t9]
        # Clobbers: [$ra, $s0, $s1, $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8, $t9]
        #
        #
        # Locals:
	#   - $t0: Temporary storage for piece rotation
        #   - $t1: Temporary storage for 'i'
        #   - $t2: Temporary storage for coordinates address
        #   - $t3: Temporary storage for address
        #   - $t4: Temporary storage for shape_coordinate address
        #   - $t5: Temporary storage for shape_coordinate
        #   - $t6: Temporary storage for 'temp'
        #   - $t7: Temporary storage for 'piece_symbol'
        #   - $t8: Temporary storage for shape_coordinate[i].y
        #   - $t9: Temporary storage for address calculations
        #
        # Structure:
        #   rotate_right
        #   -> [prologue]
        #       -> body
	#	-> loop
	#	    -> if
	#	-> 2nd loop
        #   -> [epilogue]

rotate_right__prologue:
	begin
	push	$ra
	push	$s0
	push	$s1

rotate_right__body:
	# The following 3 instructions are provided, although you can
	# discard them if you want. You still need to add appropriate
	# comments.
	lw	$t0, piece_rotation
	add	$t0, $t0, 1			# piece_rotation++;
	sw	$t0, piece_rotation

	li	$t1, 0				# int i = 0;

rotate_right__loop:
	bge	$t1, PIECE_SIZE, rotate_right__if

	la	$t2, shape_coordinates		# Load address of coordinates[PIECE_SIZE]
	mul	$t3, $t1, SIZEOF_COORDINATE	# i * SIZEOF_COORDINATE
	add	$t3, $t3, $t2			# Add result to address
	add	$t4, $t3, COORDINATE_X_OFFSET	# Calculate address of shape_coordinates[i].x
	lw	$t5, ($t4)			# load shape_coordinates[i].x

	la	$t6, shape_coordinates		# address of coordinates[PIECE_SIZE]
	mul	$t7, $t1, SIZEOF_COORDINATE	# i * SIZEOF_COORDINATE
	add	$t7, $t7, $t2			# Add result to address
	add	$t8, $t7, COORDINATE_Y_OFFSET	# Calculate address of shape_coordinates[i].y
	lw	$t9, ($t8)			# load shape_coordinates[i].y

	move	$s0, $t5			# int temp = shape_coordinates[i].x;
	move	$s1, $t9

	mul	$t5, $s1, -1			# shape_coordinates[i].x = -shape_coordinates[i].y;
	move	$t9, $s0			# shape_coordinates[i].y = temp;

	sw	$t5, ($t4)			# store updated x and y coordinates
	sw	$t9, ($t8)

	add	$t1, $t1, 1			# i++;

	j	rotate_right__loop

rotate_right__if: 
	lb	$t7, piece_symbol		# loads piece_symbol

	li	$t1, 0				# int i = 0;

	beq	$t7, 'I', rotate_right__2nd_loop	# if (piece_symbol == 'I'
	beq	$t7, 'O', rotate_right__2nd_loop	# || piece_symbol == 'O') {

	j	rotate_right__epilogue

rotate_right__2nd_loop:
	bge	$t1, PIECE_SIZE, rotate_right__epilogue	# i < PIECE_SIZE;

	# For 'I' and 'O' pieces, adjust the x-coordinates
	la    	$t2, shape_coordinates        		# Address of coordinates[PIECE_SIZE]
	mul    	$t3, $t1, SIZEOF_COORDINATE    		# Calculate i * SIZEO_COORDINATES
	add    	$t3, $t3, $t2				# Add result to address
	add   	$t4, $t3, COORDINATE_X_OFFSET    	# Calculates address of x coordinate
	lw   	$t5, ($t4)            			# load shape_coordinates[i].x

	add    	$t5, $t5, 1				# shape_coordinates[i].x += 1;

	sw    	$t5, ($t4)				# stores new x coordinate

	add	$t1, $t1, 1				# i++;

	j	rotate_right__2nd_loop

rotate_right__epilogue:
	pop	$s1
	pop	$s0
	pop	$ra
	end
        jr      $ra



################################################################################
# .TEXT <place_piece>
        .text
place_piece:
        # Subset:   3
        #
        # Args:     None
        #
        # Returns:  None
        #
        # Frame:    [...]
        # Uses:     [...]
        # Clobbers: [...]
        #
        # Locals:
        #   - ...
        #
        # Structure:
        #   place_piece
        #   -> [prologue]
        #       -> body
        #   -> [epilogue]

place_piece__prologue:

place_piece__body:

place_piece__epilogue:
        jr      $ra



################################################################################
# .TEXT <new_piece>
        .text
new_piece:
        # Subset:   3
        #
        # Args:
        #    - $a0: int should_announce
        #
        # Returns:  None
        #
        # Frame:    [...]
        # Uses:     [...]
        # Clobbers: [...]
        #
        # Locals:
        #   - ...
        #
        # Structure:
        #   new_piece
        #   -> [prologue]
        #       -> body
        #   -> [epilogue]

new_piece__prologue:

new_piece__body:

new_piece__epilogue:
        jr      $ra



################################################################################
# .TEXT <consume_lines>
        .text
consume_lines:
        # Subset:   3
        #
        # Args:     None
        #
        # Returns:  None
        #
        # Frame:    [...]
        # Uses:     [...]
        # Clobbers: [...]
        #
        # Locals:
        #   - ...
        #
        # Structure:
        #   consume_lines
        #   -> [prologue]
        #       -> body
        #   -> [epilogue]

consume_lines__prologue:

consume_lines__body:

consume_lines__epilogue:
        jr      $ra


################################################################################
################################################################################
###                   PROVIDED FUNCTIONS — DO NOT CHANGE                     ###
################################################################################
################################################################################

################################################################################
# .TEXT <show_debug_info>
        .text
show_debug_info:
	# Args:     None
        #
        # Returns:  None
	#
	# Frame:    []
	# Uses:     [$a0, $v0, $t0, $t1, $t2, $t3]
	# Clobbers: [$a0, $v0, $t0, $t1, $t2, $t3]
	#
	# Locals:
	#   - $t0: i
	#   - $t1: coordinates address calculations
	#   - $t2: row
	#   - $t3: col
	#   - $t4: field address calculations
	#
	# Structure:
	#   print_board
	#   -> [prologue]
	#   -> body
	#     -> coord_loop
	#       -> coord_loop__init
	#       -> coord_loop__cond
	#       -> coord_loop__body
	#       -> coord_loop__step
	#       -> coord_loop__end
	#     -> row_loop
	#       -> row_loop__init
	#       -> row_loop__cond
	#       -> row_loop__body
	#         -> col_loop
	#           -> col_loop__init
	#           -> col_loop__cond
	#           -> col_loop__body
	#           -> col_loop__step
	#           -> col_loop__end
	#       -> row_loop__step
	#       -> row_loop__end
	#   -> [epilogue]

show_debug_info__prologue:

show_debug_info__body:
	li	$v0, 4				# syscall 4: print_string
	la	$a0, str__show_debug_info__next_shape_index
	syscall					# printf("next_shape_index = ");

	li	$v0, 1				# sycall 1: print_int
	lw	$a0, next_shape_index		# next_shape_index
	syscall					# printf("%d", next_shape_index);

	li	$v0, 11				# syscall 11: print_char
	li	$a0, '\n'
	syscall					# putchar('\n');


	li	$v0, 4				# syscall 4: print_string
	la	$a0, str__show_debug_info__piece_symbol
	syscall					# printf("piece_symbol     = ");

	li	$v0, 1				# sycall 1: print_int
	lb	$a0, piece_symbol		# piece_symbol
	syscall					# printf("%d", piece_symbol);

	li	$v0, 11				# syscall 11: print_char
	li	$a0, '\n'
	syscall					# putchar('\n');


	li	$v0, 4				# syscall 4: print_string
	la	$a0, str__show_debug_info__piece_x
	syscall					# printf("piece_x          = ");

	li	$v0, 1				# sycall 1: print_int
	lw	$a0, piece_x			# piece_x
	syscall					# printf("%d", piece_x);

	li	$v0, 11				# syscall 11: print_char
	li	$a0, '\n'
	syscall					# putchar('\n');


	li	$v0, 4				# syscall 4: print_string
	la	$a0, str__show_debug_info__piece_y
	syscall					# printf("piece_y          = ");

	li	$v0, 1				# sycall 1: print_int
	lw	$a0, piece_y			# piece_y
	syscall					# printf("%d", piece_y);

	li	$v0, 11				# syscall 11: print_char
	li	$a0, '\n'
	syscall					# putchar('\n');


	li	$v0, 4				# syscall 4: print_string
	la	$a0, str__show_debug_info__game_running
	syscall					# printf("game_running     = ");

	li	$v0, 1				# sycall 1: print_int
	lw	$a0, game_running		# game_running
	syscall					# printf("%d", game_running);

	li	$v0, 11				# syscall 11: print_char
	li	$a0, '\n'
	syscall					# putchar('\n');


	li	$v0, 4				# syscall 4: print_string
	la	$a0, str__show_debug_info__piece_rotation
	syscall					# printf("piece_rotation   = ");

	li	$v0, 1				# sycall 1: print_int
	lw	$a0, piece_rotation		# piece_rotation
	syscall					# printf("%d", piece_rotation);

	li	$v0, 11				# syscall 11: print_char
	li	$a0, '\n'
	syscall					# putchar('\n');


show_debug_info__coord_loop:
show_debug_info__coord_loop__init:
	li	$t0, 0				# int i = 0;

show_debug_info__coord_loop__cond:		# while (i < PIECE_SIZE) {
	bge	$t0, PIECE_SIZE, show_debug_info__coord_loop__end

show_debug_info__coord_loop__body:
	li	$v0, 4				#   syscall 4: print_string
	la	$a0, str__show_debug_info__coordinates_1
	syscall					#   printf("coordinates[");

	li	$v0, 1				#   syscall 1: print_int
	move	$a0, $t0
	syscall					#   printf("%d", i);

	li	$v0, 4				#   syscall 4: print_string
	la	$a0, str__show_debug_info__coordinates_2
	syscall					#   printf("]   = { ");

	mul	$t1, $t0, SIZEOF_COORDINATE	#   i * sizeof(struct coordinate)
	addi	$t1, $t1, shape_coordinates	#   &shape_coordinates[i]

	li	$v0, 1				#   syscall 1: print_int
	lw	$a0, COORDINATE_X_OFFSET($t1)	#   shape_coordinates[i].x
	syscall					#   printf("%d", shape_coordinates[i].x);

	li	$v0, 4				#   syscall 4: print_string
	la	$a0, str__show_debug_info__coordinates_3
	syscall					#   printf(", ");

	li	$v0, 1				#   syscall 1: print_int
	lw	$a0, COORDINATE_Y_OFFSET($t1)	#   shape_coordinates[i].y
	syscall					#   printf("%d", shape_coordinates[i].y);

	li	$v0, 4				#   syscall 4: print_string
	la	$a0, str__show_debug_info__coordinates_4
	syscall					#   printf(" }\n");

show_debug_info__coord_loop__step:
	addi	$t0, $t0, 1			#   i++;
	b	show_debug_info__coord_loop__cond

show_debug_info__coord_loop__end:		# }

	li	$v0, 4				# syscall 4: print_string
	la	$a0, str__show_debug_info__field
	syscall					# printf("\nField:\n");

show_debug_info__row_loop:
show_debug_info__row_loop__init:
	li	$t2, 0				# int row = 0;

show_debug_info__row_loop__cond:		# while (row < FIELD_HEIGHT) {
	bge	$t2, FIELD_HEIGHT, show_debug_info__row_loop__end

show_debug_info__row_loop__body:
	bge	$t2, 10, show_debug_info__print_row
	li	$v0, 11				#  if (row < 10) {
	li	$a0, ' '
	syscall					#     putchar(' ');

show_debug_info__print_row:			#   }
	li	$v0, 1				#   syscall 1: print_int
	move	$a0, $t2
	syscall					#   printf("%d", row);


	li	$v0, 4				#   syscall 4: print_string
	la	$a0, str__show_debug_info__field_indent
	syscall					#   printf(":  ");

show_debug_info__col_loop:
show_debug_info__col_loop__init:
	li	$t3, 0				#   int col = 0;

show_debug_info__col_loop__cond:		#   while (col < FIELD_WIDTH) {
	bge	$t3, FIELD_WIDTH, show_debug_info__col_loop__end

show_debug_info__col_loop__body:
	mul	$t4, $t2, FIELD_WIDTH		#     row * FIELD_WIDTH
	add	$t4, $t4, $t3			#     row * FIELD_WIDTH + col
	addi	$t4, $t4, field			#     &field[row][col]

	li	$v0, 1				#     syscall 1: print_int
	lb	$a0, ($t4)			#     field[row][col]
	syscall					#     printf("%d", field[row][col]);

	li	$v0, 11				#     syscall 11: print_char
	li	$a0, ' '
	syscall					#     putchar(' ');

	lb	$a0, ($t4)			#     field[row][col]
	syscall					#     printf("%c", field[row][col]);

	li	$v0, 11				#     syscall 11: print_char
	li	$a0, ' '
	syscall					#     putchar(' ');

show_debug_info__col_loop__step:
	addi	$t3, $t3, 1			#     i++;
	b	show_debug_info__col_loop__cond

show_debug_info__col_loop__end:			#   }

	li	$v0, 11				#   syscall 11: print_char
	li	$a0, '\n'
	syscall					#   putchar('\n');

show_debug_info__row_loop__step:
	addi	$t2, $t2, 1			#   row++;
	b	show_debug_info__row_loop__cond

show_debug_info__row_loop__end:			# }

	li	$v0, 11				# syscall 11: print_char
	li	$a0, '\n'
	syscall					# putchar('\n');

show_debug_info__epilogue:
	jr	$ra


################################################################################
# .TEXT <game_loop>
        .text
game_loop:
        # Args:     None
        #
        # Returns:  None
        #
        # Frame:    [$ra]
        # Uses:     [$t0, $t1, $v0, $a0]
        # Clobbers: [$t0, $t1, $v0, $a0]
        #
        # Locals:
        #   - $t0: copy of game_running
        #   - $t1: char command
        #
        # Structure:
        #   game_loop
        #   -> [prologue]
        #       -> body
        #   -> [epilogue]

game_loop__prologue:
	push	$ra

game_loop__body:
game_loop__big_loop__cond:
	lw	$t0, game_running
	beqz	$t0, game_loop__big_loop__end		# while (game_running) {

game_loop__big_loop__body:
	jal	print_field				#   print_field();

	li	$v0, 4					#   syscall 4: print_string
	la	$a0, str__game_loop__prompt
	syscall						#   printf("  > ");

	jal	read_char
	move	$t1, $v0				#   command = read_char();

	beq	$t1, 'r', game_loop__command_r		#   if (command == 'r') { ...
	beq	$t1, 'R', game_loop__command_R		#   } else if (command == 'R') { ...
	beq	$t1, 'n', game_loop__command_n		#   } else if (command == 'n') { ...
	beq	$t1, 's', game_loop__command_s		#   } else if (command == 's') { ...
	beq	$t1, 'S', game_loop__command_S		#   } else if (command == 'S') { ...
	beq	$t1, 'a', game_loop__command_a		#   } else if (command == 'a') { ...
	beq	$t1, 'd', game_loop__command_d		#   } else if (command == 'd') { ...
	beq	$t1, 'p', game_loop__command_p		#   } else if (command == 'p') { ...
	beq	$t1, 'c', game_loop__command_c		#   } else if (command == 'c') { ...
	beq	$t1, '?', game_loop__command_question	#   } else if (command == '?') { ...
	beq	$t1, 'q', game_loop__command_q		#   } else if (command == 'q') { ...
	b	game_loop__unknown_command		#   } else { ... }

game_loop__command_r:					#   if (command == 'r') {
	jal	rotate_right				#     rotate_right();

	jal	piece_intersects_field			#     call piece_intersects_field();
	beqz	$v0, game_loop__big_loop__cond		#     if (piece_intersects_field())
	jal	rotate_left				#       rotate_left();

	b	game_loop__big_loop__cond		#   }

game_loop__command_R:					#   else if (command == 'R') {
	jal	rotate_left				#     rotate_left();

	jal	piece_intersects_field			#     call piece_intersects_field();
	beqz	$v0, game_loop__big_loop__cond		#     if (piece_intersects_field())
	jal	rotate_right				#       rotate_right();

	b	game_loop__big_loop__cond		#   }

game_loop__command_n:					#   else if (command == 'n') {
	li	$a0, FALSE				#     argument 0: FALSE
	jal	new_piece				#     new_piece(FALSE);

	b	game_loop__big_loop__cond		#   }

game_loop__command_s:					#   else if (command == 's') {
	li	$a0, 0					#     argument 0: 0
	li	$a1, 1					#     argument 1: 1
	jal	move_piece				#     call move_piece(0, 1);

	bnez	$v0, game_loop__big_loop__cond		#     if (!piece_intersects_field())
	jal	place_piece				#       rotate_left();

	b	game_loop__big_loop__cond		#   }

game_loop__command_S:					#   else if (command == 'S') {
game_loop__hard_drop_loop:
	li	$a0, 0					#     argument 0: 0
	li	$a1, 1					#     argument 1: 1
	jal	move_piece				#     call move_piece(0, 1);
	bnez	$v0, game_loop__hard_drop_loop		#     while (move_piece(0, 1));

	jal	place_piece				#     place_piece();

	b	game_loop__big_loop__cond		#   }

game_loop__command_a:					#   else if (command == 'a') {
	li	$a0, -1					#     argument 0: -1
	li	$a1, 0					#     argument 1: 0
	jal	move_piece				#     move_piece(-1, 0);

	b	game_loop__big_loop__cond		#   }

game_loop__command_d:					#   else if (command == 'd') {
	li	$a0, 1					#     argument 0: 1
	li	$a1, 0					#     argument 1: 0
	jal	move_piece				#     move_piece(1, 0);

	b	game_loop__big_loop__cond		#   }

game_loop__command_p:					#   else if (command == 'p') {
	jal	place_piece				#     place_piece();

	b	game_loop__big_loop__cond		#   }

game_loop__command_c:					#   else if (command == 'c') {
	jal	choose_next_shape			#     choose_next_shape();

	b	game_loop__big_loop__cond		#   }

game_loop__command_question:				#   else if (command == '?') {
	jal	show_debug_info				#     show_debug_info();

	b	game_loop__big_loop__cond		#   }

game_loop__command_q:					#   else if (command == 'q') {
	li	$v0, 4					#     syscall 4: print_string
	la	$a0, str__game_loop__quitting
	syscall						#     printf("Quitting...\n");

	b	game_loop__big_loop__end		#     break;

game_loop__unknown_command:				#   } else {
	li	$v0, 4					#     syscall 4: print_string
	la	$a0, str__game_loop__unknown_command
	syscall						#     printf("Unknown command!\n");

game_loop__big_loop__step:				#   }
	b	game_loop__big_loop__cond

game_loop__big_loop__end:				# }
	li	$v0, 4					# syscall 4: print_string
	la	$a0, str__game_loop__goodbye
	syscall						# printf("\nGoodbye!\n");

game_loop__epilogue:
	pop	$ra
	jr	$ra					# return;


################################################################################
# .TEXT <show_debug_info>
        .text
read_char:
	# NOTE: The implementation of this function is
	#       DIFFERENT from the C code! This is
	#       because mipsy handles input differently
	#       compared to `scanf`. You do not need to
	#       worry about this difference as you will
	#       only be calling this function.
	#
        # Args:     None
        #
        # Returns:  $v0: char
        #
        # Frame:    []
        # Uses:     [$v0]
        # Clobbers: [$v0]
        #
        # Locals:
	#   - $v0: char command
        #
        # Structure:
        #   read_char
        #   -> [prologue]
        #       -> body
        #   -> [epilogue]

read_char__prologue:

read_char__body:
	li	$v0, 12				# syscall 12: read_char
	syscall					# scanf("%c", &command);

read_char__epilogue:
	jr	$ra				# return command;
