petla:

        call    load_star
        call    narysuj
	call	_linia
	call	start3
        mov     ah,08h
        int     21h
	ret

load_star       PROC
        mov     ah,3dh
        push    cs
        pop     ds
        lea     dx,file_name
        mov     al,0
        int     21h
        jc      EROR
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

EROR:
        mov     ax,0003h
        int     10h
        push    cs
        pop     ds
        lea     dx,error_txt
        mov     ah,09h
        int     21h
        jmp     wyjscie
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
	add	di,ax
	mov	ax,15
	stosw
	xor	di,di
	lodsw
	add	di,ax
	mov	ax,8
	stosw
	xor	di,di
	lodsw
	add	di,ax
	mov	ax,7
	stosw
	xor	di,di
loop    czytaj
        ret
ENDP

include _linia.asm

include writetxt.asm