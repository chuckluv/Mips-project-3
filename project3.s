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

loop:
	li $t0, data
	li $t1, storage
	
	lb $s0, ($t0)
	beq $s0, 44, print
	sb $s0, ($t1)

	addi $t0,$t0,1
	addi $t1, $t1, 1
	j loop
	
print:
	li $v0, 4
	la $a0, output
	syscall

	li $v0, 4
	
	move $a0, $t1
	syscall
	
	