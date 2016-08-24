.386c
ASSUME cs:CODE
include d:\macro.zbr
CODE SEGMENT use16
     org 100h
Start:
       jmp      poczatek
       A      dd 0.0347   ;kat w radianach ÷1ø
       Xr     dw 0
       Yr     dw 0
       Xo     dd 0e0
       Yo     dd 0e0
       Xoo    dd 160e0
       Yoo    dd 100e0
       X      dd 90e0
       Y      dd 100e0
       cos    dd 0e0
       sin    dd 0e0
       dex    equ 160
       dey    equ 100
poczatek:
       mov  ax,0013h
       int  10h
       finit                     ;start koprocesora
       mov   ax,0a000h
       mov   es,ax
       xor   di,di
       fld   A                  ;
       fsincos                  ;
       fstp   cos               ;
       fstp   sin               ;
petla:
       in       al,60h
       cmp      al,1
       je       QUIT
       synch
       call  clear
       call  obroc              ;narysuj okrag
       call  narysuj
jmp   petla
QUIT:
      mov       ax,0003h
      int       10h
      ret
narysuj PROC
       mov   ax,Yr
       mov   bx,Yr
       shl   ax,8
       shl   bx,6
       add   ax,bx
       mov   bx,Xr
       add   ax,bx
       mov   di,ax
       mov   al,64h
       mov   es:[di],al
ret
ENDP
clear PROC
       mov      ax,Yr
       mov      bx,Yr
       shl      ax,8
       shl      bx,6
       add      ax,bx
       add      ax,Xr
       mov      di,ax
       xor      al,al
       mov      es:[di],al
ret
ENDP
obroc PROC
       fld   Y                 ;zaladuj Y
       fsub  Yoo                ;*
       FMUL sin                 ;pomnoz razy sinus
       FLD X                   ;zaladuj X
       fsub Xoo                 ;*
       FMUL cos                 ;pomnoz razy cos
       FSub st(0),st(1)         ;odejmij od siebie
       fadd Xoo                 ;*
       fst  Xo                  ;zaladuj do Xo
       frndint                  ;zaokraglij
       Fistp Xr                 ;i do Xr
       Fld Y                   ;zaladuj Y
       fsub Yoo                 ;*
       fmul cos                 ;pomnoz razy cos
       fld X                   ;zaladuj X
       fsub Xoo                 ;*
       fmul sin                 ;pomoz razy sin
       fadd st(0),st(1)         ;dodaj do siebie
       fadd Yoo                 ;*
       fst Yo
       frndint
       fistp Yr
       fld   Xo
       fstp  X
       fld   Yo
       fstp  Y
       ffree  st(0)
       ffree  st(1)
       ret                      ;powrot do glownago programu
ENDP
CODE ENDS
END Start