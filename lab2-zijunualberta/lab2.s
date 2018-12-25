# CMPUT 229 Student Submission License (Version 1.1)

# Copyright 2018 `Zijun Wu`

# Unauthorized redistribution is forbidden in all circumstances. Use of this software without explicit authorization from the author **or** CMPUT 229 Teaching Staff is prohibited.

# This software was produced as a solution for an assignment in the course CMPUT 229 (Computer Organization and Architecture I) at the University of Alberta, Canada. This solution is confidential and remains confidential after it is submitted for grading. The course staff has the right to run plagiarism-detection tools on any code developed under this license, even beyond the duration of the course.

# Copying any part of this solution without including this copyright notice is illegal.

# If any portion of this software is included in a solution submitted for grading at an educational institution, the submitter will be subject to the sanctions for plagiarism at that institution.

# This software cannot be publicly posted under any circumstances, whether by
# the original student or by a third party. If this software is found in any public website or public repository, the person finding it is kindly requested to immediately report, including the URL or other repository locating information, to the following email address: [cmput229@ualberta.ca](mailto:cmput229@ualberta.ca).

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#---------------------------------------------------------------
# Assignment:           2
# Due Date:             Feb 11, 2018
# Name:                 Zijun Wu
# Unix ID:              zijun4
# Lecture Section:      B1
# Instructor:           Karim Ali
# Lab Section:          H05
#
# Register Usage
#
#       t0: store the content of a0
#       t1: load immidiate a number to add step by step, to branch each condition
#       t2: buffer stored the content of a0
#
#---------------------------------------------------------------


.data
bgez1:          .asciiz "bgez " 
bgezal1:        .asciiz "bgezal "  
bltz1:          .asciiz "bltz "
bltzal1:        .asciiz "bltzal "
beq1:           .asciiz "beq "
bne1:           .asciiz "bne "
blez1:          .asciiz "blez "
bgtz1:          .asciiz "bgtz "
money:          .asciiz "$"
comma:          .asciiz ", "
oxStr:	        .asciiz "0x"
double:         .space 8
.text

disassembleBranch:
        lw $t0, 0($a0)                  #t0 is the content in $a0
        li $t1, 1                       #$t1 <- 1
        srl $t0, $t0, 26
        beq $t0, $t1, branch            #bltz,bgez,bltzal,bgezal
        addi $t1, $t1, 3
        beq $t0, $t1, branch_beq        #beq
        addi $t1, $t1, 1
        beq $t0, $t1, branch_bne        #bne
        addi $t1, $t1, 1
        beq $t0, $t1, branch_blez       #blez
        addi $t1, $t1, 1
        beq $t0, $t1, branch_bgtz       #bgtz
        j Exit

branch:
        li $t1, 31
        sll $t1, $t1, 16
        lw $t3, 0($a0)
        and $t1, $t1, $t3 
        srl $t1, $t1, 16
        li $t0, 0
        beq $t0, $t1, branch_bltz       #bltz
        addi $t0, $t0, 1
        beq $t0, $t1, branch_bgez       #bgez
        addi $t0, $t0, 15
        beq $t0, $t1, branch_bltzal     #bltzal
        addi $t0, $t0, 1    
        beq $t0, $t1, branch_bgezal     #bgezal
        j Exit
                           
branch_bltz:
        move $t2, $a0
        la $a0, bltz1
        li $v0, 4
        syscall		 
        move $a0, $t2           #print the string

        move $t2, $a0
        la $a0, money
        li $v0, 4
        syscall		 
        move $a0, $t2           #print $

        lw $t0, 0($a0)
        sll $t0, $t0, 6
        srl $t0, $t0, 27        #get $rs

        move $t2, $a0
        move $a0, $t0
        li $v0, 1
        syscall		 
        move $a0, $t2           #print the integer

        move $t2, $a0
        la $a0, comma
        li $v0, 4
        syscall		
        move $a0, $t2           #print the comma

        lw $t0, 0($a0)
        sll $t1, $t0, 16
        sra $t1, $t1, 14           

        add $t1, $a0, $t1
        addi $a2, $t1, 4        #finish computing the offset and stored in $a2


        move    $a1 $ra
	jal     printHex        #call printHex
	move	$ra $a1         

        j Exit


branch_bgez:
        move $t2, $a0
        la $a0, bgez1
        li $v0, 4
        syscall                 #print the string
        move $a0, $t2

        move $t2, $a0
        la $a0, money
        li $v0, 4
        syscall		        #print $
        move $a0, $t2

        lw $t0, 0($a0)
        sll $t0, $t0, 6
        srl $t0, $t0, 27        #get the $rs

        move $t2, $a0
        move $a0, $t0
        li $v0, 1
        syscall		        #print the integer
        move $a0, $t2

        move $t2, $a0
        la $a0, comma
        li $v0, 4
        syscall		        #print the comma
        move $a0, $t2

        lw $t0, 0($a0)
        sll $t1, $t0, 16
        sra $t1, $t1, 14        

        add $t1, $a0, $t1
        addi $a2, $t1, 4         #finish computing the offset and stored in $a2

        move	$a1 $ra
	jal	printHex        #call printHex
	move	$ra $a1

        j Exit

branch_bltzal:
        move $t2, $a0
        la $a0, bltzal1
        li $v0, 4
        syscall		         #print the string
        move $a0, $t2

        move $t2, $a0
        la $a0, money
        li $v0, 4
        syscall		         #print $
        move $a0, $t2

        lw $t0, 0($a0)
        sll $t0, $t0, 6
        srl $t0, $t0, 27        #get the $rs

        move $t2, $a0
        move $a0, $t0
        li $v0, 1
        syscall                 #print the integer
        move $a0, $t2

        move $t2, $a0
        la $a0, comma
        li $v0, 4
        syscall		        #print the comma
        move $a0, $t2

        lw $t0, 0($a0)
        sll $t1, $t0, 16
        sra $t1, $t1, 14           

        add $t1, $a0, $t1
        addi $a2, $t1, 4        #finish computing the offset and stored in $a2


        move	$a1 $ra
	jal	printHex        #call printHex
	move	$ra $a1

        j Exit


branch_bgezal:
        move $t2, $a0
        la $a0, bgezal1
        li $v0, 4
        syscall		         #print the string
        move $a0, $t2

        move $t2, $a0
        la $a0, money
        li $v0, 4
        syscall		         #print $
        move $a0, $t2

        lw $t0, 0($a0)
        sll $t0, $t0, 6
        srl $t0, $t0, 27        #$get the $rs

        move $t2, $a0
        move $a0, $t0
        li $v0, 1
        syscall		        #print the integer
        move $a0, $t2

        move $t2, $a0
        la $a0, comma
        li $v0, 4
        syscall		         #print the comma
        move $a0, $t2

        lw $t0, 0($a0)
        sll $t1, $t0, 16
        sra $t1, $t1, 14 
	
	      
        add $t1, $a0, $t1
        addi $a2, $t1, 4         #finish computing the offset and stored in $a2

        move	$a1 $ra
	jal	printHex         #call printHex
	move	$ra $a1

	 
        j Exit


branch_beq:
        move $t2, $a0
        la $a0, beq1
        li $v0, 4
        syscall		        #print the string
        move $a0, $t2

        move $t2, $a0
        la $a0, money
        li $v0, 4
        syscall		        #print $
        move $a0, $t2

        lw $t0, 0($a0)
        sll $t0, $t0, 6
        srl $t0, $t0, 27        #get the $rs 

        move $t2, $a0
        move $a0, $t0
        li $v0, 1
        syscall		        #print the integer
        move $a0, $t2

        move $t2, $a0
        la $a0, comma
        li $v0, 4
        syscall		        #print the comma
        move $a0, $t2

        lw $t0, 0($a0)
        sll $t0, $t0, 11
        srl $t0, $t0, 27        #get the $rt

        move $t2, $a0
        la $a0, money
        li $v0, 4
        syscall		        #print $
        move $a0, $t2

        move $t2, $a0
        move $a0, $t0
        li $v0, 1
        syscall		        #print the integer
        move $a0, $t2

        move $t2, $a0
        la $a0, comma
        li $v0, 4
        syscall		        #print the comma
        move $a0, $t2

        lw $t0, 0($a0)
        sll $t1, $t0, 16
        sra $t1, $t1, 14  

        add $t1, $a0, $t1
        addi $a2, $t1, 4        #finish computing the offset and stored in $a2

        move	$a1 $ra
	jal	printHex        #call printHex
	move	$ra $a1

        j Exit

branch_bne:
        move $t2, $a0
        la $a0, bne1
        li $v0, 4
        syscall		        #print the string
        move $a0, $t2

        move $t2, $a0
        la $a0, money
        li $v0, 4
        syscall		        #print $
        move $a0, $t2

        lw $t0, 0($a0)
        sll $t0, $t0, 6
        srl $t0, $t0, 27        #get the $ts 

        move $t2, $a0
        move $a0, $t0
        li $v0, 1
        syscall		        #print the integer
        move $a0, $t2

        move $t2, $a0
        la $a0, comma
        li $v0, 4
        syscall		        #print the comma
        move $a0, $t2

        move $t2, $a0
        la $a0, money
        li $v0, 4
        syscall		        #print $
        move $a0, $t2

	lw $t0, 0($a0)
        sll $t0, $t0, 11
        srl $t0, $t0, 27        #get the rt

        move $t2, $a0
        move $a0, $t0
        li $v0, 1
        syscall		        #print the string
        move $a0, $t2

        move $t2, $a0
        la $a0, comma
        li $v0, 4
        syscall		        #print the comma
        move $a0, $t2

        lw $t0, 0($a0)
        sll $t1, $t0, 16
        sra $t1, $t1, 14 
      
        add $t1, $a0, $t1
        addi $a2, $t1, 4        #finish computing the offset and stored in $a2


        move	$a1 $ra
	jal	printHex        #call printHex
	move	$ra $a1

        j Exit


branch_blez:

        lw $t0, 0($a0)
        sll $t0, $t0, 11
        srl $t0, $t0, 27
        bne $t0, $zero, Exit    #judge if bits 16-20 are 00000

        move $t2, $a0
        la $a0, blez1
        li $v0, 4
        syscall		        #print the string
        move $a0, $t2

        move $t2, $a0
        la $a0, money
        li $v0, 4
        syscall		        #print $
        move $a0, $t2

        lw $t0, 0($a0)
        sll $t0, $t0, 6
        srl $t0, $t0, 27        #get the $ts

        move $t2, $a0
        move $a0, $t0
        li $v0, 1
        syscall		        #print the integer
        move $a0, $t2

        move $t2, $a0
        la $a0, comma
        li $v0, 4
        syscall		        #print the comma
        move $a0, $t2

        lw $t0, 0($a0)
        sll $t1, $t0, 16
        sra $t1, $t1, 14           

        add $t1, $a0, $t1
        addi $a2, $t1, 4        #finish computing the offset and stored in $a2


        move	$a1 $ra
	jal	printHex        #call printHex
	move	$ra $a1

        j Exit
        

branch_bgtz:

        lw $t0, 0($a0)
        sll $t0, $t0, 11
        srl $t0, $t0, 27
        bne $t0, $zero, Exit    #judge if bits 16-20 are 00000
        
        move $t2, $a0
        la $a0, bgtz1
        li $v0, 4
        syscall		        #print the string
        move $a0, $t2

        move $t2, $a0
        la $a0, money
        li $v0, 4
        syscall		        #print $
        move $a0, $t2

        lw $t0, 0($a0)
        sll $t0, $t0, 6
        srl $t0, $t0, 27        #get the $rs

        move $t2, $a0
        move $a0, $t0
        li $v0, 1
        syscall		        #print the integer
        move $a0, $t2

        move $t2, $a0
        la $a0, comma
        li $v0, 4
        syscall		        #print the comma
        move $a0, $t2

        lw $t0, 0($a0)
        sll $t1, $t0, 16
        sra $t1, $t1, 14           

        add $t1, $a0, $t1
        addi $a2, $t1, 4        #finish computing the offset and stored in $a2


        move	$a1 $ra
	jal	printHex        #call printHex
	move	$ra $a1

        j Exit

Exit:
        
        jr $ra

#---------------------------------------------------------
#       a2: parameter to be converted into Hex
#	t0: temp for pick a digit of hexidecimal
#	t1: result of t0-10
#	t2: address of a digit of the double
#	t3: how much digit a0 shift to left
#	t4: a constant number 28
#	t5: result of t3/4
#---------------------------------------------------------
#subroutine printHex
#---------------------------------------------------------
printHex:
	li 	$t3 0

convert:
	li 	$t4 28
	sllv	$t0 $a2 $t3
	srl 	$t0 $t0 28
	addi 	$t1 $t0 -10
	bgez 	$t1 letter
	addi 	$t0 $t0 48
	
	j 	last

letter:
	addi 	$t0 $t1 97

last:
	la	$t2 double
	srl	$t5 $t3 2
	add	$t2 $t2 $t5
	sb	$t0 0($t2) 
	addi 	$t3 4
	addi	$t4 4
	bne 	$t3 $t4 convert

	move $t2, $a0      
	la	$a0 oxStr
	li	$v0 4           #Print '0x' as a prompt 
	syscall	
	move  $a0,$t2

	move $t2, $a0
	li	$v0 4
	la	$a0 double      #print this digit
	syscall
	move  $a0,$t2

	jr	$ra