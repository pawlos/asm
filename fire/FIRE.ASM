JUMPS
ASSUME CS:CODE
include d:\macro.zbr
CODE SEGMENT
     org 100h
Start:
      cld
      mov ax,0013h          ;ustaw tryb ekranu
      int 10h
      call ustaw_palete
      xor ax,ax
      push cs
      pop  es
      lea di,bufor
      mov cx,32000
      rep stosw
main:
      push cs
      pop  es
      lea di,bufor          ;/
      add di,63040
      mov al,0            ; >wstaw zaczatek "ognia"
      mov cx,320
ustaw2:
      push cx
      call losuj

      mov es:[di],al
      mov es:[di+320],al
      mov es:[di+640],al
      inc di
      pop cx
loop  ustaw2
      push cs
      pop  ds
      lea di,bufor
      add di,321
      mov cx,197*320
petla:
      call ogien
      mov dS:[di-320],al
      inc di
loop  petla
      synch
      call przepisz
      mov ah,01h
      int 16h
      jz main
      mov cx,320
      mov ax,0003h
      int 10h
      mov ax,4c01h
      int 21h

ogien proc
      xor ax,ax
      mov al,ds:[di+640]
      mov dx,ax
      mov al,ds:[di+320]
      add dx,ax
      mov al,ds:[di+321]
      add dx,ax
      mov al,ds:[di+319]
      add dx,ax
      shr dx,2
      mov al,dl
omin_dec:
       cmp al,0
       je  rys
       dec al
rys:
      ret
endp
przepisz proc
      push cs
      pop  ds
      mov ax,0a000h
      mov es,ax
      xor di,di
      lea si,bufor
      mov cx,32000
      rep movsw
      ret
endp

ustaw_palete proc
;--------------------
      xor bl,bl ;nr koloru;
      xor bh,bh ;jasnosc
      mov cx,64
ustaw_czer:
      mov dx,3c8h
      mov al,bl
      out dx,al
      inc dx
      mov al,bh
      out dx,al         ;skladowa czerwona
      xor al,al
      out dx,al         ;\
      out dx,al         ; zero
      inc bl
      inc bh
loop ustaw_czer
      mov bl,64
      xor bh,bh
      mov cx,64
ustaw_green:
      mov dx,3c8h
      mov al,bl
      out dx,al
      inc dx
      mov al,63
      out dx,al ;skladowa czerwona
      mov al,bh ;skladowa zielona
      out dx,al
      xor al,al
      out dx,al ;skladowa niebieska
      inc bl
      inc bh
loop ustaw_green
      mov cx,63
      mov bl,128
      xor bh,bh
ustaw_nieb:
      mov dx,3c8h
      mov al,bl
      out dx,al
      inc dx
      mov al,63
      out dx,al ;skladowa czerwona
      mov al,63 ;skladowa zielona
      out dx,al
      mov al,bh
      out dx,al ;skladowa niebieska
      inc bl
      inc bh
loop ustaw_nieb
      mov cx,62
      mov bl,192
ustaw_b:
      mov dx,3c8h
      mov al,bl
      out dx,al
      inc dx
      mov al,63
      out dx,al
      out dx,al
      out dx,al
      inc bl
loop ustaw_b
     ret
endp
losuj proc
      mov ax,cs:[rand]
      mov dx,31413
      mul dx
      add ax,13849
      mov cs:[rand],ax
      mov dx,255
      mul dx
      mov ax,dx
      ret
endp
rand dw 12345
bufor db 64000 dup(?)
CODE ENDS
END Start