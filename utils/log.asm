; log.asm
section .data
    ; ANSI escape characters
    AEC_RED db `\u001b[31m`,0
    AEC_BLUE db `\u001b[34m`, 0
    AEC_RESET db `\u001b[0m`, 0
    AEC_CYAN db `\u001b[36m`, 0
    ; logging strings
    info_string db "[INFO] ", 0
    error_string db "[ERROR] ", 0
section .bss
section .text
;-----------------------------------------------
; INFO LEVEL LOG
;-----------------------------------------------
global logInfo
logInfo:
    push rdi
    mov rdi, AEC_CYAN
    call printString
    mov rdi, info_string
    call printString
    mov rdi, AEC_RESET
    call printString
    pop rdi
    call printString
    ret
;-----------------------------------------------
; ERROR LEVEL LOG
;-----------------------------------------------
global logError
logError:
    push rdi
    mov rdi, AEC_RED
    call printString
    mov rdi, error_string
    call printString
    mov rdi, AEC_RESET
    call printString
    pop rdi
    call printString
    ret
;-----------------------------------------------
; PRINT
;-----------------------------------------------
global printString
printString:
; Count characters
      mov   r12, rdi
      mov   rdx, 0
strLoop:
      cmp   byte [r12], 0
      je    strDone
      inc   rdx                    ;length in rdx
      inc   r12
      jmp   strLoop
strDone:
      cmp   rdx, 0                 ; no string (0 length)
      je    prtDone
      mov   rsi,rdi
      mov   rax, 1
      mov   rdi, 1
      syscall
prtDone:
      ret