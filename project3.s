.data
	data: .space 1001
	output: .asciiz "\n"
	notvalid: .asciiz "Nan"
	storage: .space 1001
.text
main :
	li $v0,8	
	la $a0,data	#reads user input 
	li $a1, 1001
	syscall
	jal SubprogramA #jumps to label but for some reason doesn't want to jump back
continue1:
	j print #jumps to print function
SubprogramA:
	sub $sp, $sp,4 #creates spaces in the stack
	sw $a0, 0($sp) #stores input into the stack
	lw $t0, 0($sp) # stores the input into $t0
	addi $sp,$sp,4 # moves the stack pointer up
	move $t6, $t0 # stores the begining of the input into $t6	
start:
	li $t2,0 #used to check for space or tabs within the input
	li $t7, -1 #used for invaild input
	lb $s0, ($t0) # loads the bit that $t0 is pointing to
	#beq $s0, 0, finish
	beq $s0, 9, skip # checks if the bit is a tabs character 
	beq $s0, 32, skip #checks if the bit is a space character
	move $t6, $t0 #store the first non-space/tab character
	j loop # jumps to the beginning of the loop function

skip:
	addi $t0,$t0,1 #move the $t0 to the next element of the array
	j start 
loop:
	
	
	lb $s0, ($t0) # loads the bit that $t0 is pointing to
	beq $s0, 0, substring# check if the bit is null
	beq $s0, 10, substring #checks if the bit is a new line 	
	addi $t0,$t0,1 #move the $t0 to the next element of the array	
	beq $s0, 44, substring #check if bit is a comma