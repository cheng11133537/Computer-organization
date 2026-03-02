.data
prompt:     .asciiz "Please input a number: "
result_msg: .asciiz "The sum of Fibonacci(0) to Fibonacci(n) is: "
newline:    .asciiz "\n"

.text
.globl main
main:
   li $v0,4
   la $a0,prompt
   syscall
   
   li $v0,5
   syscall
   move $t0,$v0
   
   li $t1,0    #a=0
   li $t2,1    #b=1
   li $t3,0    #i=0
   li $t4,0    #sum=0
   li $t5,0    #temp
 
 fib_loop:
    bgt $t3,$t0,end_loop    ##i>n
    beq $t3,$zero,add_zero  ##i=0,sum=0
    li $t6,1
    beq $t3,$t6,add_one     ##i=1,sum=1
     
    add $t5,$t1,$t2         ##temp=a+b
    move $t1,$t2            ##a=b
    move $t2,$t5            ##b=temp
    add $t4,$t4,$t2         ##sum=sum+b
    j inc_loop
 
 add_zero:
    move $t4,$zero
    j inc_loop

 add_one:
    li $t6,1
    move $t4,$t6
    j inc_loop
   
inc_loop:
    add $t3,$t3,1          ##i++
    j fib_loop
    
end_loop:
   li $v0,4
   la $a0,newline
   syscall

   li $v0,4
   la $a0,result_msg
   syscall
   
   li $v0,1
   move $a0,$t4
   syscall
   
   li $v0,4
   la $a0,newline
   syscall
   
   li $v0,10
   syscall
 



