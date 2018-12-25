# CMPUT 229 Student Submission License (Version 1.1)
# Copyright 2018 `Zijun Wu`
# Unauthorized redistribution is forbidden in all circumstances. Use of this software without explicit authorization from the author **or** CMPUT 229 Teaching Staff is prohibited.
# This software was produced as a solution for an assignment in the course CMPUT 229 (Computer Organization and Architecture I) at the University of Alberta, Canada. This solution is confidential and remains confidential after it is submitted for grading. The course staff has the right to run plagiarism-detection tools on any code developed under this license, even beyond the duration of the course.
# Copying any part of this solution without including this copyright notice is illegal.
# If any portion of this software is included in a solution submitted for grading at an educational institution, the submitter will be subject to the sanctions for plagiarism at that institution.
# This software cannot be publicly posted under any circumstances, whether by
# the original student or by a third party. If this software is found in any public website or public repository, the person finding it is kindly requested to immediately report, including the URL or other repository locating information, to the following email address: [cmput229@ualberta.ca](mailto:cmput229@ualberta.ca).
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
#-----------------------------------------------------------------------------
# Assignment:           4
# Due Date:             March 27, 2018
# Name:                 Zijun Wu
# Unix ID:              zijun4
# Lecture Section:      B1
# Instructor:           Karim Ali
# Lab Section:          H05
# Register Usage:
			# t0: store the 10 display digits
                        # t1: store one digit in display digits
                        # t2: judge if the display is ready
                        # t3: temporary resgister
                        # t4: judge if there's an input 
                        # t5: get the input data
                        # t6: only substruct the second after the timer intrupt happens
						# a0: the timer interupt bit in cause register    
						# a1: pass the parameter seconds to main       
#12 status 
#13 cause
#14 EPC
#9 timer count         ##set to 0
#11 timer compare      ##set to 100   when 9 and 11 equal, raise an exception
#Keyboard control at 0xffff 0000. 
#Keyboard data at 0xffff 0004. 
#Display control at 0xffff 0008. 
#Display data at 0xffff 000C.
#-----------------------------------------------------------------------------

#Exception handler
	.kdata
	save1: .word 0
	.ktext 	0x80000180   			# This is the exception vector address for MIPS32:

	sw 	$a0, save1
	mfc0 	$a0, $13 			#move cause register in a0
	andi 	$a0, $a0, 0x8000		#mask out the 15th bit
	sll 	$a0, $a0, 15			#shift this bit left by 15
	bnez	$a0, resettimer			#if it is a timer interupt then reset timer
	j 	end				#else end

resettimer:
	mtc0 	$zero, $9			#reset $9 to 0	
	addi 	$k0, $zero, 100
	mtc0 	$k0, $11			#reset $11 to 100

	li	$t6, 1			#t6 is 1 then substruct second

end:
	mtc0	$zero, $13			#clear cause register
	mfc0 	$k1, $12  
	ori  	$k1, 0x01 	 		#enable interrupts
	mtc0 	$k1, $12  
	lw 	$a0, save1

	eret

    .data
displaystr:
	#8 is a backspace; 48 is zero; 58 is ':'; 0 is the bit to end printing
	.byte 8,8,8,8,8,48,48,58,48,48,0	

str: 
    .asciiz "Second = "
	
    .text
main:
	addi	 $sp, $sp, -4            # Adjust the stack to save $ra
	sw	 	 $ra, 0($sp)            # Save $ra

start:
 	#start the timer
	mfc0	$t3, $12  				#status in $t3
	ori 	$t3, 0x01 				#enableinterrupts 
	mtc0 	$t3, $12  				#restore t3 in status register
	addi	$t3, $zero, 100				
	mtc0	$t3, $11				#set register 11 to a second			
	mtc0	$zero, $9				#set register 9 to zero

	#enable keyboard interupt
	lw	$t3, 0xffff0000				
	ori	$t3, $t3, 0x02				#set bit 1 to 1
	sw	$t3, 0xffff0000
    #convert the seconds into the correct form

show:   
	addi    $t0, $zero, 60
    div     $a1, $t0
    mfhi    $t0
    mflo    $t1					
    addi    $t3, $zero, 10
    div     $t1, $t3
    mfhi    $t2			#minute
    mflo    $t1			#ten minute
    div     $t0, $t3
    mfhi    $t4			#second
   	mflo    $t3         		#ten second
	
    #convert the integer into ASCCI
    addi    $t1, $t1, 48
    addi    $t2, $t2, 48
    addi    $t3, $t3, 48
    addi    $t4, $t4, 48  

    #initilize the starting time in the array
    la 	$t0, displaystr				#load array of str to $t0
    sb	$t1, 5($t0)					
    sb 	$t2, 6($t0)
    sb     $t3, 8($t0)
    sb	$t4, 9($t0)				


#the function loop and poll are from lab.pdf
printdigits:
	la 	$t0, displaystr	

loop:	
    	lb	$t1, 0($t0)      			#load onr digit in display
	beqz	$t1, printdone				#if digit is 0 then stop printing
					
poll:	
	li	$t3, 0xffff0008
	lw 	$t2, 0($t3)				#load control register of display
	andi	$t2, $t2, 0x01				#get the last bit
	beqz	$t2, poll			    	#not ready, no interrupts
	li	$t3, 0xffff000c				
	sw 	$t1, 0($t3)				#put the digit into display data and print
	addi	$t0, $t0, 1				#next digit
	j	loop	
	
printdone:
	li	$t6, 0					#disable subtractsecond
			
waitinput:
	#wait for keyboard input
	bnez  	$t6, timerinterupt		#if 1 then there is, if 0 then no timerinterupt
	j		keyboard				# jump to keyboard
	
timerinterupt:
	j		subtractsecond			#jump to subtractsecond

keyboard:	
	li 	$t3, 0xFFFF0000				#get the address of input control
	lw	$t4, 0($t3)				#load the bits in input control
	andi	$t4, $t4, 0x1				#get the least significant bit
	bnez	$t4, hasinput				#if zero, then no keyboard interupt
	j		waitinput

hasinput:	
	li	$t3, 0xFFFF0004				#get the address of input data
	lw	$t5, 0($t3)				#load the bits in input data

	beq 	$t5, 113, quit				#user inputs q in the keyboard then quit
	j 	waitinput				#keep waiting for keyboard interrupts


subtractsecond:
	beqz	$a1, quit
	addi 	$a1, $a1, -1 
	j		show				# jump to show

quit:
	#exit the main
	lw      $ra, 0($sp)
	addi    $sp, $sp, 4
	jr		$ra					# jump to $ra
	
.globl __start
__start:
    la  	$a0, str
    li  	$v0, 4			#print the str
    syscall
    li  	$v0, 5			#read the input
    syscall
    move 	$a1, $v0      		#seconds in $t1
	jal 	main
    li      $v0, 10					# terminate program run and
    syscall 
