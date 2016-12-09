;gˆ¢wny plik projektu
.386c
.model huge
LOCALS
JUMPS
STOSIK SEGMENT STACK 'STACK'
       db 300h dup(?)
STOSIK ENDS
ASSUME cs:CODE
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
CODE SEGMENT use16      ;deklaracja segmentu kodu 16 bitowego
            include data.asm        ;dodaj dane programu
     Start:
            include code.asm    ;dodaj gˆ¢wny kod programu

;dodatkowe procedury
include ekran.asm
include loadfile.asm
include new9h.asm
include bufor.asm
include palete.asm
include level.asm
include tekst.asm
include reakcja.asm
include ray_cast.asm
include puttext.asm
CODE ENDS
TABLICE SEGMENT use16
        include tangens.dat     ;tg i inv_tan
        include sincos.dat      ;sin inv_sin cos i inv_cos
TABLICE ENDS
SKALUJ SEGMENT use16
        include skala.dat       ;skala dla scian
SKALUJ ENDS
FONT SEGMENT use16
      font_buf db 576 dup(?)
FONT ENDS
PALETA SEGMENT use16
       pal db 768 dup(?)
PALETA ENDS
ACTUAL_MAP SEGMENT use16 ;segment mapy
     mapka db 64*64 dup(?)        ;aktualna mapka -poziom gry(1--5)
     tytul_mapy db 20  dup(?)          ;tytuˆ aktualnej mapy
     x     dd ?                   ;\
     y     dd ?                   ; wsp. startu
     view_angle dd ?
ACTUAL_MAP ENDS
MAPY SEGMENT use16      ;
     wszystkie db 64000 dup(?);na wszystkie mapy
MAPY ENDS
TEXTURE SEGMENT use16 ;?32 bit
       pics db 49152 dup (?)
TEXTURE ENDS
BUFOR SEGMENT use16   ;definicja bufora dla podw¢jnego buforowania
      ekran db 64000 dup(?)
BUFOR ENDS
END Start