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
petla:
        call    narysuj
        call    Opoz
        mov     ah,01h
        int     16h
        jz      petla
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
        mov     cx,600
        mov     dl,0
czytaj:
        mov     bx,ds:[si]
        mov     es:[bx],dl
        mov     byte ptr es:[bx] [3],15
        add     word ptr ds:[si],3
        add     si,2

        mov     bx,ds:[si]
        mov     es:[bx],dl
        mov     byte ptr  es:[bx] [2],7
        add     word ptr ds:[si],2
        add     si,2

loop    czytaj
        ret
ENDP

Opoz    PROC
        mov     dx,3dah
wai:
        in      al,dx
        test    al,8
        je      wai
        ret
ENDP



CODE ENDS
END Start