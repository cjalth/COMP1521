# Reads a 4-byte value and reverses the byte order, then prints it
# Written by Caitlin Wong (z5477471) 09/07/2024

.text
.globl main

main:
    # Locals:
    #   - $t0: int network_bytes
    #   - $t1: int computer_bytes

    li  	 $v0, 5                  # scanf("%d", &network_bytes);
    syscall
    move	 $t0, $v0       

    li       $t1, 0                 # computer_bytes = 0;

    andi    $a1, $t0, 0xFF          # network_bytes & byte_mask
    sll     $a1, $a1, 24            # << 24
    or      $t1, $t1, $a1           # computer_bytes |=

    andi    $a1, $t0, 0xFF00       
    sll     $a1, $a1, 8             
    or      $t1, $t1, $a1           

    andi    $a1, $t0, 0xFF0000     
    srl     $a1, $a1, 8           
    or      $t1, $t1, $a1           

    andi    $a1, $t0, 0xFF000000    
    srl     $a1, $a1, 24          
    or      $t1, $t1, $a1          

    move	 $a0, $t1               # printf("%d\n", computer_bytes);
    li  	 $v0, 1              
    syscall

    li  	 $a0, '\n'              # printf("%c", '\n');
    li  	 $v0, 11
    syscall

main__end:
    li  	 $v0, 10                # return 0;
    syscall

