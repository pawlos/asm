;procedury zwi¥zane z palet¥
set_pal proc near
        mov ax,seg PALETA
        mov ds,ax
        lea esi,pal
        xor bh,bh   ;index koloru
        mov cx,255
@@ustaw_kolory:
        mov dx,3c8h
        mov al,bh
        out dx,al
        inc dx
        mov al,ds:[esi] ;RED
        out dx,al
        mov al,ds:[esi+1] ;GREEN
        out dx,al
        mov al,ds:[esi+2] ;BLUE
        out dx,al
        inc bh
        add esi,3
        dec cx
        jns @@ustaw_kolory
        ret
set_pal endp