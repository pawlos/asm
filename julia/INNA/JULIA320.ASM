STOSIK SEGMENT STACK 'STACK'
 db 200h dup(?)
STOSIK ENDS
.386
ASSUME cs:CODE,ds:CODE
       include d:\macro.zbr
CODE SEGMENT use16
Start:
      mov ax,0013h
      int 10h
      call pal
_main:
      call julia
      push ds
      call buf2scr
      pop ds
      sub dword ptr ds:[cy],20
      add dword ptr ds:[_cx],20
      mov ah,01h
      int 16h
      jz _main
      mov ax,0003h
      int 10h
      mov ah,4ch
      int 21h

julia proc
;rysuje(?)zbior Julii
      mov edx,-1920    ;for i=-1920
      xor eax,eax
      mov word ptr ds:[px],ax    ;px=0
petla:
      mov dword ptr ds:[i],edx
      push edx
      mov edx,-2000      ;for j=-2000
      xor eax,eax
      mov word ptr ds:[py],ax     ;py=0
petla2:
      mov dword ptr ds:[y],edx
      push edx
      xor eax,eax
      mov dword ptr ds:[c],eax     ;c=0
      mov eax,dword ptr ds:[i]     ;\
      mov dword ptr ds:[x],eax     ; x=i;
      imul eax            ; x*x
      mov dword ptr ds:[x2],eax   ; x2=x*x
      mov eax,dword ptr ds:[y]     ;\
;      mov dword ptr ds:[y],eax     ; y=j;
      imul eax            ; y*y
      mov dword ptr ds:[y2],eax   ; y2=y*y
petla3:
      mov eax,dword ptr ds:[x2]
      add eax,dword ptr ds:[y2]   ;x2+y2
      cmp eax,4000000   ;x2+y2<4000000
      jl  ok_01
      jmp end_julia
ok_01:
      mov eax,dword ptr ds:[c]
      cmp eax,31
      jb ok_2
      jmp end_julia
ok_2:
      inc dword ptr ds:[c]
      ;x=x*(x2-3*y2)+cx
      mov eax,dword ptr ds:[x2]
      mov ebx,dword ptr ds:[y2] ;\
      sal ebx,1                 ; >3*y2
      add ebx,dword ptr ds:[y2] ;/
      sub eax,ebx               ;x2-3*y2
      mov ebx,dword ptr ds:[x]
      imul ebx
      sar eax,19
      add eax,dword ptr dS:[_cx]
      mov dword ptr ds:[x],eax
      ;y=y*(3x2-y2)+cy
      mov eax,dword ptr ds:[x2]
      sal eax,1
      add eax,dword ptr ds:[x2]
      mov ebx,dword ptr ds:[y2]
      sub eax,ebx          ;3*x2-y2
      mov ebx,dword ptr dS:[y]
      imul ebx
      sar eax,19
      add eax,dword ptr ds:[cy]
      mov dword ptr ds:[y],eax
      imul eax
      mov dword ptr ds:[y2],eax
      mov eax,dword ptr ds:[x]
      imul eax
      mov dword ptr ds:[x2],eax
jmp   petla3
end_julia:
      call putpixel
      pop edx
      add edx,20
      inc word ptr ds:[py]
      cmp edx,2000
      jng petla2
      pop edx
      add edx,12
      inc word ptr ds:[px]
      cmp edx,1920
      jng petla
      ret
ENDP



putpixel proc
      mov ax,seg DATA
      mov es,ax
      xor edi,edi
      mov ax,[py]
      mov di,ax
      shl di,8
      shl ax,6
      add di,ax
      add di,[px]
      mov eax,[c]
      shl eax,3
      stosb
      ret
ENDP
pal proc
    mov cx,64
    mov bl,0
    xor ah,ah
ustawiaj_01:
    push bx     ;bl-i
    mov ah,bl   ;ah-B i
    mov bh,ah
    shr bh,1  ;R i/2
    shl bl,1  ;2*i
    set_pal bl,bh,0,ah
    inc bl
    set_pal bl,bh,0,ah
    pop bx
    inc bl
loop ustawiaj_01
    mov cx,64
    mov bl,64
ustawiaj_02:
    push bx
    mov ah,bl   ;G
    mov bh,ah
    shr bh,2
    add bh,32   ;al-R
    shl bl,1
    set_pal bl,bh,ah,63
    inc bl
    set_pal bl,bh,ah,63
    pop bx
    inc bl
loop ustawiaj_02
    ret
ENDP

buf2scr proc
;ds:si - es:di
       mov ax,seg DATA
       mov ds,ax
       xor esi,esi
       mov ax,0a000h
       mov es,ax
       xor edi,edi
       mov cx,16000
       rep movsd
       ret
ENDP
       px dw ?
       py dw ?
       i  dd ?
       j  dd ?
       c  dd ?
       _cx dd ?
       cy dd ?
       x  dd ?
       y  dd ?
       x2 dd ?
       y2 dd ?
CODE ENDS
DATA SEGMENT
      bufor db 64000 dup (?)
DATA ENDS
END Start