XSTACK SEGMENT STACK 'STACK'
  db 10 dup('STACK')
XSTACK ENDS
ASSUME cs:CODE
CODE SEGMENT
star_bufor  dw 1200 dup(?)
file_name   db 'stars.dat',0
error_text  db 'Brak pliku stars.dat',13,10,'$'
Start:
        call    load_star
        mov     ax,0013h
        int     10h
        call    narysuj
        mov     ah,08h
        int     21h
        mov     ax,0003h
        int     10h
QUIT:
        mov     ax,4c01h
        int     21h

load_star       PROC
        mov     ah,3dh
        push    cs
        pop     ds
        lea     dx,file_name
        mov     al,0
        int     21h
        jc      ERROR
        push    ax
        mov     bx,ax
        mov     ah,3fh
        push    cs
        pop     ds
        lea     dx,star_bufor
        mov     cx,2400
        int     21h
;odczytane dane
        pop     bx
        mov     ah,3eh
        int     21h
        ret

ERROR:
        mov     ax,0003h
        int     10h
        push    cs
        pop     ds
        lea     dx,error_text
        mov     ah,09h
        int     21h
        jmp     QUIT
ENDP

narysuj         PROC
        push    cs
        pop     ds
        lea     si,star_bufor
        mov     dx,0a000h
        mov     es,dx
        xor     di,di
        mov     cx,400
        mov     dl,0
czytaj:
        lodsw
        add     di,ax
        mov     ax,15
        stosw
        xor     di,di
        lodsw
        add     di,ax
        mov     ax,8
        stosw
        xor     di,di
        lodsw
        add     di,ax
        mov     ax,7
        stosw
        xor     di,di
loop    czytaj
        ret
ENDP

include _linia.asm

CODE ENDS
END Start