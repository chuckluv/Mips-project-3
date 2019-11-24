.data
	data: .space 1001
	output: .asciiz "\n"
	notvalid: .asciiz "Nan"
	storage: .space 1001
.text
main :
	li $v0,8
	la $a0,data
	li $a1, 1001
	syscall
	la $t0, data
load:
	
	la $t1, storage

loop:
	
	
	lb $s0, ($t0)
	beq $s0, 0, print
	beq $s0, 10, print
	sb $s0, ($t1)

	addi $t0,$t0,1
	addi $t1, $t1, 1
	j loop
	
print:
	la $t0,storage
	addi $t0, $t0, 3
	li $v0, 4
	la $a0, output
	syscall

	li $v0, 4
	
	move $a0, $t0
	syscall
	
	li $v0, 10
	syscall