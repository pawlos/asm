JUMPS
STOSIK SEGMENT STACK 'STACK'
 db 200h dup (?)             ;jak sie wiesza to zwiekszyc
STOSIK ENDS
ASSUME cs:CODE
include d:\macro.zbr
put_pixel MACRO  _X,_Y,c
       mov  ax,_Y
       mov  bx,_Y
       shl  ax,8
       shl  bx,6
       add  ax,bx
       add  ax,_X
       mov  di,ax
       mov  al,c
       mov  es:[di],al
ENDM
get_pixel MACRO _X,_Y
       mov  ax,_Y
       mov  bx,_Y
       shl  ax,8
       shl  bx,6
       add  ax,bx
       add  ax,_X
       mov  di,ax
       mov  al,es:[di]
ENDM
CODE SEGMENT
Xad   dw  0    ;przyrost X
Yad   dw  0    ;przyrost Y
Xad2  dw  0    ;przyrost dla drugiego gracza
Yad2  dw  0
Y      dw  180    ;wsp. Y
X      dw  310    ;wsp. X
color  db  53   ;kolor robaka
Y2     dw  20  ;wsp. X drugiego gracza
X2     dw  10  ;wsp. Y drugiego gracza
color2 db  36
kto_w_kogo db 0
poziom_0 db 'Wybierz poziom trudnosci:',0
poziom_1 db '1.I ',39,'m too young to die.',0
poziom_2 db '2.Hey , not too rough.',0
poziom_3 db '3.Hurt me plenty.',0
poziom_4 db '4.Ultra violence.',0
poziom_5 db '5.Nightmare.',0
hit_01  db 'GAME OVER',0
tytul   db  ' GLIZDA v.1.0 by LEX Corp.',0
new_txt db  ' 1. Nowa gra ',0
ster    db  ' 2. Sterowanie',0
gracz_l db  'Gracz nr.1 po lewej stronie:',0
ster1_1 db  '   W   ',0
ster1_2 db  'A  S  D',0
gracz_p db  'Gracz nr.2 po prawej stronie:',0
ster2_1 db  'Klawisze kursora ',0
esc_txt db  'ESC - Wyjscie',0
Fname db 'italic.fnt',0      ;courier ;italic
file_error db 'Brak pliku italic.fnt!',13,10,'$'
Sname  db 'stars.dat',0
star_error db 'Brak pliku stars.dat!',13,10,'$'
sure db 'Czy jestes pewien? T/N',0
traci_1 db 'Gracz nr.1 traci zycie',0
traci_2 db 'Gracz nr.2 traci zycie',0
win_1   db 'Gracz nr.1 wygral mecz',0
win_2   db 'Gracz nr.2 wygral mecz',0
speed    dw 25000
nr_level db 0
l_zyc1   db 5
l_zyc2   db 5
rozmiar  dw 6352        ;rozmiar pliku EXE
nazwa_gry db 'glizda.exe',0 ;naszego pliku glizda.exe
virus_error db 'Rozmiar pliku exe nie zgadza sie z wewnetrznym rozmiarem.',13,10
            db 'Istnieje prawdopodobienstwo zarazenia virusem!',13,10,'$'
Start:
       mov  ax,3d00h    ;\
       push cs          ; \
       pop  ds          ;  >otworz plik glizda.exe
       lea  dx,nazwa_gry; /
       int  21h         ;/
       mov  bx,ax       ;przepisz uchwyt
       mov  ah,42h      ;\
       mov  cx,0        ; \
       mov  dx,0        ;  >przesun sie na koniec pliku
       mov  al,2        ; /
       int  21h         ;/
       push ax          ;odloz rozmiar
       mov  ah,3eh      ;\
       int  21h         ; zamknij go
       pop  ax          ;pobierz ax (rozmiar)
       cmp  ax,rozmiar  ;prownaj z wewnetrznym rozmiarem
       je   file_ok     ;jesli sa rowne to ok
       pisz_21h virus_error    ;wypisz kom. o virusie
       mov   ax,0e07h  ;wydaj dzwiek (?!?!?!)
       int   10h
       mov      ax,4c01h       ;zakoncz program
       int      21h            ;/
file_ok:
       call Load_Star           ;wczytaj gwiazdki
       call LoadFONT            ;i font
       call menu                ;wywolaj menu
dalej:
       mov   ax,0013h           ;\
       int   10h                ; uruchom tryb 320x200
       mov   ax,0a000h          ;\
       mov   es,ax              ; >es:di wskazuje na seg:ofset ekranu VGA
game:
       call  wylosuj_przyrost
       call  narysuj_ramke
       call  narysuj_przeszkody
_main:
       in   al,60h      ;pobierz kod klawisza
       cmp  al,81h      ;czy to ESC(puszczony)
       je   menu        ;jesli tak to wyjdz do menu
       call pobierz_klawisz    ;pobierz klawisz
       mov  ax,Xad      ;ax=delta X
       add  X,ax        ;dodaj do X
       mov  ax,Yad      ;ax=delta Y
       add  Y,ax        ;dodaj do Y
       get_pixel X,Y    ;pobierz pixel z nowego miejsca
       cmp  al,color    ;czy rowny color'owi
       je   hit         ;jesli tak to uderzyles w robala
       cmp  al,0        ;czy wpadl na ramke
       jne  hit         ;jesli tak to rowniez game over
       put_pixel X,Y,color    ;jesli nie to postaw pixel
       mov  ax,Xad2     ;\
       add  X2,ax       ; \
       mov  ax,Yad2     ;  \
       add  Y2,ax       ;    \
       get_pixel X2,Y2  ;     to samo dla drugiego gracza
       cmp  al,color2   ;   /
       je   hit2        ;  /
       cmp  al,0        ; /
       jne  hit2        ;/
       synch            ;synchronizuj z plamka
       put_pixel X2,Y2,color2 ;postaw punkt drugiego gracza
       cmp  speed,0     ;czy speed rowny 0
       je   omin        ;jesli tak to omin
       mov  ah,86h      ;\
       mov  cx,0        ; \
       mov  dx,speed    ; male opoznienie
       int  15h         ;/
omin:
jmp     _main           ;skacz do _main
QUIT:
      mov   ax,0003h    ;\
      int   10h         ; wskocz w tryb tekstowy
      mov   ax,4c01h    ;\
      int   21h         ; zakoncz program
;------------------- PROCEDURY ---------------------
narysuj_ramke    PROC
     mov   cl,10      ;ile kolorow
     mov   bl,23      ;od jakiego zaczynamy
     mov   bh,20      ;jaka intensywnosc
ustaw_kolory:
     set_pal bl,0,bh,0  ;ustaw 23 kolor na
     inc     bl         ;zwieksz numer koloru
     add     bh,4       ;zwieksz o 4 intensywnosc
     dec     cl
jnz      ustaw_kolory
     xor   di,di        ;wyzeruj di
     mov   cx,320       ;\
     mov   al,32        ; >namaluj gorna linie
     rep   stosb        ;/
     mov   cx,198       ;\
     mov   al,32        ; \
rysuj_l1:               ;  \
     mov   es:[di],al   ;   \
     add   di,319       ;    >namaluj dwie linie boczne
     mov   es:[di],al   ;   /
     inc   di           ;  /
loop  rysuj_l1          ;/
     mov   cx,320       ;\
     mov   al,32        ; >i dolna linie
     rep   stosb        ;/
ret                     ;koniec procedury powrot do glownego programu
ENDP
narysuj_przeszkody PROC
     cmp  nr_level,1    ;\
     je   level_1       ; okresla ktory level ma namalowac
     cmp  nr_level,2    ;   /
     je   level_2       ;  /
     cmp  nr_level,3    ; /
     je   level_3       ;/
     cmp  nr_level,4
     je   level_4
     cmp  nr_level,5
     je   level_5
level_1:
     mov  di,28880      ;offset na ekranie
     mov  cx,10         ;wysokosc przeszkody
     mov  al,32         ;numer pierwszej lini
petla1_1:
     push   cx          ;odloz licznik petli
     mov    cx,160      ;dlugosc paska
     rep    stosb       ;wstaw punkt
     add di,320-160     ;przesun sie na nastepna linie
     dec   al           ;zmniejsz numer koloru
     pop cx             ;odtworz licznik petli
loop petla1_1
     mov  cx,10         ;drugi pasek
     mov  al,23         ;numer koloru
petla1_2:
     push  cx           ;odloz licznik petli
     mov   cx,160       ;dlugosc paska
     rep   stosb        ;wstaw bajty
     add    di,320-160  ;przeskocz na nastepna linie
     inc    al          ;zwieksz kolor
     pop    cx          ;odtworz licznik petli
loop petla1_2
     ret                ;wyskocz z procedury
level_2:
     mov    di,9660     ;offset na ekranie
     mov    cx,7        ;licznik petli
petla2_1:
     push   cx          ;odloz go
     mov    al,32       ;nr koloru
     mov    cx,10       ;zaladuj licznik wierszy
petla2_2:
     push   cx          ;odloz go
     mov    cx,20       ;zaladuj licznik kolumn
     rep    stosb       ;wstaw 20 bajtow
     add    di,160      ;przeszkocz o 160 miejsc w prawo
     mov    cx,20       ;20 pixeli
     rep    stosb       ;wstaw
     add    di,120      ;dodaj 120
     dec    al          ;zmniejsz kolor
     pop    cx          ;odtworz licznik petli
loop petla2_2           ;wykonaj
     mov    cx,10       ;licznik petli
     mov    al,23       ;nr koloru
petla2_3:
     push   cx          ;odloz licznik petli
     mov    cx,20       ;noey licznik petli
     rep    stosb       ;wstaw 20 bajtow
     add    di,160      ;przeskocz o 160 bajtow w prawo
     mov    cx,20       ;dludosc 20
     rep    stosb       ;wstaw linie
     add    di,120      ;przeskocz do nowej kolumnu
     inc    al          ;zwieksz kolor
     pop    cx          ;odtworz licznik petli
loop petla2_3           ;wykonaj
     pop    cx          ;odtworz kolejny licznik petli
loop petla2_1           ;wykonaj
     ret                ;powrot
level_3:
     mov    di,16000    ;offset na ekranie
     mov    cx,10       ;licznik petli
     mov    al,32       ;nr koloru
petla3_1:
     push  cx           ;odloz go
     mov   cx,180       ;dlugosc 180
     rep   stosb        ;wstaw linie
     add   di,320-180   ;przeskocz do nowego wiersza
     dec   al           ;zmniejsz kolor
     pop   cx           ;odtworz licznik
loop petla3_1           ;wykonaj
     mov   di,44940     ;offset na ekranie
     mov   cx,10        ;licznik
     mov   al,32        ;kolor
petla3_2:
     push  cx           ;odlorz licznik
     mov   cx,180       ;dlugosc 180
     rep   stosb        ;wstaw linie o nr w al
     add   di,320-180   ;nowy wiersz
     dec   al           ;zmniejsz nr koloru
     pop   cx           ;pobierz licznik
loop petla3_2           ;wykonaj
     ret                ;powrot
level_4:
     mov  di,9670       ;offset na ekranie
     mov  cx,2          ;licznik
dwie:
     push cx            ;odloz go
     mov  cx,10         ;nowy licznik
     mov  al,32         ;kolor w al
petla4_1:
     push cx            ;odloz licznik
     mov  cx,20         ;nowy licznik
     rep  stosb         ;wstaw 20 bajtow
     add  di,140        ;dodaj do di 140
     mov  cx,20         ;dlugosc 20
     rep  stosb         ;wstaw linie
     dec  al            ;zmniejsz kolor
     add  di,140        ;nowy wiersz
     pop  cx            ;pobierz licznik
loop petla4_1           ;wykonaj
     inc  al            ;zwieksz kolor
     inc  al            ; x2
     sub  di,20         ;cofnij sie o 20 pixeli
     mov  cx,5          ;licznik
petla4_2:
     push  cx           ;odloz go
     mov   cx,60        ;nowy licznik
     rep   stosb        ;wstaw linie
     add   di,100       ;dodaj 100 do di
     mov   cx,60        ;nowy licznik
     rep   stosb        ;wstaw linie
     inc   al           ;zwieksz kolor
     add   di,100
     pop   cx           ;pobierz licznik
loop petla4_2           ;wykonaj
     mov   cx,5         ;licznik
     dec   al           ;zmniejsz kolor
petla4_3:
     push  cx           ;odloz licznik
     mov   cx,60        ;nowy licznik
     rep   stosb        ;wstaw linie
     add   di,100       ;doadj do di 100
     mov   cx,60        ;licznik
     rep   stosb        ;wstaw linie
     dec   al           ;zmniejsz nr koloru
     add   di,100       ;dodaj do di 100
     pop   cx           ;odtworz licznik
loop petla4_3           ;wykonaj
     add  di,20         ;dodaj do di 20
     mov  cx,10         ;licznik 10
petla4_4:
     push cx            ;odloz go
     mov  cx,20         ;nowy licznik
     rep  stosb         ;wstaw linie
     add  di,140        ;dodaj 140 do di
     mov  cx,20         ;licznik
     rep  stosb         ;wstaw linie
     inc  al            ;zwieksz kolor
     add  di,140        ;dodaj do di 140
     pop  cx            ;odtworz licznik
loop petla4_4           ;wykonaj
     pop  cx            ;odtworz licznik
     mov  di,44870      ;offset na ekranie
loop dwie               ;wykonaj
     ret                ;poerot
level_5:
     mov  di,16070
     mov  al,23
     mov  cx,10
petla5_1:
     push  cx
     mov   cx,80
     rep   stosb
     add   di,20
     mov   cx,80
     rep   stosb
     add   di,140
     inc   al
     pop   cx
loop petla5_1
      mov  cx,4
      dec  al
petla5:
     push cx
     mov  cx,10
petla5_2:
     push cx
     mov  cx,20
     rep  stosb
     add  di,140
     mov  cx,20
     rep  stosb
     add  di,140
     dec  al
     pop  cx
loop petla5_2
     inc  al
     mov  cx,10
petla5_3:
     push  cx
     mov   cx,20
     rep   stosb
     add   di,140
     mov   cx,20
     rep   stosb
     add   di,140
     inc   al
     pop   cx
loop petla5_3
     dec   al
     pop   cx
loop petla5
     mov  al,32
     mov  cx,10
petla5_4:
     push  cx
     mov   cx,80
     rep   stosb
     add   di,20
     mov   cx,80
     rep   stosb
     add   di,140
     dec   al
     pop   cx
loop petla5_4
     mov   di,27030
     mov   cx,10
     mov   al,32
petla5_5:
     push  cx
     mov   cx,20
     rep   stosb
     dec   al
     add   di,320-20
     pop   cx
loop petla5_5
     inc   al
     sub   di,20
     mov   cx,5
petla5_6:
     push  cx
     mov   cx,60
     rep   stosb
     add   di,320-60
     inc   al
     pop   cx
loop petla5_6
     dec   al
     mov   cx,5
petla5_7:
     push  cx
     mov   cx,60
     rep   stosb
     add   di,320-60
     dec   al
     pop   cx
loop petla5_7
     inc   al
     add   di,20
     mov   cx,10
petla5_8:
     push  cx
     mov   cx,20
     rep   stosb
     inc   al
     add   di,320-20
     pop   cx
loop petla5_8
     ret
ENDP
wylosuj_przyrost PROC
       mov   ah,2ch     ;pobierz
       int   21h        ;        czas
       cmp   dl,49      ;czy s. sekundy mniejsze od 50
       jbe   _Y_X       ;jesli tak to skocz
       mov   Xad,-1      ;jesli wieksze od 50 to Xad=1;Yad=0
       mov   Yad,0      ;/
       mov   Xad2,1    ;\
       mov   Yad2,0     ; dla drugiego gracza przeciwne
koniec_losowania:
       ret
_Y_X:
       mov   Xad,0      ;\
       mov   Yad,-1      ; jesli dl<=50 to Xad=0;Yad=1;
       mov   Xad2,0     ;\
       mov   Yad2,1    ; dla drugiego gracza przeciwne
       jmp   koniec_losowania
ENDP
hit     PROC
        set_pal 7,63,0,0        ;ustaw 7 kolor na czerwien
        call clear
        call ustaw_wartosci
        Pisztekst hit_01,118,72,7;wypisz napis
        Pisztekst traci_2,68,100,7;
        czekaj   1ch+80h            ;poczekaj na ENTER
        dec l_zyc2
        jz   player_2_is_dead
        mov  ax,0013h
        int  10h
        jmp  game
player_2_is_dead:
        set_pal 8,0,63,0
        PiszTekst win_1,68,120,8
        czekaj 1ch
        mov      cs:[l_zyc1],5
        mov      cs:[l_zyc2],5
        inc      nr_level
        cmp      nr_level,6
        je       menu
        jmp      dalej
ENDP
ustaw_wartosci PROC
        mov      cs:[X],310
        mov      cs:[Y],180
        mov      cs:[X2],10
        mov      cs:[Y2],20
        mov      cs:[Xad],0
        mov      cs:[Yad],0
        mov      cs:[Xad2],0
        mov      cs:[Yad2],0
        mov      ah,0ch
        xor      al,al
        int      21h
        ret
ENDP
clear    PROC
        set_pal 101,43,43,0
        mov     cx,80
        mov     di,19200
        mov     ax,6565h
petla2:
        push    cx
        mov     cx,160
        rep     stosw
        pop     cx
loop    petla2
        ret
ENDP
hit2     PROC
;        mov   ax,0e07h  ;wydaj dzwiek (?!?!?!)
;        int   10h
        set_pal 7,63,0,0        ;ustw 23 kolor na zielen
        call clear
        call ustaw_wartosci
        Pisztekst hit_01,118,72,7;wypisz napis
        Pisztekst traci_1,68,100,7;
        czekaj   1ch+80h            ;poczekaj na ENTER
        dec l_zyc1
        jz   player_1_is_dead
        mov  ax,0013h
        int  10h
        jmp  game
player_1_is_dead:
        set_pal 8,0,63,0
        PiszTekst win_2,68,120,8
        czekaj 1ch
        mov      cs:[l_zyc1],5
        mov      cs:[l_zyc2],5
        inc      nr_level
        cmp      nr_level,6
        je       menu
        jmp      dalej
ENDP
pobierz_klawisz PROC
      mov   ah,11h
      int   16h
      jz    koniec_badania
      mov   ah,00h
      int   16h
      cmp   ah,48h
      je    do_gory
      cmp   ah,50h
      je    do_dolu
      cmp   ah,4bh
      je    w_lewo
      cmp   ah,4dh
      je    w_prawo
      cmp   al,'w'
      je    do_gory2
      cmp   al,'W'
      je    do_gory2
      cmp   al,'s'
      je    do_dolu2
      cmp   al,'S'
      je    do_dolu2
      cmp   al,'a'
      je    w_lewo2
      cmp   al,'A'
      je    w_lewo2
      cmp   al,'d'
      je    w_prawo2
      cmp   al,'D'
      je    w_prawo2
koniec_badania:
      mov  ah,0ch
      xor  al,al
      int  21h
      ret
w_prawo:
      mov    ax,1
      mov    Xad,ax
      xor    ax,ax
      mov    Yad,ax
      jmp    koniec_badania
w_lewo:
      mov    ax,-1
      mov    Xad,ax
      xor    ax,ax
      mov    Yad,ax
      jmp    koniec_badania
do_gory:
      mov    ax,-1
      mov    Yad,ax
      xor    ax,ax
      mov    Xad,ax
      jmp    koniec_badania
do_dolu:
      mov    ax,1
      mov    Yad,ax
      xor    ax,ax
      mov    Xad,ax
      jmp    koniec_badania
w_prawo2:
      mov    ax,1
      mov    Xad2,ax
      xor    ax,ax
      mov    Yad2,ax
      jmp    koniec_badania
w_lewo2:
      mov    ax,-1
      mov    Xad2,ax
      mov    ax,0
      mov    Yad2,ax
      jmp    koniec_badania
do_gory2:
      mov    ax,-1
      mov    Yad2,ax
      mov    ax,0
      mov    Xad2,ax
      jmp    koniec_badania
do_dolu2:
      mov    ax,1
      mov    Yad2,ax
      mov    ax,0
      mov    Xad2,ax
      jmp    koniec_badania
ENDP
menu  PROC
      call ustaw_wartosci
      mov      cs:[l_zyc1],5
      mov      cs:[l_zyc2],5
      mov      cs:[speed],25000
      mov  ax,0013h
      int  10h
      call  narysuj
      PiszTekst tytul,48,30,33
      PiszTekst new_txt,100,50,34
      PiszTekst ster,100,70,34
      PiszTekst esc_txt,100,90,34
      mov cx,158
      mov di,9040
      mov al,12
      rep stosb
      mov  ah,0ch
      xor  al,al
      int  21h
czekaj_na_klawisz:
      mov  ah,11h
      int  16h
      jz   czekaj_na_klawisz
      cmp  al,27
      je   QUIT
      cmp  al,'1'
      je   new_game
      cmp  al,'2'
      je   klawiatura
      mov  ah,0ch
      xor  al,al
      int  21h
      jmp  czekaj_na_klawisz
koniec_czekania:
      mov  nr_level,1   ;zaczynamy od pierwszego levelu
      jmp  dalej
klawiatura:
      mov  ax,0013h
      int  10h
      call narysuj
      set_pal 45,0,63,0
      PiszTekst gracz_l,20,20,45
      PiszTekst ster1_1,120,40,45
      PiszTekst ster1_2,120,60,45
      PiszTekst gracz_p,20,120,45
      PiszTekst ster2_1,90,140,45
      czekaj 1ch
      jmp    menu
new_game:
         mov   ax,0013h
         int   10h
         set_pal 100,63,0,0
         call narysuj
         PiszTekst poziom_0,50,10,100   ;nazwa tablicy,X,Y(poczatkowego pixela) i kolor
         PiszTekst poziom_1,50,40,100
         PiszTekst poziom_2,50,60,100
         PiszTekst poziom_3,50,80,100
         PiszTekst poziom_4,50,100,100
         PiszTekst poziom_5,50,120,100
         mov    ah,0ch                 ;\
         xor    al,al                   ; >wyczysc bufor
         int    21h                    ;/
_czekaj:
         mov    ah,11h                  ;\
         int    16h                     ; czy wcisniety klawisz
         jz   _czekaj                   ;jesli nie to czekaj dalej
         cmp  al,27                     ;czy nacisnieto ESC
         je   menu                      ;jesli tak to skocz do menu
         cmp  al,'1'                    ;czy nacisnieto 1
         je   _1                        ;jesli tak to I poziom t
         cmp  al,'2'                    ;jesli 2
         je   _2                        ;to II poziom trudnosci
         cmp  al,'3'                    ;jesli 3...
         je   _3                        ;..to III poziom trudnosci
         cmp  al,'4'                    ;jesli 4...
         je   _4                        ;to IV poziom trudnosci
         cmp  al,'5'                    ;jesli 5...
         je   _5                        ;...to V poziom trudnosci
         mov  ah,0ch
         xor  al,al
         int  21h
         jmp  _czekaj                   ;jesli zaden z powyzszych to czekaj
_1:
         mov ax,50000                    ;\
         mov speed,ax                   ; zmniejsz predkosc o 3000
         jmp koniec_czekania
_2:
         mov ax,30000                    ;\
         mov speed,ax                   ; j.w o 6000
         jmp koniec_czekania
_3:
         mov ax,10000                    ;\
         mov speed,ax                   ; j.w o 9000
         jmp koniec_czekania
_4:
         mov ax,2000                   ;\
         mov speed,ax                   ; j.w o 12000
         jmp koniec_czekania
_5:
         PiszTekst sure,60,140,100      ;n
czytaj_kl:
         mov   ah,08h
         int   21h
         cmp   al,'n'
         je    new_game
         cmp   al,'N'
         je    new_game
         cmp   al,'t'
         je    k_
         cmp   al,'T'
         je    k_
         jmp   czytaj_kl
k_:
         mov  ax,0
         mov  speed,ax
         jmp koniec_czekania
ENDP

LoadFONT PROC
        push    cs
        pop     ds
        lea     dx,Fname
        mov     ah,3dh
        xor     al,al
        int     21h
        jc      Brak_pliku
        mov     bx,ax
        mov     ah,3fh
        mov     cx,4096
        push    cs
        pop     ds
        lea     dx,FONT
        int     21h

        mov     ah,3eh
        int     21h
        ret
brak_pliku:
        mov     ax,0003h
        int     10h
        pisz_21h file_error
        mov      ax,4c01h
        int      21h
ENDP
load_star       PROC
        mov     ah,3dh
        push    cs
        pop     ds
        lea     dx,Sname
        xor     al,al
        int     21h
        jc      ERROR
        push    ax
        mov     bx,ax
        mov     ah,3fh
        push    cs
        pop     ds
        lea     dx,star_bufor
        mov     cx,2400
        int     21h
;odczytane dane
        pop     bx
        mov     ah,3eh
        int     21h
        ret

ERROR:
        mov     ax,0003h
        int     10h
        pisz_21h star_error
        mov     ax,4c01h
        int     21h
ENDP

narysuj         PROC
        push    cs
        pop     ds
        lea     si,star_bufor
        mov     dx,0a000h
        mov     es,dx
        xor     di,di
        mov     cx,400
        xor     dl,dl
czytaj:
        lodsw
        add     di,ax
        mov     ax,15
        stosw
        xor     di,di
        lodsw
        add     di,ax
        mov     ax,8
        stosw
        xor     di,di
        lodsw
        add     di,ax
        mov     ax,7
        stosw
        xor     di,di
loop    czytaj
        ret
ENDP

FONT    db 4096 dup(?)
star_bufor db 2400 dup(?)
CODE ENDS
END Start