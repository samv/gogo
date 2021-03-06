# Test to demostrate the jumps-over-jumps peephole optimization.

	.data
n:		.word	0

	.text

runtime:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)

	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra
	.end runtime


	.globl main
	.ent main
main:
	li	$3, 0		# n -> $3
	# Store dirty variables back into memory
	sw	$3, n
	bne	$3, 0, elseLabel

	lw	$3, n		# n -> $3
	addi	$3, $3, 1
	# Store dirty variables back into memory
	sw	$3, n
	j	exit

elseLabel:
	# The generated assembly should not contain the label "ifLabel".
	lw	$3, n		# n -> $3
	addi	$3, $3, 2
	# Store dirty variables back into memory
	sw	$3, n

exit:
	li	$2, 1
	lw	$3, n		# n -> $3
	move	$4, $3
	syscall
	li	$2, 10
	syscall
	.end main
