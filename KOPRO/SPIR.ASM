.386
JUMPS
ASSUME cs:CODE
include d:\macro.zbr
CODE SEGMENT use16
     org 100h
Start:
       Jmp Inst
       col  db 20
       a    dd 60e0
       aa   dd 60e0
       dab  dd 1e0
       alp  dd 0e0
       dalp dd 0.0070
       X    dw 0
       Y    dw 0
       da   dd 0.02
Inst:
      finit
      mov   ax,0013h
      int   10h
      mov   ax,0a000h
      mov   es,ax
      xor   di,di
;      mov   cx,35
;petla:
;      push  cx
      mov   cx,2300
rysuj:
      push cx
      fld   alp
      fcos
      fmul  a
      frndint
      fistp X
      fld   alp
      fsin
      fmul  a
      frndint
      Fistp Y
      synch
      mov   ax,Y
      add   ax,100
      mov   bx,ax
      shl   ax,8
      shl   bx,6
      add   ax,bx
      add   ax,X
      add   ax,160
      mov   di,ax
      mov   al,44
      mov   es:[di],al
      fld   alp
      fadd  dalp
      fstp  alp
      fld   a
      fsub  da
      fstp  a
      pop   cx
loop  rysuj
;      fldz
;      fstp  alp
;      fld   aa
;      fsub  dab
;      fst  a
;      fstp aa
;      pop   cx
;      inc   col
;loop  petla
QUIT:
      mov  ah,08h
      int  21h
      mov  ax,0003h
      int  10h
      ret
ENDP
CODE ENDS
END Start