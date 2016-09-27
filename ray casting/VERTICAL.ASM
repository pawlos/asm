vertical_line proc near
;wywoˆanie:
; es:di - ustawione na gdzie ma rysowa†
; x1,y1,y2,color
    push di
    mov ax,cs:[y1]
    mov cx,cs:[y2]
    cmp cx,ax
    jae @@dalej
    xchg ax,cx
@@dalej:
    sub  cx,ax
    cmp  cx,0
    jne  @@dalej02
    call putpixel
    pop  di
    jmp  @@koniec
@@dalej02:
    mov  bx,ax
    sal  bx,8
    sal  ax,6
    add  bx,ax
    add  di,bx
    add  di,cs:[x1]
    mov  al,cs:[color]
@@rysuj_linie:
    stosb
    add  di,319
loop @@rysuj_linie
    pop di
@@koniec:
    ret

putpixel:
      push di
      mov ax,cs:[y1]
      mov bx,ax
      shl bx,8
      shl ax,6
      add bx,ax
      add bx,cs:[x1]
      add di,bx
      mov al,cs:[color]
      stosb
      pop di
      ret
x1    dw ?
y1    dw ?
y2    dw ?
color db ?
vertical_line endp