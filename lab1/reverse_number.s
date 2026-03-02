.data
prompt:     .asciiz "Enter a number: "
result_msg: .asciiz "Reversed number: "
newline:    .asciiz "\n"

.text
.globl main
main:
    li   $v0,4
    la   $a0,prompt   ##string
    syscall 
    
    li   $v0,5        ##input integer
    syscall
    move $t0,$v0      ##$t0=n
    
    li   $t1,0        ##reverse=0
while_loop:
    beq  $t0,$zero,end_while 
    
    li   $t2,10       ##$t2=10
    rem  $t3,$t0,$t2  ##temp=n%10
    mul  $t1,$t1,$t2  ##reverse=reverse*10;
    add  $t1,$t1,$t3  ##reverse=reverse*10+temp;
    div  $t0,$t0,$t2  ##n=n/10
    
    j while_loop
end_while:    
    li   $v0,4
    la   $a0,result_msg
    syscall
    
    li   $v0,1       ##print int
    move $a0,$t1
    syscall
    
    li   $v0,4
    la   $a0,newline
    syscall
    
    li   $v0,10      ##end program
    syscall
    
    
    
    
    
 






