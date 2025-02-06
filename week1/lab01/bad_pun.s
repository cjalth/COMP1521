# Do You MIPS me?
# bad_pun.s
#
# Written by Caitlin Wong (z5477471)
# on 24/09/2023
#
# This program prints a bad pun

main:
    la	    $a0, pun
    li	    $v0, 4
    syscall

    li      $v0, 0
    jr      $ra

    .data
pun:
    .asciiz "Well, this was a MIPStake!\n"