#CMPUT 229 Student Submission License (Version 1.1)

#Copyright 2018 zijun wu
#Unauthorized redistribution is forbidden in all circumstances. Use of this software without explicit authorization from the author **or** CMPUT 229 Teaching Staff is prohibited.

#This software was produced as a solution for an assignment in the course CMPUT 229 (Computer Organization and Architecture I) at the University of Alberta, Canada. This solution is confidential and remains confidential after it is submitted for grading. The course staff has the right to run plagiarism-detection tools on any code developed under this license, even beyond the duration of the course.

#Copying any part of this solution without including this copyright notice is illegal.

#If any portion of this software is included in a solution submitted for grading at an educational institution, the submitter will be subject to the sanctions for plagiarism at that institution.

#This software cannot be publicly posted under any circumstances, whether by
#the original student or by a third party. If this software is found in any public website or public repository, the person finding it is kindly requested to immediately report, including the URL or other repository locating information, to the following email address: [cmput229@ualberta.ca](mailto:cmput229@ualberta.ca).

#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#---------------------------------------------------------------
# Assignment:           1
# Due Date:             January 26, 2018
# Name:                 Zijun Wu
# Unix ID:              zijun4
# Lecture Section:      B1
# Instructor:           Karim Ali
# Lab Section:          H05
#---------------------------------------------------------------

    .data
prompt:
    .asciiz "Input N: "

    .text

main: 
    li  $v0, 4
	la  $a0, prompt   #print prompt
	syscall		 

    li      $v0, 5
    syscall
    move    $t0, $v0     #store int into t0

    
    andi    $t1, $t0, 0x000000ff    #mask he most significant 3bytes.
    sll     $t1, $t1, 24            #shift the least significant byte to the most significant place.
    andi    $t2, $t0, 0xff000000
    srl     $t2, $t2, 24
    andi    $t3, $t0, 0x00ff0000
    srl     $t3, $t3, 8
    andi    $t4, $t0, 0x0000ff00
    sll     $t4, $t4, 8
    add     $t1, $t1, $t2           
    add     $t3, $t3, $t4 
    add     $t1, $t1, $t3           #add on 4 calculated bytes
    

    li 	    $v0,1 
    la      $a0, 0($t1)
    syscall		 #print the integer

    
