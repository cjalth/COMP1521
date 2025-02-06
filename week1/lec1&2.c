// Registers
// multiplies 2 and 3 and stores the result

// Loads 2 and 3 into the register
    li  $t0,   2
    li  $t1,   3

// Stores the result
    mul $t2,  $t1,  $t0

// Registers are denoted by a $ and can be referred 
// to using a number ($0…$31) or by symbolic names ($zero…$ra)
// $zero ($0) is special!
    // Always has the value 0 -> attempts to change it have no effect
// $ra ($31) is also special!
    //Directly affected by two instructions we use in Week 3

// https://cgi.cse.unsw.edu.au/~cs1521/23T3/resources/mips-guide.html


