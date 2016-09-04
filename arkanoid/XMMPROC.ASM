; Mega Driver XMM by Dan of SS
; xmminit - sprawdzenie i pobranie adresu drivera
; xmmrun  - rezerwacja pamieci umb ax:ilosc kilobajtow do rezerwacji
;         return - ax : uchwyt
; xmmcopy - move of blok umb    eax:ilosc przesylanych bajtow
;                               bx:uchwyt bloku
;                               ecx:offset w umb
;                               dx:1=cov>xms
;                                  2=cov<xms
;                               ds:si:bufor
; xmmend - wylaczenie bloku     ax:uchwyt
;
;       dla dx:3=xms><xms
;               eax:ilosc przesylanych bajtow
;               ebx:offset sours
;               ecx:offset destynation
;               ds:uchwyt sours
;               es:uchwyt destynation


xmminit proc    near
        mov     ax,4300h
        int     2fh
        cmp     al,80h
        je      xms1
        pisz_21h  xmserr1
        mov    ah,4ch
        int    21h
xms1:
        mov     ax,4310h
        int     2fh
        mov     [xmmsegm+0],bx
        mov     [xmmsegm+2],es
; wylaczenie gate20
        mov     ax,0400h
        call    dword ptr [xmmsegm]
        cmp     ax,1
        je      xmminitend
        push    bx
        pisz_21h  xmserr5
        mov       ah,4ch
        int       21h
xmminitend:
        ret
xmminit endp

xmmrun  proc    near
        mov     [xmmhelp],ax
        mov     ax,0800h
        call    dword ptr [xmmsegm]
        cmp     ax,1
        ja      xms2
        pisz_21h  xmserr2
        mov ah,4ch
        int 21h
xms2:
        cmp     ax,[xmmhelp]
        jae     xms3
        pisz_21h  xmserr2
        mov       ah,4ch
        int       21h
xms3:
        mov     ax,0900h
        mov     dx,[xmmhelp]
        call    dword ptr [xmmsegm]
        cmp     ax,1
        je      xms4
        push    bx
        pisz_21h  xmserr2
        pop     bx
        mov     ah,4ch
        int     21h
xms4:
        mov     ax,dx
        ret
xmmrun  endp

xmmcopy proc    near
        cmp     dx,3
        je      xmmcopy_3
        mov     dword ptr [xmmtab],eax
        cmp     dx,2
        je      xmmcopy_2
        xor     ax,ax
        mov     [xmmtab+4],ax
        mov     [xmmtab+6],si
        mov     [xmmtab+8],ds
        mov     [xmmtab+10],bx
        mov     dword ptr [xmmtab+12],ecx
        ; mov     [xmmtab+14],ax
xmmcopy_1:
        push  cs
        pop   ds
        lea   si,xmmtab
        mov     ax,0b00h
        call    dword ptr [xmmsegm]
        cmp     ax,1
        je      xmmcopyend
        mov     ax,0003h
        int     10h
        pisz_21h  xmserr3
        mov     ah,4ch
        int     21h
xmmcopyend:
        ret
xmmcopy_2:
        xor     ax,ax
        mov     [xmmtab+4],bx

        mov     dword ptr [xmmtab+6],ecx

        ;mov     [xmmtab+6],dword ptr ecx

        ; mov     [xmmtab+8],ax
        mov     [xmmtab+10],ax
        mov     [xmmtab+12],si
        mov     [xmmtab+14],ds
        jmp     xmmcopy_1

xmmcopy_3:
        mov     dword ptr [xmmtab+00],eax
        mov     dword ptr [xmmtab+06],ebx
        mov     dword ptr [xmmtab+12],ecx
        mov     [xmmtab+4],ds
        mov     [xmmtab+10],es
        jmp     xmmcopy_1

xmmcopy endp

xmmend  proc    near
        mov     dx,ax
        mov     ax,0a00h
        call    dword ptr [xmmsegm]
        cmp     bl,0
        je      xmmendend
        mov     ax,0003h
        int     10h
        pisz_21h  xmserr4
        mov     ah,4ch
        int     21h
xmmendend:
        ret
xmmend  endp