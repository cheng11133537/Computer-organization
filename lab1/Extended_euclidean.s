.data
prompt1:     .asciiz "Enter the number: "
prompt2: .asciiz "Enter the modulo: "
resultMsg: .asciiz "Result: "
noInverse: .asciiz "Inverse not exist."
newline:    .asciiz "\n"

.text
.globl main
main:
  li $v0,4
  la $a0,prompt1
  syscall
  
  li $v0,5
  syscall
  move $t0,$v0        ##$t0=a;
   
  li $v0,4
  la $a0,prompt2
  syscall 
  
  li $v0,5
  syscall
  move $t1,$v0         ##$t1=b;
  
  move $t2,$t1         ##m=b
  move $t3,$t2         ##m0=m
  li $t4,0             ##x0=0
  li $t5,1             ##x1=1
  li $t6,1
  beq $t2,$t6,no_inverse
  while_loop:
     ble $t0,$t6,end_loop
     div $t0, $t2
     mflo $t7           ##q=a/m
     move $t8,$t2       ##t=m
     mfhi $t2           ##m=a%m
     move $t0,$t8       ##a=t
     move $t8,$t4       ##t=x0
     mul $t9, $t7, $t4  ##t9=q*x0
     sub $t4, $t5, $t9  ##x0=x1-q*x0
     move $t5,$t8       ##x1=t
     j while_loop
  
  
  end_loop:
     bne $t0,$t6,no_inverse
     bltz $t5,fix_negative
     j print_result
     
 fix_negative:
     add $t5,$t5,$t3
     
  print_result:
     li $v0,4
     la $a0,resultMsg
     syscall
     
     li $v0,1
     move $a0,$t5
     syscall
     
     li $v0,4
     la $a0,newline
     syscall
     
     li   $v0,10    
     syscall
     
 no_inverse:
     li $v0,4
     la $a0,noInverse
     syscall
     
     li $v0,4
     la $a0,newline
     syscall
     
     li   $v0,10    
     syscall
     

     
 
