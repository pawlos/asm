.386c
;.model huge
JUMPS
LOCALS
STOSIK SEGMENT STACK 'STACK'
       db 100h dup(?)
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
_abs32  MACRO co
          LOCAL Mskok
          cmp   co,0
          jge   Mskok
          neg   co
          cdq
          Mskok:
ENDM
CODE SEGMENT use16
             map_file  db 'mapa.dat',0
             texture_file db 'textury.dat',0
             drzwi_file   db 'drzwi.bmp',0
             file_size dw 286
             ;pozycja gracza
             x         dd 64+32
             y         dd 14*64+32
             ;stale katowe
             ANGLE_0    dd 0
             ANGLE_1    dd 5
             ANGLE_2    dd 10
             ANGLE_4    dd 20
             ANGLE_5    dd 25
             ANGLE_6    dd 30
             ANGLE_15   dd 80
             ANGLE_30   dd 160
             ANGLE_45   dd 240
             ANGLE_60   dd 320
             ANGLE_90   dd 480
             ANGLE_135  dd 720
             ANGLE_180  dd 960
             ANGLE_225  dd 1200
             ANGLE_270  dd 1440
             ANGLE_315  dd 1680
             ANGLE_360  dd 1920
             view_angle  dd 11h         ;kat patrzenia (60ø)
             CELL_X_SIZE dd 64
             CELL_Y_SIZE dd 64


Start:
           call load_map        ;mapa odczytana
           call wczytaj_texture ;odczytaj texture
           call load_drzwi      ;wczytuje texture drzwi
           call ustaw_nowe_int9h
           call przygotuj_palete
           mov ax,0013h
           int 10h
           call ustaw_palete
           mov ax,seg TABLICE
           mov ds,ax
           mov ax,seg MAPA
           mov fs,ax
           mov ax,seg BUFOR
           mov es,ax
           mov ax,seg SKALUJ
           mov gs,ax
           xor di,di
_main:
           cmp cs:[key_tab+01h],01
           je   quit
           call zareaguj
           call clear_bufor
           call ray_cast
           synch
           call przepisz
           jmp  _main
quit:
           mov ax,0003h
           int 10h
           call usun_nowe_int9h
           mov ax,4c00h
           int 21h

;--------------------------

;procedura rzucania promieni
include load_bmp.asm
include load_map.asm
include ray_cast.asm
include vertical.asm  ;rysuje linie pionow¥
include bufor.asm     ;zwiazane z buforem procedury
include new9h.asm       ;zwiazane z int9h
include reakcja.asm     ;reakca na klawisze
paleta db 1024 dup(?)
CODE ENDS
TABLICE SEGMENT use16
        include tangens.dat
        include sincos.dat
TABLICE ENDS
SKALUJ SEGMENT use16
      include skala.dat
SKALUJ ENDS
DRZWI SEGMENT use16
      drzwi_buf db 64*64 dup(?)
DRZWI ENDS
TEXTURE SEGMENT use16
        texture_bufor db 256*192 dup (?);1440 dup (?)
TEXTURE ENDS
MAPA SEGMENT use16
 map   db 286 dup(?)
 map_bufor db 500 dup(?)
MAPA ENDS
BUFOR SEGMENT use16
      ekran db 64000 dup(?)
BUFOR ENDS
END start