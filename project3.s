.data
	data: .space 1001
	output: .asciiz "\n"
	notvalid: .asciiz "Nan"
.text
main :
	li $v0,8
	la $a0,data
	li $a1, 1001
	syscall