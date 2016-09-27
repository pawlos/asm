;macro wypisuje lancuch znakow przy uzyciu standarodwej funkcji 09h
pisz_21h macro tekst
       mov ah,09h
       push cs
       pop  ds
       lea dx,tekst
       int 21h
endm
synch   MACRO
        LOCAL   czek01,czek02
        push    dx
        push    ax
        mov     dx,3dah
czek01:
        in      al,dx
        test    al,8
        jnz     czek01
czek02:
        in      al,dx
        test    al,8
        jz      czek02
        pop     ax
        pop     dx
ENDM
_Abs    MACRO   co
        LOCAL   Mskok
        cmp     co,0
        jge     Mskok
        neg     co
        Mskok:
ENDM