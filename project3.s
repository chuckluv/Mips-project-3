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
	la $t0, data	#points $t0 to the user input(data) 
load:
	
	la $t1, storage	#points $t1 to an empty array (storage)	
	la $t2, storage	#sets $t2 as the pointer to the beginnig of an array (storage)	
loop:
	
	
	lb $s0, ($t0)	#loads the first charater in data to $s0
	beq $s0, 0, print #checks if the  character is a null character
	beq $s0, 10, print #checks if the  character is a null character	
	beq $s0,44,store	#checks if the  character is a comma character
	sb $s0, ($t1)	#stores the character in $s0 to the array storage

	addi $t0,$t0,1	#shifts pointer to next character by incrementing
	addi $t1, $t1, 1 #shifts pointer to index in the array by incrementing
	addi $t3, $t3,1	#shifts pointer to index in the array by incrementing
	j loop

store:
	
	sub $sp, $sp, 4
	sw $t2, ($sp)	
	addi $t0,$t0,1
	j comma
comma:
	add $t2, $t2, $t3
	j loop
	
print:
	
	la $t0, storage
	li $v0, 4
	la $a0, output
	syscall

	li $v0, 4
	
	move $a0, $t0
	syscall
	
	li $v0, 10
	syscall