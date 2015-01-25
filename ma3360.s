.text

countzeroes:
	li $v0, 0x0 # zeros = 0 
	li $t1, 0x1 # i = 1

	comp: 
		beq $t1, 0x100000000, end # while (i != 2^32)
		and $t2, $a0, $t1 # t2 = number && i
		sll $t1, $t1, 0x1 # i = i << 1
		beq $t2, 0x0, zeros # if (t2 == 0) zeros++
		j comp
	end:	
		jr $ra
	zeros:
		addi $v0, $v0, 0x1
		j comp

ispalindrome:
	li $v0, 0  
	add $t0, $zero, $a0
	li $t2, 0  # length = 0
	li $t4, 1  # i = 0
	li $t5, 2  # 2

	go_end:
		lbu $t1, 0($t0) 
		beq $t1, $zero, test # if(a[length] = NULL)
		addi $t0, $t0, 1 # a++
		addi $t2, $t2, 1 # length++
		j go_end

	test:
		div $t2, $t5 # length = length / 2
		mflo $t2

	addi $t0, $t0, -1 # b[length - 1]
	loop:	 
		beq $t4, $t2, end2 # while(i!= length/2)
		lbu $t1, 0($t0)
		lbu $t3, 0($a0)
		bne $t1, $t3, not_palindrome 
		li $v0, 1
		addi $t0, $t0, -1
		addi $a0, $a0, 1
		addi $t4, $t4, 1
		j loop

	end2:
		jr $ra

	not_palindrome:
		li $v0, 0
		j end2



countlocalminima:
	li $v0, 0  # num_minima = 0
	li $t0, 0 # i 
	addi $a1, $a1, -1

	find:
		addi $a1, $a1, -1 
		beq $t0, $a1, end3 #while (i != length - 2)
		lw $t1, 0($a0) # n1
		lw $t2, 4($a0) # n2
		lw $t3, 8($a0) # n3
		blt $t2, $t1, less_one # if(n2 < n1 ) less_one
	end_find:
		addi $a0, $a0, 4 # a = a + 4
		j find

	end3:
		jr $ra

	less_one:
		blt $t2, $t3, minima # if(n2 < n3) minima
		j end_find

	minima: 
		addi $v0, $v0, 1 # num_minima++;
		j end_find
	
.globl main
main:
	
	## First test case, should print:
	##    32
	##    31
 	li $a0, 32
 	jal test_countzeroes

	## Second test case, should print:
	##    232
	##    28
 	li $a0, 232
 	jal test_countzeroes

	## Third test case, should print:
	##    7
	##    29
 	li $a0, 7
 	jal test_countzeroes

	## First test case, should print:
	##    Hello
	##    0
	la $a0, text1
	jal test_ispalindrome

	## Second test case, should print:
	##    HellolleH
	##    1
	la $a0, text2
	jal test_ispalindrome

	## Third test case, should print:
	##    HelllleH
	##    1
	la $a0, text3
	jal test_ispalindrome

	## Fourth test case, should print:
	##    Helllleh
	##    0
	la $a0, text4
	jal test_ispalindrome

	## First test case, should print:
	##    3 0 1 2 6 -2 4 7 3 7
	##    3
 	la $a0, array1
 	li $a1, 10
 	jal test_countlocalminima

	## Second test case, should print:
	##    3 0 1 2 6 -2
	##    1
 	la $a0, array2
 	li $a1, 6
 	jal test_countlocalminima

	## Third test case, should print:
	##    32 56 79 7 73 100 41 9 47 24 ...
	##    17
 	la $a0, array3
 	li $a1, 50
 	jal test_countlocalminima
	
	
	li 	$v0, 10         # Exit
	syscall

test_countzeroes:	
	addi $sp, $sp, -12
	sw $s0, 0($sp)	
	sw $s1, 4($sp)	
	sw $ra, 8($sp)
 	move $s0, $a0		
	jal countzeroes
	move $s1, $v0
	move $a0, $s0
	jal print_int
	jal print_newline
	move $a0, $s1
	jal print_int
	jal print_newline
	lw $s0, 0($sp)	
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	jr $ra
	
test_ispalindrome:	
	addi $sp, $sp, -12
	sw $s0, 0($sp)	
	sw $s1, 4($sp)	
	sw $ra, 8($sp)
 	move $s0, $a0		
	jal ispalindrome
	move $s1, $v0
	move $a0, $s0
	jal print_string
	jal print_newline
	move $a0, $s1
	jal print_int
	jal print_newline
	lw $s0, 0($sp)	
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	jr $ra

test_countlocalminima:	
	addi $sp, $sp, -20
	sw $s0, 0($sp)	
	sw $s1, 4($sp)	
	sw $s2, 8($sp)	
	sw $s3, 12($sp)	
	sw $ra, 16($sp)
	move $s0, $a0		
	move $s1, $a1
	move $s2, $a0	  # s2: pointer to curr element for loop
	sll $s3, $a1, 2	  
	add $s3, $a0, $s3 # s3: pointer to end of array for loop
test_countlocalminima__looptop:	
	beq $s2, $s3, test_countlocalminima__loopdone
	lw  $a0, 0($s2)
	jal print_int
	addi $s2, $s2, 4
	j test_countlocalminima__looptop
test_countlocalminima__loopdone:
	jal print_newline
  	move $a0, $s0     # load up original args
  	move $a1, $s1
  	jal countlocalminima
  	move $a0, $v0
  	jal print_int
	jal print_newline
	lw $s0, 0($sp)	
	lw $s1, 4($sp)	
	lw $s2, 8($sp)	
	lw $s3, 12($sp)	
	lw $ra, 16($sp)
	addi $sp, $sp, 20
	jr $ra

print_newline:
	      la    $a0, newline
	      li    $v0, 4
	      syscall
	      jr    $ra
	
print_string: 
	      li    $v0, 4
	      syscall
	      jr    $ra

print_int:
	      li    $v0, 1
	      syscall
	      la    $a0, space
	      li    $v0, 4
	      syscall
	      jr    $ra

.data
text1:		.asciiz "Hello"
text2:		.asciiz "HellolleH"
text3:		.asciiz "HelllleH"
text4:		.asciiz "Helllleh"

array1:		.word 3, 0, 1, 2, 6, -2, 4, 7, 3, 7
array2:		.word 3, 0, 1, 2, 6, -2
array3:	        .word 32, 56, 79, 9, 73, 100, 41, 9, 47, 24, 77, 53, 30, 46, 96, 60, 84, 30, 64, 1, 55, 70, 45, 97, 42, 19, 98, 22, 80, 90, 13, 30, 48, 36, 20, 57, 32, 34, 7, 91, 17, 59, 91, 66, 26, 88, 73, 88, 57, 25
	
newline:	.asciiz "\n"
space:   	.asciiz " " 