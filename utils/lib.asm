; lib.asm
extern printString
extern logInfo
extern logError
section .data
; syscall symbols
      NR_read    equ   0
      NR_open    equ   2
      NR_close   equ   3
      O_RDWR     equ   000002q
      NL         equ   0xa
    error_Close  db "error closing file",NL,0
    error_Open   db "error opening file",NL,0
    error_Read   db "error reading file",NL,0
    error_Print  db "error printing string",NL,0
    success_Close     db "File closed",NL,NL,0
    success_Open      db "File opened for R/W",NL,0
    success_Read      db "Reading file",NL,0
section .bss
section .text
; FILE MANIPULATION FUNCTIONS--------------------
;------------------------------------------------
global readFile
readFile:
      mov   rax, NR_read
      syscall      ; rax contains # of characters read
      cmp   rax, 0
      jl    readerror
      mov   byte [rsi+rax],0 ; add a terminating zero
      mov   rax, rsi
      mov   rdi, success_Read
      push  rax        ; caller saved
      call  logInfo
      pop   rax        ; caller saved
      ret
readerror:
      mov   rdi, error_Read
      call  logError
      ret
;------------------------------------------------
global openFile
openFile:
      mov   rax, NR_open
      mov   rsi, O_RDWR
      syscall
      cmp   rax, 0
      jl    openerror
      mov   rdi, success_Open
      push  rax        ; caller saved
      call  logInfo
      pop   rax        ; caller saved
      ret
openerror:
      mov   rdi, error_Open
      call  logError
      ret
;---------------------------------------------
global closeFile
closeFile:
      mov   rax, NR_close
      syscall
      cmp   rax, 0
      jl    closeerror
      mov   rdi, success_Close
      call  logInfo
      ret
closeerror:
      mov   rdi, error_Close
      call  logError
      ret
;-----------------------------------------------
global getLine
; Reads characters from a character buffer pointed to by rdi into a character
; buffer pointed to by rsi, until it hits a newline or a zero character. If it
; exits due to a newline, it returns the location in memory of the next
; byte after that newline.
; If it exits due to a zero, it returns a 0. 
getLine:
      mov rax, 0
      mov rcx, 0
copyloopGetLine:
      cmp BYTE [rdi], 0
      je exitEndOfBuffer
      cmp BYTE [rdi], NL
      je exitEndOfLine
      mov al, [rdi]
      mov [rsi], al
      add rdi, 1
      add rsi, 1
      jmp copyloopGetLine
      ; Now increment the value pointed to by rdi/rsi
exitEndOfLine:
      ; return the address of the next non-newline character.
      mov rax, rdi
      add rax, 1
      jmp exitGetLine
exitEndOfBuffer:
      ; return 0
      mov rax, 0
      jmp exitGetLine
exitGetLine:
      ; add null byte to terminate new buffer.
      ;mov al, 0
      mov [rsi], BYTE 0
      ret

