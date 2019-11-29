.data
	data: .space 1001
	output: .asciiz "\n"
	notvalid: .asciiz "Nan"
	comma: .asciiz ","
.text
main :
	li $v0,8	
	la $a0,data	
	li $a1, 1001
	syscall
	jal SubprogramA 

	j print 
SubprogramA:
	move$s6, $ra
	sub $sp, $sp,4 
	sw $a0, 0($sp) 
	lw $t0, 0($sp) 
	addi $sp,$sp,4 
	move $t6, $t0 	
First:
	li $t2,0 
	li $t7, -1 
	lb $s0, ($t0) 
	beq $s0, 0, insubstring# check if the bit is null
	beq $s0, 10, insubstring #checks if the bit is a new line 
	beq $s0, 44, invalidloop #check if bit is a comma
	beq $s0, 9, pass 
	beq $s0, 32, pass 
	move $t6, $t0 
	j load 

pass:
	addi $t0,$t0,1 
	j First 
load:
	
	
	lb $s0, ($t0) 
	beq $s0, 0, end
	beq $s0, 10, end 	
	addi $t0,$t0,1 	
	beq $s0, 44, end 
sort:
	bgt $t2,0,invalidloop 
	beq $s0, 9,  gap 
	beq $s0, 32, gap 
	ble $s0, 47, invalidloop
	ble $s0, 57, vaild 
	ble $s0, 64, invalidloop 
	ble $s0, 84, vaild	
	ble $s0, 96, invalidloop 
	ble $s0, 116, vaild 	
	bge $s0, 117, invalidloop 
gap:
	addi $t2,$t2,-1 
	j load

vaild:
	addi $t3, $t3,1 
	mul $t2,$t2,$t7 
	j load 	

invalidloop:
	
	lb $s0, ($t0) # loads the bit that $t0 is pointing to
	beq $s0, 0, insubstring# check if the bit is null
	beq $s0, 10, insubstring #checks if the bit is a new line 	
	addi $t0,$t0,1 #move the $t0 to the next element of the array	
	beq $s0, 44, insubstring #check if bit is a comma
	
	
	j invalidloop 
insubstring:
	
	addi $t1,$t1,1  	
	sub $sp, $sp,4
	
	sw $t7, 0($sp) 
	
	move $t6,$t0  
	lb $s0, ($t0) 
	beq $s0, 0, finish2
	beq $s0, 10, finish2 
	beq $s0,44, invalidloop 
	li $t3,0 
	li $t2,0 
	j First


substring:
	mul $t2,$t2,$t7 
end:
	bgt $t2,0,insubstring 
	bge $t3,5,insubstring 
	addi $t1,$t1,1  	
	sub $sp, $sp,4
	sw $t6, 0($sp) 
	move $t6,$t0  
	lw $t4,0($sp) 
	li $s1,0  
	jal SubprogramB
	lb $s0, ($t0) 
	beq $s0, 0, finish2
	beq $s0, 10, finish2
	beq $s0,44, invalidloop 
	li $t2,0 
	j First

SubprogramB:
	move$s4, $ra
bit:
	beq $t3,0,finish  
	addi $t3,$t3,-1 
	lb $a0, ($t4) 
	
	addi $t4,$t4,1	
	jal SubprogramC 

	
	sw $v0,0($sp)	
	j bit
SubprogramC:
	move$s5, $ra
	move $s0,$a0
	move $t8, $t3	
	li $t9, 1	
	ble $s0, 57, num 
	ble $s0, 84, upper
	ble $s0, 116, lower
num:
	
	sub $s0, $s0, 48	 
	beq $t3, 0, combine	
	li $t9, 30		
	j exp
upper:
	
	sub $s0, $s0, 55 
	beq $t3, 0, combine 
	li $t9, 30
	j exp

lower:
	
	sub $s0, $s0, 87 
	beq $t3, 0, combine 
	li $t9, 30
	j exp
exp:
	
	ble $t8, 1, combine	
	mul $t9, $t9, 30 	
	addi $t8, $t8, -1	
	j exp
combine:
	mul $s2, $t9, $s0	
	
	add $s1,$s1,$s2		 
	move $v0, $s1
	j finish1

finish : 
move $ra, $s4
jr $ra	
finish1 :
move $ra, $s5 
jr $ra	
finish2 : 
move $ra, $s6,
jr $ra	

print:
	mul $t1,$t1,4 
	add $sp, $sp $t1 
	
done:	
	
	
	sub $t1, $t1,4	
	sub $sp,$sp,4 

		
	lw $s7, 0($sp)	
	
	beq $s7,-1,invalidprint 
	
	li $v0, 1
	lw $a0, 0($sp) 
	syscall
com:
	beq $t1, 0,Exit 
	li $v0, 4
	la $a0, comma 
	syscall
	j done
invalidprint:
	
	li $v0, 4
	
	la $a0, notvalid 
	syscall	
	j com 
	



	
Exit:
	li $v0, 10
	syscall