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
check:
	bgt $t2,0,invalidloop #checks to see if there were any spaces or tabs in between valid characters
	beq $s0, 9,  gap #checks to see if there is a tab characters
	beq $s0, 32, gap #checks to see if there is a space character
	ble $s0, 47, invalidloop # checks to see if the ascii less than 48
	ble $s0, 57, vaild # checks to see if the ascii less than 57(integers)
	ble $s0, 64, invalidloop # checks to see if the ascii less than 64
	ble $s0, 84, vaild	# checks to see if the ascii less than 84(capital letters)
	ble $s0, 96, invalidloop # checks to see if the ascii less than 96
	ble $s0, 116, vaild 	# checks to see if the ascii less than 116(lowercase letters)
	bge $s0, 117, invalidloop # checks to see if the ascii greater than 116
gap:
	addi $t2,$t2,-1 #keeps track of spaces/tabs
	j loop

vaild:
	addi $t3, $t3,1 #keeps track of how many valid characters are in the substring
	mul $t2,$t2,$t7 #if there was a space before a this valid character it will change $t2 to a positive number
	j loop #jumps to the beginning of loop	

invalidloop:
	
	lb $s0, ($t0) # loads the bit that $t0 is pointing to
	beq $s0, 0, insubstring# check if the bit is null
	beq $s0, 10, insubstring #checks if the bit is a new line 	
	addi $t0,$t0,1 #move the $t0 to the next element of the array	
	beq $s0, 44, insubstring #check if bit is a comma
	#addi $t3, $t3,1 #check track of how many valid characters are in the substring
	
	j invalidloop #jumps to the beginning of loop
insubstring:
	
	addi $t1,$t1,1 #keeps track of the amount substring 	
	sub $sp, $sp,4# creates space in the stack
	
	sw $t7, 0($sp) #stores what was in $t6 into the stack
	
	move $t6,$t0  # store the pointer to the bit after the comma
	lb $s0, ($t0) # loads the bit that $t0 is pointing to
	beq $s0, 0, continue1# check if the bit is null
	beq $s0, 10, continue1 #checks if the bit is a new line 
	beq $s0,44, invalidloop #checks if the next bit is a comma
	li $t3,0 #resets the amount of valid characters back to 0
	li $t2,0 #resets my space/tabs checker back to zero
	j loop
substring:
	bgt $t2,0,insubstring #checks to see if there were any spaces or tabs in between valid characters
	bge $t3,5,insubstring #checks to see if there are more than 4 for characters
	addi $t1,$t1,1 #check track of the amount substring 	
	sub $sp, $sp,4# creates space in the stack
	sw $t6, 0($sp) #stores what was in $t6 into the stack
	move $t6,$t0  # store the pointer to the bit after the comma
	lw $t4,0($sp) #loads what was in the stack at that posistion into $t4
	li $s1,0 #sets $s1 to 0 
	jal SubprogramB
	lb $s0, ($t0) # loads the bit that $t0 is pointing to
	beq $s0, 0, continue1# check if the bit is null
	beq $s0, 10, continue1#checks if the bit is a new line 
	beq $s0,44, invalidloop #checks if the next bit is a comma
	li $t2,0 #resets my space/tabs checker back to zero
	j loop

SubprogramB:
	beq $t3,0,finish #check how many charcter are left to convert 
	addi $t3,$t3,-1 #decreases the amount of charaters left to convert
	lb $a0, ($t4) # loads the bit that will be converted
	
	addi $t4,$t4,1	# moves to the next element in the array
	j SubprogramC 
continue:
	
	sw $v0,0($sp)	#stores the converted number
	j SubprogramB
SubprogramC:
	move $s0,$a0
	move $t8, $t3	#stores the amount of characters left to use as an exponent
	li $t9, 1	# $t9 represents 30 to a certian power and set equal to 1
	ble $s0, 57, num #sorts the bit to the apporiate function
	ble $s0, 84, upper
	ble $s0, 116, lower
num:
	
	sub $s0, $s0, 48	#converts interger bits 
	beq $t3, 0, combine	# if there are no charaters left that mean the exponent is zero
	li $t9, 30		
	j exp