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
# Assignment:           3
# Due Date:             March 9, 2018
# Name:                 Zijun Wu
# Unix ID:              zijun4
# Lecture Section:      B1
# Instructor:           Karim Ali
# Lab Section:          H05
# Register Usage:
                        # t0: store the edge  
                        # t1: store the corner
                        # t2: store the jumping size
                        # t3: store the number of negative number
                        # t4: store the negative sum
                        # t5: store the number of positive number
                        # t6: store the positive sum
                        # t7: store the dimension
                        # sp: stack pointer
                        # fp: frame pointer
#---------------------------------------------------------------
.data
.text

CubeStats:
    addi	  $sp, $sp, -4      #adjust stack for one item
    sw		  $fp, 0($sp)       #store fp in stack
    move        $fp, $sp          #move sp to fp
    move          $t0, $a3          # copy a3(edge) to t0
    move          $t1, $a2          # copy a2(corner) to t1
    li		  $t3, 0            #initialize t3
    li		  $t4, 0            #initialize t4
    li		  $t5, 0            #initialize t5
    li		  $t6, 0            #initialize t6 
    beq		  $a0, 1, loop      #if dimension == 1 calculate result directly in loop

dimensionloop:
    li            $t2, 1            #t2 load 1
    move          $t7, $a0          #copy dimension to t7

dimensiondown:
    mul           $t2, $t2, $a1            #muliple t2 and a1
    addi          $t7, $t7, -1             #t7--
    bne		      $t7, 1, dimensiondown	   #if $t0 != $t1 then target

    # prepare to call subroutine
    sw		  $a0, -4($fp)		       
    sw		  $a2, -8($fp)	
    sw		  $ra, -12($fp)	
    sw		  $t3, -16($fp)	
    sw	  	  $t4, -20($fp)
    sw		  $t5, -24($fp)	
    sw		  $t6, -28($fp)
    addi      $t0, $t0, -1
    sw		  $t0, -32($fp)	
    addi      $sp, $sp, -32

    #next corner
    addi      $a0, $a0, -1    
    mul		  $t2, $t2, $t0
    li        $t7, 4
    mul    	  $t2, $t2, $t7
    add		  $a2, $a2, $t2		
  
    jal	  	  CubeStats		          #call CubeStats

    #restore and save
    lw		  $a0, -4($fp)	 
    lw	  	  $a2, -8($fp)		
    lw	          $ra, -12($fp)		
    lw	          $t3, -16($fp)	
    lw	  	  $t4, -20($fp)	
    lw	  	  $t5, -24($fp)	
    lw		  $t6, -28($fp)	
    lw		  $t0, -32($fp)

    lw            $t2, -36($fp)
    add	  	  $t3, $t3, $t2	
    lw		  $t2, -40($fp)	
    add		  $t4, $t4, $t2	
    lw		  $t2, -44($fp)	
    add		  $t5, $t5, $t2	
    lw		  $t2, -48($fp)	
    add		  $t6, $t6, $t2	
    addi          $sp, $sp, 48  

    beq		  $t0, $zero, CubeEnd   #if t0 == 0 then prepare to calculate average
    j 		  dimensionloop         #jump to dimensionloop
    
loop:
    addi	 $t0, $t0, -1		   # $t0--
    lw  	 $t2, 0($t1)            #load t1 to t2
    addi         $t1, $t1, 4            #cornor update
    beq          $t2, $zero, continue   # if t2 == 0 then continue
    bgtz	 $t2, posCount	        # if $t2 > 0 then posCount

negCount:
    addi         $t3, $t3, 1                #negcounter++
    add		 $t4, $t4, $t2		    #update negative sum
    j		 continue		    #jump to continue
    
posCount:
    addi         $t5, $t5, 1                #poscounter++
    add		 $t6, $t6, $t2		    #update positive sum
    
continue:
    bne		 $t0, $zero, loop	    #if t0 != 0 then loop again

CubeEnd:
    # restore fp and sp
    move	  $sp, $fp              
    lw		  $fp, 0($fp) 
      
    sw		  $t3, 0($sp)		
    sw		  $t4, -4($sp)	
    sw		  $t5, -8($sp)		
    sw		  $t6, -12($sp)	 
    addi          $sp, $sp, -12

negCal: 
    beq		  $t3, $zero, noNeg         #if t3 == 0 then allpos
    div           $t4, $t3                  #divide t4 and t3 and the result is in LO
    mflo          $v0                       #move from lo to v0
    mfhi          $t3                       #move from hi(remainder) to t3
    beq		  $t3, $zero, noRemainder   #if t3 == 0 the noRemainder
    addi	  $v0, $v0, -1              #else v0--

noRemainder:
    j		  posCal                    #calculate positive number

noNeg:
    li		  $v0, 0                    #set neg average to 0
		
posCal:
    beq		  $t5, $zero, noPos        #if t5 == 0 there is no pos average
    div           $t6, $t5                 #divide t6 and t5 and result is in LO
    mflo          $v1                      #move from lo to v1
    j		  return                   #finish

noPos:
    li		  $v1, 0                  #set pos average to 0

return:
    jr          $ra                        #return to main


