TITLE CompositeNumbers     (Assignment3.asm)

; Author: Parker Howell
; Course / Project ID      CS271 Assignment 3            
; Date: 7-21-16
; Description: First, the user is instructed to enter the number of composites to be displayed, 
;              and is prompted to enter an integer in the range [1 .. 400]. The user enters a 
;              number, n, and the program verifies that n is between 1 and 400 inclusive. If n 
;              is out of range, the user is re-prompted until s/he enters a value in the 
;              specified range. The program then calculates and displays all of the composite  
;              numbers up to and including the nth composite. The results should be displayed  
;              10 composites per line with at least 3 spaces between the numbers.

INCLUDE Irvine32.inc

MIN = 1     ; smallest user entered amount of composite numbers to display
MAX = 400    ; largest user entered amount of composite numbers to display
PERLINE = 10    ; number of composite numbers to print per line


.data

userComps     DWORD     ?         ; user entered integer amount of fibonacci numbers to display
compCount     DWORD     0         ; how many composite numbers have been printed on the current line
testNum       DWORD     4         ; number being looped over to test if composite 4 is lowest composite

intro      BYTE     "Hello, and welcome to Parker Howell's assignment 3, composite numbers program!",0dh,0ah
           BYTE     "**EC: Align the output columns.", 0
instruct   BYTE     "How many composite numbers would you like to see displayed?",0dh,0ah
           BYTE     "[1 - 400]: ", 0
bigNum     BYTE     "You entered a number that is too large.", 0
smallNum   BYTE     "You entered a number that is too small.", 0
reEnter    BYTE     "Please enter a number between 1 and 400: ", 0
bye        BYTE     "Who needs prime numbers anyways?  :P   Bye!", 0


.code
main PROC

     call Clrscr             ; clears the screen
     call introduction       ; introduces program
     call getUserData        ; gets and validates user data
     call showComposites     ; finds and displays composites
     call farewell           ; say goodbye

	exit	; exit to operating system
main ENDP


;************************************************************************
; procedures below 
;************************************************************************

;************************************************************************
introduction PROC
; Procedure to introduce the program and author.
; receives: none
; returns: none
; preconditions: none
; registers changed: edx
;************************************************************************
     mov       edx, OFFSET intro         ; prints intro to console
     call      WriteString
     call      CrLf
     ret
introduction ENDP




;************************************************************************
getUserData PROC
; Procedure to prompt the user to enter a number between 1-400. calls validation
; procedure to ensure entered number is within range.
; receives: none
; returns: none
; preconditions: none
; registers changed: edx
;************************************************************************
     mov       edx, OFFSET instruct       ; prints instruct to console
     call      WriteString
     call      validation                 ; validate that userDate is in range
     ret
getUserData ENDP




;************************************************************************
validation PROC
; Procedure to validate user entered number of composite numbers to print
; receives: user entered value of composite numbers from standard input
; returns: a valid range of composites to display in userComps
; preconditions: the user has been prompted to enter a value, and the value 
;                has been entered into the keyboard.
; registers changed: eax, edx
;************************************************************************
     Validate:      call      ReadDec              ; read user input
                    mov       userComps, eax       ; save the input

                    cmp       userComps, MIN       ; if user value is less than MIN
                    jl        TooSmall             ; jump to TooSmall

                    cmp       userComps, MAX       ; if user value is larger than MAX
                    jg        TooBig               ; jump to TooBig

                    jmp       GoodNum              ; otherwise the value is within range
                                                   ; continue with program

     ; if the user value was too small
     TooSmall:      call      CrLf
                    mov       edx, OFFSET smallNum     ; tell the user the number was too small
                    call      WriteString
                    call      CrLf
                    jmp       RePrompt                 ; jump to RePrompt to ask user to enter another num

     ; if the user value was too big
     TooBig:        call      CrLf
                    mov       edx, OFFSET bigNum       ; tell the user the number was too big
                    call      WriteString
                    call      CrLf                     ; falls through to RePrompt

     ; ask user to enter another number
     RePrompt:      mov       edx, OFFSET reEnter      ; ask the user to re-enter an new number
                    call      WriteString
                    jmp       Validate                 ; jump to top to have user reenter another number

     ; if the user value was within range
     GoodNum:            ; carry on with the program
     call      CrLf      ; formatting

     ret
validation ENDP




;************************************************************************
showComposites PROC
; Procedure to find and print composite values
; receives: none
; returns: composites printed to console
; preconditions: userComps is a valid value between 1 - 400
;                testNum = 4
; registers changed: eax, ecx
;************************************************************************
     mov       ecx, userComps       ; set outer loop counter 

OuterLoop:                          ; loops through numbers until it has found userComps 
                                    ; amount of composite numbers 
                                       
     push      ecx                  ; save outer loop count
     call      isComposite          ; loop increment testNum until a composite number is found 
     pop       ecx                  ; restore outer loop counter
    
     mov       eax, testNum         ; print the composite number
     call      writeDec 
     inc       testNum              ; so we can test next value

     ; Yay, extra credit!
     mov       al, 9                ; align the colums 9 = tab
     call      writeChar

     inc       compCount            ; track how many comps have been printed to the current line
     cmp       compCount, PERLINE   ; test if we need a new line
     jl        nextComp             ; jump if we dont need a new line
     
     call      CrLf                 ; else we set console to next line 
     mov       compCount, 0         ; and reset compCount     

nextComp:
     Loop      OuterLoop            ; repeat userComp times

     call      CrLf                 ; formating
     call      CrLf

     ret
showComposites ENDP




;************************************************************************
isComposite PROC
; Procedure to find the next composite number, will loop until next one 
; is found
; receives: none
; returns: value in testNum is the next composite number to print
; preconditions: testNum is set to next value to test
; registers changed: ecx, edx, eax
;************************************************************************
     mov  ecx, 1         ; set divisor
compTest:                ; Note: testNum is always 4 or larger
     inc  ecx            ; ecx starts at 2 and test next values from there
     cmp  ecx, testNum   ; have we tested all values below testNum?
     jl   notAbove       ; if not jump down and continue test

                         ; if so, testNum isn't composite so need to test next value
     inc  testNum        ; increments testnum
     mov  ecx, 1         ; and resets ecx divisor
     jmp  compTest 

notAbove:                
     mov  edx, 0         ; clear edx for division
     mov  eax, testNum   ; set eax for division
     div  ecx            ; divide -    edx:eax / ecx

     cmp  edx, 0         ; test for a remainder
     jne  compTest       ; if there is no remainder, jump to top and test again

                         ; else ther is no remainder, so fall out of procedure

     ret
isComposite ENDP



;************************************************************************
farewell PROC
; Procedure to say goodbye
; receives: none
; returns: prints bye message to console
; preconditions: none
; registers changed: edx
;************************************************************************
     mov       edx, OFFSET bye
     call      WriteString
     call      CrLf
     call      CrLf

     ret
farewell ENDP



END main
