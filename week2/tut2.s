    .text
main:                           # this is a label called main

    li	    $v0, 5
    syscall

    bne	    $v0, 42, main       # bne is branch not equal
    # so if the scanned in number isn't 42, go back to main

jr:
    nop
    jr	    $ra
