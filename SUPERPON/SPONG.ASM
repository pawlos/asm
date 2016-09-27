SSTACK SEGMENT STACK
db 100 dup (0)
SSTACK ENDS
;--------------------------------------------
ASSUME cs:CODE,ds:DANE,ss:SSTACK
JUMPS
CODE SEGMENT

;---------------------- DANE PROGRAMU --------------------------------
tekst   db      'Super Pong$'   ;tytul gierki
txt_text db     'Super Pong v. 1.5',13,10
         db     '       by LEX Corp.',13,10,'$'
X_ramki dw      100             ;\
Y_ramki dw      90              ; >dane dla ramki przy tytule
kolor   equ     002             ;/
X_paletki_lewej      dw  ?
X_paletki_prawej     dw  ?
pozycja_Y            equ  195
X_pileczki           dw  ?
Y_pileczki           dw  ?
Przesuniecie_X       dw  1
Przesuniecie_Y       dw  1
Rozmiar              equ  5
Wysokosc_paletki     equ  5
Dlugosc_paletki      equ  24
Wektor_do_starego_przerwania dd ?
A           equ 30
S           equ 31
K           equ 37
L           equ 38
Escape      equ  1
A_wciskany      db ?
S_wciskany      db ?
K_wciskany      db ?
L_wciskany      db ?
Escape_wciskany db ?
Punkty_lewego   dw 1
Punkty_prawego  dw 1
Wysokosc_kreski dw 14
star_bufor      dw 1200 dup(?)
file_name       db 'spong.dat',0
error_txt       db 'Brak pliku spong.dat',13,10,'$'
txt             db 'SUPER PONG',0
X       dw 120
Y       dw 92
c       db 65
;---------------------------------------------------------------------------

Start:
        mov     ax,0013h
        int     10h
        call    petla
        mov     ax,0013h        ;wejscie w tryb
        int     10h             ; 320x200x256c
        call    ustaw_zmienne
        call    tytul           ;wypisz tytul
        call    rama            ;narysuj ramke wokol napisu "VOLEYBALL"
        call    start2
        call    ustaw_nowe_przerwanie_klawiatury
        call    czysc_ekran
;-----------------------------------------------------------------------
glowna_petla:
        cmp     Escape_wciskany,1
        jz      QUIT
        call    zareaguj_w_zaleznosci_od_klawisza
        call    porusz_pilka
        call    czysc_bufor
        call    narysuj_boisko
        mov     cx,Punkty_prawego
        lea     si,bufor
        mov     si,802
        call    narysuj_punkty
        lea     si,bufor
        mov     cx,Punkty_lewego
        mov     si,642
        call    narysuj_punkty
        call    narysuj_pilka
        call    oblicz_nowa_pozycje_paletek
        call    poczekaj_na_przerwanie_pionowe
        call    bufor_to_screen
        jmp     glowna_petla
;-------------------------------------------------------------------------
QUIT:
        mov     ax,0003h        ;wejscie w tryb
        int     10h             ; tekstowy
NO_GRAF:
        push    cs              ;\
        pop     ds              ; \
        lea     dx,txt_text     ;  >wypisanie tekstu o wersji programu
        mov     ah,09h          ; /
        int     21h             ;/
        call    przywroc_stare_przerwanie_klawiatury
wyjscie:
        mov     ax,4c01h        ;wyjscie do ukochanego DOS'a
        int     21h             ;




;PROCEDURY PROGRAMU
;---------------------------------------------------------------------
tytul PROC
        mov     ah,02h  ;funkcja ustawiajaca kursor
        mov     bx,0
        mov     dh,10   ;wiersz
        mov     dl,15   ;kolumna
        int     10h     ;ustaw
        push    cs              ;\
        pop     ds              ; \
        lea     dx,tekst        ;  >wypisz tytul gierki
        mov     ah,09h          ; /
        int     21h             ;/
        ret                     ;powrot
tytul ENDP

;---------------------------------------------------------------------

rama PROC
        mov     cx,118          ;ustaw licznik petli=dlugosc lini
rysuj:
        push    cx              ;odloz licznik petli na stos
        mov     al,kolor        ;rysujemy na zielono
        push    ax              ;odluz kolor
        call    ustaw_na_ekran
        mov     di,0            ;od poczatku ekranu
        mov     ax,320          ;\
        mul     Y_ramki         ;  >policz przesuniecie punktu od pocz. ekranu
        add     ax,X_ramki      ; /
        add     di,ax           ;/
        pop     ax              ;odtworz kolor
        mov     byte ptr es:[di],al     ;narysuj punkt w obliczonym miejscu
                                        ;kolorem=al
        sub     di,4160         ;odejmij 4160 od di
        mov     byte ptr es:[di],al     ;narysuj punkt gornej linii
        add     di,4160         ;dodaj 4160 od di aby byc znow na gornej lini
        inc     X_ramki         ;zwieksz wsp. X ramki
        pop     cx              ;pobierz licznik
loop    rysuj                   ;skacz ...
        ret                     ;powrot
rama ENDP

;---------------------------------------------------------------------

czysc_ekran     PROC
        push    es
        call    ustaw_na_ekran
        mov     bx,0000h        ;czuscimy od poczatku
zeruj:
        mov     byte ptr es:[bx],00h    ;czyscimy zerem
        inc     bx                      ;zwieksz komorke
        cmp     bx,64000                ;jesli rowne to wyjdz
        jnz     zeruj
        pop     es
        ret
czysc_ekran ENDP

;---------------------------------------------------------------------

narysuj_boisko  PROC
        mov     dx,DANE
        mov     ds,dx
        lea     si,bufor
        xor     si,si
        mov     al,10                   ;rysujemy na zielono
        mov     si,6400                 ;
        mov     cx,320                  ;cala linie
rysuj_punkt:
        mov     ds:[si],al     ;postaw punkt
        inc     si
loop    rysuj_punkt
        mov     cx,320                  ;teraz dolna linie
        lea     si,bufor
        mov     si,63680
rysuj_punkt2:
        mov     ds:[si],al     ;postaw punkt
        inc     si
loop    rysuj_punkt2
        xor     si,si                   ;\
        mov     cx,180                  ; \
        mov     si,6400                 ;  \
rysuj_linie_pion:                       ;   \te linie sluza do malowania bocznych linii
        mov     ds:[si],al         ;   /
        add     si,319                  ;  /
        mov     ds:[si],al         ; /
        add     si,1                    ;/
loop    rysuj_linie_pion
        lea     si,bufor
        add     si,6721
        mov     al,122
        mov     cx,178
l2:
        push    cx
        mov     cx,318
l1:
        mov     ds:[si],al
        inc     si
loop    l1
        pop     cx
        sub     si,318
        add     si,320
loop    l2

;teraz namaluje siatke
        lea     si,bufor
        mov     si,35359                ;\
        mov     al,11                   ; \
        mov     cx,90                   ;  \
rysuj_siatke:                           ;   \
        mov     ds:[si],al              ;    \
        inc     si                      ;     \
        mov     ds:[si],al              ;      \
        inc     si                      ;       \
        mov     ds:[si],al              ;         \
        sub     si,2                    ;           \rysuje siatke
        add     si,320                  ;          /
loop    rysuj_siatke                    ;        /
        ret                             ;/
ENDP

;---------------------------------------------------------------------


oblicz_nowa_pozycje_paletek PROC        ;\
        mov ax,pozycja_Y                ; \
        mov cx,320                      ;  \
        mul cx                          ;   \
        add ax,X_paletki_lewej          ;    \
        mov  si,ax                       ;     \
        call  narysuj_paletke           ;      \
        mov ax,pozycja_Y                ;       >oblicza nowa pozycje paletek
        mov cx,320                      ;     /
        mul cx                          ;    /
        add ax,X_paletki_prawej         ;   /
        mov     si,ax                       ;  /
        call narysuj_paletke            ; /
        ret                             ;/
ENDP

;---------------------------------------------------------------------

narysuj_paletke PROC                    ;\
        mov     cx,Wysokosc_paletki     ;   \
rysuj_paletke:                          ;    \
        push cx                         ;     \
        mov cx,Dlugosc_paletki          ;      \
rysuj_linie_paletki:                    ;        \rysuje paletki w nowych wsp.
        mov ds:bufor[si],01             ;       /
        inc si                          ;      /
loop    rysuj_linie_paletki             ;     /
        pop cx                          ;    /
        sub si,Dlugosc_paletki          ;   /
        add si,320                      ;  /
loop    rysuj_paletke                   ; /
        ret                             ;/
        ENDP

;---------------------------------------------------------------------

ustaw_nowe_przerwanie_klawiatury PROC
          push  ds
          mov   ax,3509h
          int   21h
          mov   word ptr cs:Wektor_do_starego_przerwania,bx
          mov   word ptr cs:Wektor_do_starego_przerwania+2,es
          pop   es
          mov   dx,offset  nowe_przerwanie_klawiatury
          mov   ax,2509h
          int   21h
          ret
ENDP

;---------------------------------------------------------------------

przywroc_stare_przerwanie_klawiatury PROC
        push ds
        mov  dx,word ptr cs:Wektor_do_starego_przerwania
        mov  bx,word ptr cs:Wektor_do_starego_przerwania+2
        mov  ds,bx
        mov  ax,2509h
        int  21h
        pop  ds
        ret
ENDP

;---------------------------------------------------------------------

nowe_przerwanie_klawiatury PROC
       pushf
       push  ax
       in    al,60h
       test  al,80h
       jnz   klawisz_zostal_puszczony
       cmp   al,A
       jnz   inny01
       mov   A_wciskany,1
       jmp   koniec_przerwania
inny01:cmp   al,S
       jnz   inny02
       mov   S_wciskany,1
       jmp   koniec_przerwania
inny02:cmp   al,K
       jnz   inny03
       mov   K_wciskany,1
       jmp   koniec_przerwania
inny03:cmp   al,L
       jnz   inny04
       mov   L_wciskany,1
       jmp   koniec_przerwania
inny04:cmp   al,Escape
       jnz   koniec_przerwania
       mov   Escape_wciskany,1
koniec_przerwania:
       in    al,61h
       mov   ah,al
       or    al,80h
       out   61h,al
       xchg  ah,al
       out   61h,al
       nop
       nop
       nop
       nop
       nop
       nop
       mov  al,20h
       out  20h,al
       pop  ax
       popf
       iret

klawisz_zostal_puszczony:
       and   al,01111111b
       cmp   al,A
       jnz   inny05
       mov   A_wciskany,0
       jmp   koniec_przerwania
inny05:cmp   al,S
       jnz   inny06
       mov   S_wciskany,0
       jmp   koniec_przerwania
inny06:cmp   al,K
       jnz   inny07
       mov   K_wciskany,0
       jmp   koniec_przerwania
inny07:cmp   al,L
       jnz   inny08
       mov   L_wciskany,0
       jmp   koniec_przerwania
inny08:cmp   al,Escape
       jnz   koniec_przerwania
       mov   Escape_wciskany,0
       jmp   koniec_przerwania

ENDP

;---------------------------------------------------------------------

zareaguj_w_zaleznosci_od_klawisza   PROC
       cmp    A_wciskany,1
       jnz    kolejny01
       mov    ax,X_paletki_lewej
       sub    ax,2
       jc     kolejny01
       mov    X_paletki_lewej,ax
kolejny01:
       cmp    S_wciskany,1
       jnz    kolejny02
       mov    ax,X_paletki_lewej
       add    ax,2
       cmp    ax,159-Dlugosc_paletki
       jae    kolejny02
       mov    X_paletki_lewej,ax
kolejny02:
       cmp    K_wciskany,1
       jnz    kolejny03
       mov    ax,X_paletki_prawej
       sub    ax,2
       cmp    ax,160
       jle    kolejny03
       mov    X_paletki_prawej,ax
kolejny03:
       cmp    L_wciskany,1
       jnz    koniec_reagowania
       mov    ax,X_paletki_prawej
       add    ax,2
       cmp    ax,321-Dlugosc_paletki
       jae    koniec_reagowania
       mov    X_paletki_prawej,ax
koniec_reagowania:
       ret

ENDP

;---------------------------------------------------------------------

poczekaj_na_przerwanie_pionowe    PROC
        mov dx,3dah
czekaj01:
       in       al,dx
       test     al,8
       jnz      czekaj01
czekaj02:
       in       al,dx
       test     al,8
       jz       czekaj02
       ret
ENDP


;======================
;DADAJ PLIK ZE SCROLEM
include simple.asm
;======================


;---------------------------------------------------------------------

ustaw_na_ekran  PROC
     mov  dx,0a000h
     mov  es,dx
     ret
ENDP

;---------------------------------------------------------------------

czysc_bufor  PROC
    mov      dx,DANE
    mov      es,dx
    mov      al,0
    lea      si,bufor
    mov      cx,65535
    cld
    rep stosb
    ret
ENDP

;---------------------------------------------------------------------

bufor_to_screen  PROC
    mov     dx,0a000h
    mov     es,dx
    xor     di,di
    mov     dx,DANE
    mov     ds,dx
    lea     si,bufor
    mov     cx,64000
    cld
    rep     movsb
    ret
ENDP

;---------------------------------------------------------------------

narysuj_pilka PROC
        mov     ax,Y_pileczki
        mov     cx,320
        mul     cx
        add     ax,X_pileczki
        mov     si,ax
        mov     cx,Rozmiar              ;   \
rysuj_p:                          ;    \
        push cx                         ;     \
        mov cx,Rozmiar                  ;      \
rysuj_l_paletki:                    ;        \rysuje paletki w nowych wsp.
        mov ds:bufor[si],14             ;       /
        inc si                          ;      /
loop    rysuj_l_paletki             ;     /
        pop cx                          ;    /
        sub si,Rozmiar          ;   /
        add si,320                      ;  /
loop    rysuj_p                   ; /
        ret                             ;/
        ENDP

;---------------------------------------------------------------------

porusz_pilka PROC
;najpierw czy ma sie odbic od gory
        mov     ax,Przesuniecie_Y
        mov     cx,Y_pileczki           ;a do CX Y pileczki
        add     ax,cx
        cmp     ax,20                   ;porownaj AX z 20
        jbe     Zmien_Y                 ; jesli rowne to zmien Y
        mov    ax,X_pileczki
        mov    cx,Przesuniecie_X
        add    ax,cx
        cmp    ax,160
        ja     badaj_prawa
        mov    ax,Y_pileczki
        mov    cx,Przesuniecie_Y
        add    ax,cx
        cmp    ax,200-Rozmiar-Wysokosc_paletki
        jb     koniec_badania
        mov    ax,X_pileczki
        add    ax,Rozmiar
        mov    cx,X_paletki_lewej
        cmp    ax,cx
        jb     prawy_zdobywa_punkt
        mov    ax,X_pileczki
        mov    cx,X_paletki_lewej
        add    cx,Dlugosc_paletki
        cmp    ax,cx
        ja     prawy_zdobywa_punkt
        jmp    odbij_Y
badaj_prawa:
        mov    ax,Y_pileczki
        mov    cx,Przesuniecie_Y
        add    ax,cx
        cmp    ax,200-Rozmiar-Wysokosc_paletki
        jb     koniec_badania
        mov    ax,X_pileczki
        add    ax,Rozmiar
        mov    cx,X_paletki_prawej
        cmp    ax,cx
        jb     lewy_zdobywa_punkt
        mov    ax,X_pileczki
        mov    cx,X_paletki_prawej
        add    cx,Dlugosc_paletki
        cmp    ax,cx
        ja     lewy_zdobywa_punkt
        jmp    odbij_Y


koniec_badania:
        mov     Y_pileczki,ax           ;zaladuj nowe Y pileczki
;teraz od dwoch bokow
        mov     ax,Przesuniecie_X
        mov     cx,X_pileczki
        add     ax,cx
        cmp     ax,320-Rozmiar
        jae      zmien_X
        cmp     ax,0
        jbe      zmien_X
        mov     dx,Przesuniecie_Y
        mov     bx,Y_pileczki
        add     dx,bx
        cmp     dx,111-Rozmiar
        jb      omin
        cmp     ax,159-Rozmiar
        jb      pass_1
        cmp     ax,162-Rozmiar
        ja      pass_1
        call    zmien_X
pass_1:
        cmp     ax,162
        ja      pass_2
        cmp     ax,159
        jb      pass_2
        call    zmien_X
pass_2:

omin:
        mov     X_pileczki,ax
        ret


zmien_X:
        neg Przesuniecie_X
        ret
Zmien_Y:
        neg Przesuniecie_Y
        ret

odbij_Y:
        xor     di,di           ;wyzeruj DI zaraz bedzie potrzebne
        sub     cx,Dlugosc_paletki/2 ;CX=Srodek paletki
        add     ax,Rozmiar/2         ;AX=srodek pileczki
        sub     cx,ax                ;CX=punkt odbicia na paletce
        jnc     _ok                  ;jesli nie byl ujemny to skacz
        neg     cx                   ;..a jesli byl to zmien znak
        mov     di,1                 ;i zaznacz to w di
_ok:
        cmp     cx,6                 ;porownaj cx(punkt odbicia na paletce)
                                     ;z 6
        jae     inne_prz             ;jak wieksze lub rowne to skacz
        mov     dx,Przesuniecie_X
        mov     ax,1                 ;\
        mov     Przesuniecie_X,ax    ; \
        mov     ax,2                 ;  \
                                     ;   >zaladuj nowe przesuniecia X i Y
        mov     Przesuniecie_Y,ax    ;  /
        neg     Przesuniecie_Y       ; /
pilka:
        cmp     dx,8000h
        jnz     check01
        cmp     di,1
        jne     check01
        neg     Przesuniecie_X
check01:
        cmp     di,0
        jne     kon
        neg     Przesuniecie_X
kon:
        jmp     porusz_pilka
inne_prz:
        mov     dx,Przesuniecie_X
        mov     ax,2                 ;\
        mov     Przesuniecie_X,ax    ; \
        mov     ax,1                 ;  \
                                     ;   >zaladuj inne przesuniecia X i Y
        mov     Przesuniecie_Y,ax    ;  /
        neg     Przesuniecie_Y       ; /
        jmp     pilka                ;/

ENDP

;---------------------------------------------------------------------
prawy_zdobywa_punkt PROC
call ustaw_zmienne
mov  ah,86h
mov  cx,6
mov  dx,0
int  15h
inc  Punkty_prawego
cmp  Punkty_prawego,15
jnz   glowna_petla
jmp   QUIT
ENDP

lewy_zdobywa_punkt PROC
call  ustaw_zmienne
mov  ah,86h
mov  cx,6
mov  dx,0
int  15h
inc  Punkty_lewego
cmp  Punkty_prawego,15
jnz  glowna_petla
jmp  QUIT
ENDP

narysuj_punkty PROC
        mov     dx,DANE
        mov     ds,dx
        mov     al,12
rysuj_punkty:
        push cx
        mov  cx,Wysokosc_kreski
rysuj_punkty2:
        mov  ds:[si],al
        add  si,1
        mov  ds:[si],al
        add  si,319
loop    rysuj_punkty2
        pop cx
        sub si,4480
        add si,4
loop    rysuj_punkty

        ret
ENDP



ustaw_zmienne PROC
        mov     X_paletki_lewej,70             ;ustaw zmienne
        mov     X_paletki_prawej,230           ; wartosci X dla paletek
        mov     X_pileczki,158
        mov     Y_pileczki,98
        mov     Przesuniecie_X,1
        call    wylosuj_przesuniecie
        mov     Przesuniecie_Y,1
        ret
ENDP

wylosuj_przesuniecie    PROC
        mov     ah,2ch
        int     21h
        cmp     dl,50
        ja      ujemne_przes
        ret
ujemne_przes:
        neg     Przesuniecie_X
        ret
ENDP
;-----------------------------------------------------------------------
include stars.asm

CODE ENDS

DANE SEGMENT
bufor db 64000 dup(?)
DANE ENDS

END Start
