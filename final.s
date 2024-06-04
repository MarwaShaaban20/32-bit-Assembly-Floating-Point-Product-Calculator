#ID ->20200516 /20211017

.intel_syntax noprefix      # use the intel syntax, not AT&T syntax. do not prefix registers with %
.section .data              #used for declaring initialized data or constants. This data does not change at runtime
input: .asciz "%d"            # string terminated by 0 that will be used for scanf parameter 
output: .asciz "The sum = %f\n" # string terminated by 0 that will be used for printf parameter

n: .int 0            # variable n which we will get from user using scanf and loop n times initialized to 0          
total: .double 1.0   # the variable total= ((n) + 1/1) * ((n-1) + 1/2) * ((n-2) + 1/3) * ((n-3) + 1/4) * ... * (2 + 1/(n-1)) * (1 + 1/(n)) that will be calculated by the program and will be printed by printf, total is initialized to 1       
                               
one: .double 1.0
i: .double 1.0       # variable counter save the number of the iteration ,i is initialized to 1
num:    .double 1.0  # Variable used to store the value input from the user and utilized in calculations (initialized to 1.0)


.section .text        # The text section is used for keeping the actual code      
.globl _main          # make _main accessible from external      
     # get the number of integers from the user
_main:                # the label indicating the start of the program       
   push OFFSET n      # push to stack the second parameter to scanf (the address of the integer variable n)     
   push OFFSET input  # push to stack the first parameter to scanf  
   call _scanf        # call scanf, it will use the two parameters on the top of the stack in the reverse order 
   add esp, 8         # pop the above two parameters from the stack (the esp register keeps track of the stack top, 8=2*4 bytes popped as param was 4 bytes)
   mov ecx, n         # ecx <- n (the number of iterations)
   mov eax, n          # Move the integer value stored in n to the eax register
cvtsi2sd xmm0, eax  # Convert the integer in eax to a double-precision float and store it in xmm0
movsd num, xmm0     # Copy the value from xmm0 to the double-precision float variable num

     
    
loop1:
   # the following 5 instructions calculates a term in the mathematical series (num + 1/i)
   # and multiplies the current total by this term and updates total
    
    fld qword ptr one     # push 1 to the floating point stack
    fdiv qword ptr i      # pop the floating point stack top (1), divide it over i and push the result (1/i)
    fadd qword ptr num    # pop the floating point stack top (1/i), add it to num, and push the result (num+(1/i))
    fmul qword ptr total  # pop the floating point stack top (num+(1/i)), multiply it to total, and push the result (total*(num+(1/i)))
    fstp qword ptr total  # pop the floating point stack top (total*(num+(1/i))) into the memory variable total
    
    # the following 3 instructions increment i by 1
    fld qword ptr i      #push i to the floating point stack 
    fadd qword ptr one   # pop the floating point stack top (1), add it to i and push the result (i+1)
    fstp qword ptr i     # pop the floating point stack top (i+1) into the memory variable i
    
    # the following 3 instructions decrement num by 1
    fld qword ptr num     # push num to the floating point stack 
    fsub qword ptr one    # pop the floating point stack top (1), subtract it to num and push the result (num-1)
    fstp qword ptr num    # pop the floating point stack top (num-1) into the memory variable num

    loop loop1          # ecx -=1 , after that go to loopn only if ecx is not zero     

    push [total+4]      # push to stack the high 32-bits of the second parameter to printf (the double at label tatal)      
    push total          # push to stack the low 32-bits of the second parameter to printf (the double at label tatal)    
    push OFFSET output  # push to stack the first parameter to printf
    call _printf        # call printf
    add esp, 12         # pop the two parameters

    ret                 # end the main function

