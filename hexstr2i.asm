# Hexadecminal to decimal conversion.
# The hex number is provided as an ascii string.
#
# Developed by George Z. Zachos

	.globl main
	.text

main:
	la	$a0, hexnum
	jal	hexstr2i
	add	$a0, $v0, $zero  # Copy return value of hexstr2i to $a0
	li	$v0, 1           # Print integer syscall
	syscall
	li	$v0, 10          # Terminate execution syscall
	syscall


hexstr2i:
	li	$v0, 0   # Default return value in case of empty string
	li	$t2, 0   # Number of hex digits (0 for empty string)
	                 # Terminating null byte is not counted
	li	$t3, 0   # Holds the (variable) shift amount required for
	                 # multiplying by the n-th power of 16
	add	$t0, $a0, $zero   # Copy $a0 to $t0 (pass by value)
	lb	$t1, 0($t0)       # $t1 = Mem[$t0 + 0]
gotostrend:
	beq	$t1, $zero, convert_loop   # Have reached end of string
	addi	$t2, $t2, 1   # Increase digit counter
	addi	$t0, $t0, 1   # Point to next byte
	lb	$t1, 0($t0)   # $t1 = Mem[$t0 + 0]
	j	gotostrend
convert_loop:
	beq	$t2, $zero, exitfunc
	addi	$t0, $t0, -1    # Move one digit to the left
	addi	$t2, $t2, -1    # $t2 more digits are left to convert
	lb	$t1, 0($t0)     # $t1 = Mem[$t0 + 0]
	slti	$t4, $t1, 97	# $t4 is set to 1, if $t1 < 'a'. Else is set to 0.
	                        # 97 is the ascii value of 'a'
	beq	$t4, $zero, over10   # Case: '0' -> '9'
	addi	$t1, $t1, -48   # 48 is the ascii value of '0'
	j	update_retval
over10:                         # Case: 'a' -> 'f'
	addi	$t1, $t1, -87   # Convert 'a' to 10, 'b' to 11 etc.
	                        # 87 = 'a' - 10
update_retval:
	sllv	$t1, $t1, $t3   # Multiply temp result by the required power of 16
	addi	$t3, $t3, 4     # Calculate new shift amount
	addu	$v0, $v0, $t1   # Add hexdigit * (16 ^ n-th) where n is the digit
	                        # index to the value to be returned
	j	convert_loop
exitfunc:
	jr	$ra   # Return control from callee to caller


# Data segment
	.data
	
hexnum: .asciiz "badcafe"   # Hex number to be converted
