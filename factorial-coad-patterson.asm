# Factorial in MIPS assembly
# from "Computer Organization and Design", 4th Ed.
# by David A. Patterson and John L. Hennessy

	.globl main
	
	.text
	
main:
	addi	$a0, $zero, 1
	jal	fact
	li   $v0, 10
        syscall
	
fact:
	addi	$sp, $sp, -8
	sw	$ra, 4($sp)
	sw	$a0, 0($sp)
	slti	$t0, $a0, 1
	beq	$t0, $zero, else
	addi	$v0, $zero, 1
	addi	$sp, $sp, 8
	jr	$ra
else:
	addi	$a0, $a0, -1
	jal	fact
	lw	$a0, 0($sp)
	lw	$ra, 4($sp)
	addi	$sp, $sp, 8
	mul	$v0, $a0, $v0
	jr	$ra
