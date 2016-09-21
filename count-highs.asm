# A MIPS assembly subroutine that counts the
# number of "1"s found in a given argument.
#
# Developed by George Z. Zachos

	.globl main
	
	.text
	
main:
	li	$a0, 0x7a   # 0x7a == 0b01111010
	jal	count_highs
	
	li	$v0, 10   # service code 10: exit
	syscall

count_highs:
	add	$v0, $zero, $zero   # $v0 = 0
	addi	$sp, $sp, -4        # adjust stack pointer to store $a0
	sw	$a0, 0($sp)         # Mem[$sp] = $a0
loop:
	beq	$a0, $zero, exit_sub  # if ($a0 == 0) goto exit_sub
	andi	$t0, $a0, 0x01        # $t0 = $a0 & 1
	srl	$a0, $a0, 1           # $a0 = $a0 >> 1
	beq	$t0, $zero, loop      # if ($t0 == 0) goto loop
	addi	$v0, $v0, 1           # $v0 += 1
	j loop
exit_sub:
	lw	$a0, 0($sp)   # $a0 = Mem[$sp]
	addi	$sp, $sp, 4   # adjust stack pointer
	jr	$ra
	
