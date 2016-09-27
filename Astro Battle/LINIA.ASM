wsk1    dw 0
wsk2    dw 0
podpr   dw 0
x1      dw 0
y1      dw 0
x2      dw 0
y2      dw 0
;x1,y1 - wspolrzedne pierwszego punktu
;x2,y2 - wspolrzedne drugiego punktu
;es - segment, w ktorym ma byc
;narysowana linia
;color - kolor
Pixel   MACRO
        xchg    ah,al
        add     bx,ax
        shr     ax,2
        add     bx,ax
        ENDM
Linia_prosta   PROC
        push    si
        push    di
        mov     si,320
        mov     cx,x2
        sub     cx,x1
        jz      VL
        jns     pdr1
        neg     cx
        mov     bx,x2
        xchg    bx,x1
        mov     x2,bx
        mov     bx,y2
        xchg    bx,y1
        mov     y2,bx
pdr1:
        mov     bx,y2
        sub     bx,y1
        jz      HL
        jns     pdr3
        neg     bx
        neg     si
pdr3:
        push    si
        mov     podpr,offset LL1
        cmp     bx,cx
        jle     pdr4
        mov     podpr,offset HL1
        xchg    bx,cx
pdr4:
        shl     bx,1
        mov     wsk1,bx
        sub     bx,cx
        mov     si,bx
        sub     bx,cx
        mov     wsk2,bx
        push    cx
        mov     ax,y1
        mov     bx,x1
        Pixel
        mov     di,bx
        pop     cx
        inc     cx
        pop     bx
        jmp     podpr
VL:
        mov     ax,y1
        mov     bx,y2
        mov     cx,bx
        sub     cx,ax
        jge     pdr31
        neg     cx
        mov     ax,bx
pdr31:
        inc     cx
        mov     bx,x1
        push    cx
        Pixel
        pop     cx
        mov     di,bx
        dec     si
        mov     al,color
pdr32:
        stosb
        add     di,si
        loop    pdr32
        jmp     Exit
HL:
        push    cx
        mov     ax,y1
        mov     bx,x1
        Pixel
        mov     di,bx
        pop     cx
        inc     cx
        mov     al,color
        rep     stosb
        jmp     Exit
LL1:
        mov     al,color
pdr11:
        stosb
        or      si,si
        jns     pdr12
        add     si,wsk1
        loop    pdr11
        jmp     Exit
pdr12:
        add     si,wsk2
        add     di,bx
        loop    pdr11
        jmp     Exit
HL1:
        mov     al,color
pdr21:
        stosb
        add     di,bx
pdr22:
        or      si,si
        jns     pdr23
        add     si,wsk1
        dec     di
        loop    pdr21
        jmp     Exit
pdr23:
        add     si,wsk2
        loop    pdr21
Exit:
        pop     di
        pop     si
        ret
Linia_prosta   ENDP
