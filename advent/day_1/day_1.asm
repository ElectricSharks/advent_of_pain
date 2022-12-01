; day_1.asm
extern printf
extern atoi
extern closeFile
extern openFile
extern readFile
extern printString
extern logInfo
extern getLine
section .data
; create mode (permissions)
      NL         equ   0xa
      aoc_msg_1 db "Advent of Code 2022 - Day 1", NL, 0
      aoc_msg_ans_1 db "Part 1 Answer = %d", NL, 0
      aoc_msg_ans_2 db "Part 2 Answer = %d", NL, 0
      charBufferLen        equ   10000
      fileName   db    "data/data.txt", 0
      FD         dq    0    ; file descriptor
section .bss
      firstElfCalories resq 1
      secondElfCalories resq 1
      thirdElfCalories resq 1
      
      lastInt resq 1
      currentInt resq 1
      charBuffer resb charBufferLen
      intBuffer resb charBufferLen
section .text
      global main
main:
      push rbp
      mov  rbp,rsp
; open file to read
      mov rdi, aoc_msg_1
      call logInfo
      mov   rdi, fileName
      call  openFile
      mov  qword [FD], rax ; save file descriptor
; read from file
      mov   rdi, qword [FD]
      mov   rsi, charBuffer
      mov   rdx, charBufferLen
      call  readFile
; print out file contents
      ;mov   rdi,rax
      ;call  printString
; close the file
      mov rdi, qword [FD]
      call closeFile

;------------------------------------------
;
;     Calorie Counting
;
;------------------------------------------


; pre-loop preparation
      mov rax, 0
      mov [firstElfCalories], rax
      mov [secondElfCalories], rax
      mov [thirdElfCalories], rax
      mov rdi, charBuffer

; loop
part1Loop:
      call getElfCalories

; compare our current max calories to the next max calories.
      mov r9, [firstElfCalories]
      cmp rax, r9
      jle skipFirstCaloriesAssignment
; if rax > r9, then our new answer is rax
      mov [firstElfCalories], rax
      mov rax, r9
skipFirstCaloriesAssignment:
      mov r9, [secondElfCalories]
      cmp rax, r9
      jle skipSecondCaloriesAssignment
; if rax > r9, then our new answer is rax
      mov [secondElfCalories], rax
      mov rax, r9
skipSecondCaloriesAssignment:
      mov r9, [thirdElfCalories]
      cmp rax, r9
      jle endCalorieAssignment
; if rax > r9, then our new answer is rax
      mov [thirdElfCalories], rax
      jmp endCalorieAssignment

endCalorieAssignment:
; if rdi is now equal to a null byte, we jump to day1End, otherwise, we
; increment rdi (skipping the next newline), then continue our loop.
      cmp rdi, 0
      je day1End
      add rdi, 1
      jmp part1Loop

day1End:
      mov rdi, aoc_msg_ans_1
      mov rsi, [firstElfCalories]
      call printf

      mov rsi, [firstElfCalories]
      add rsi, [secondElfCalories]
      add rsi, [thirdElfCalories]
      mov rdi, aoc_msg_ans_2
      call printf
leave
ret




      global getElfCalories
getElfCalories:

; rdi should be a pointer to the next location of an integer in the
; charBuffer.
      mov rax, 0
      mov rcx, 0
elfCalorieLoop:
; if the charBuffer location contains a newline or the pointer is null, jump
; to exit.
      cmp rdi, 0
      je exitGetElfCalories
      cmp BYTE [rdi], NL
      je exitGetElfCalories

; read next value into intBuffer and store the next location on stack.
      mov rsi, intBuffer
      push rcx
      call getLine
      push rax

; convert intBuffer into int
      mov rax, 0
      mov rdi, intBuffer
      call atoi

; pop the nextCharBuffer location off the stack, then loop
      pop rdi
      pop rcx

; add int to rcx
      add rcx, rax

      jmp elfCalorieLoop

exitGetElfCalories:
      ; move the sum of the elf calories into rax
      mov rax, rcx
ret
