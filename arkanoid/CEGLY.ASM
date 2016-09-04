;ustawia odpowiednie kolory dla cegiel
;100-109 =odcienie czerwonego
;110-119 =odcienie zielonego
;120-129 =odcienie niebieskiego
;130-139 =odcienie R+G
;140-149 =odcienie G+B
;150-159 =odcienie R+B
;160-169 =odcienie R+G+B
_R db ?
_B db ?
_G db ?
ustaw_kolory_cegiel PROC near
     mov  al,100             ;zaczynamy od koloru 100
     mov  bh,64              ;zacznij od intensywnosci 14
     mov  cx,10              ;dziesiec roznych odcieni czerwonego
ustawiaj_odcien_czerwony:
     mov     _R,bh           ;\
     mov     _G,0            ; >ustaw odpowiednio skladowe
     mov     _B,0            ;/
     call    _set            ;ustaw odpowiedni kolor
     sub     bh,4            ;zmniejsz nasycenie barwy o 4
     inc     al              ;zwieksz numer koloru
loop ustawiaj_odcien_czerwony
     mov    bh,64            ;intensywnosc najwieksza
     mov    cx,10            ;znow 10 odcieni(od 110 numeru koloru)
ustawiaj_odcien_zielony:
     mov     _R,0            ;\
     mov     _G,bh           ; >ustaw odpowiednio skladowe
     mov     _B,0            ;/
     call    _set            ;ustaw odpowiedni kolor
     sub     bh,4            ;zmniejsz intensywnosc o 4
     inc     al              ;zwieksz numer koloru
loop ustawiaj_odcien_zielony
     mov     bh,64           ;znow intensywnosc 64
     mov     cx,10           ;i znow 10 kolorow(od 120 numeru koloru
ustaw_odcien_niebieski:
     mov     _R,0            ;\
     mov     _G,0            ; >ustaw odpowiedni skladowe
     mov     _B,bh           ;/
     call    _set            ;ustaw odpowiedni kolor
     sub     bh,4            ;zmniejsz intensywnosc
     inc     al              ;zwieksz numer koloru
loop ustaw_odcien_niebieski
     mov    bh,64            ;znow intensywnosc 64
     mov    cx,10            ;znow 10 kolorow od 130
ustaw_odcien_RG:
     mov    _R,bh            ;\
     mov    _G,bh            ; >ustaw_odpowiednie intensywnosci
     mov    _B,0             ;/
     call   _set             ;ustaw kolor
     sub    bh,4             ;zmniejsz intensywnosc
     inc    al
loop ustaw_odcien_RG         ;powtorz
     mov    bh,64            ;intensywnosc 64
     mov    cx,10            ;10 kolorow
ustaw_odcien_GB:
     mov    _R,0             ;\
     mov    _G,bh            ; >ustaw intensywnosci
     mov    _B,bh            ;/
     call   _set             ;ustaw kolor
     sub    bh,4
     inc    al
loop ustaw_odcien_GB
     mov    bh,64            ;intensywnosc 64
     mov    cx,10            ;10 kolorow
ustaw_odcien_RB:
     mov    _R,bh             ;\
     mov    _G,0            ; >ustaw intensywnosci
     mov    _B,bh            ;/
     call   _set             ;ustaw kolor
     sub    bh,4
     inc    al
loop ustaw_odcien_RB
     mov    bh,64            ;intensywnosc 64
     mov    cx,10            ;10 kolorow
ustaw_odcien_RGB:
     mov    _R,bh            ;\
     mov    _G,bh            ; >ustaw intensywnosci
     mov    _B,bh            ;/
     call   _set             ;ustaw kolor
     sub    bh,4
     inc    al
loop ustaw_odcien_RGB
     ret                     ;powrot

;----------------------------------------
_set:
    push ax
    mov  dx,3c8h
    out  dx,al
    inc  dx
    mov  al,_R
    out  dx,al
    mov  al,_G
    out  dx,al
    mov  al,_B
    out  dx,al
    pop  ax
    ret
ENDP

narysuj_cegly PROC near             ;procedura rysuje cegly w buforze
       mov  ax,seg DATA             ;\
       mov  es,ax                   ; >ustaw sie na bufor
       sub  edi,edi
;       mov  edi,offset logo_bufor   ;/
       push cs                      ;\
       pop  ds                      ; >ustaw sie na dane
       lea  si,level_01             ;/
       lodsw                        ;pomin bajt ile klockow
odczytaj_bajt:
       lodsw                        ;odczytaj bajt
       cmp  ax,0FFh                 ;czy rowny 255
       je   wspolrzedne             ;jesli tak to zmieniamy wsporzedne
       cmp  ax,0EEh                 ;czy rowny 238
       jne  nie_koniec_danych       ;jesli tak to koniec danych
       ret                          ;powrot
nie_koniec_danych:
       cmp  ax,00                   ;czy rowne 00
       je   brak_klocka             ;jesli rowne to puste miejsce
       cmp  ax,0CEh
       je   brak_klocka_2
       cmp  ax,01                   ;czy rowne 01
       je   klocek_czerwony         ;jesli tak to narysuj klocek czerwony
       cmp  ax,02                   ;czy rowne 02
       je   klocek_zielony          ;jesli tak to narysuj klocek zielony
       cmp  ax,03                   ;czy rowne 03
       je   klocek_niebieski        ;jesli tak to narysuj klocek niebieski
       cmp  ax,04                   ;czy rowne 04
       je   klocek_RG               ;jesli tak to narysuj klocek zolty
       cmp  ax,05                   ;czy rowne 05
       je   klocek_GB               ;jesli tak to narysuj klocek jasnoniebieski
       cmp  ax,06                   ;czy rowne
       je   klocek_RB
       cmp  ax,07
       je   klocek_RGB
       jmp  blad_cegiel

brak_klocka:
       add  edi,20
       jmp  odczytaj_bajt
brak_klocka_2:
       add  edi,10
       jmp  odczytaj_bajt

klocek_czerwony:
       mov  al,64h      ;zaczynamy od koloru czerwonego
       call rysuj_cegle
       jmp  odczytaj_bajt
;--------------------------
klocek_zielony:
       mov  al,6Eh      ;zaczynamy od koloru czerwonego
       call rysuj_cegle
       jmp  odczytaj_bajt
;----------------------------
klocek_niebieski:
       mov  al,78h      ;zaczynamy od koloru czerwonego
       call rysuj_cegle
       jmp  odczytaj_bajt
;--------------------------
klocek_RG:
       mov  al,82h
       call rysuj_cegle
       jmp  odczytaj_bajt
;--------------------------
klocek_GB:
       mov  al,8cH
       call rysuj_cegle
       jmp  odczytaj_bajt
;--------------------------
klocek_RB:
       mov  al,96h
       call rysuj_cegle
       jmp  odczytaj_bajt
;-------------------------
klocek_RGB:
       mov  al,0a0h
       call rysuj_cegle
       jmp  odczytaj_bajt
;-------------------------
rysuj_cegle:
       mov  cx,10
rysuj_cegielke:
       push cx
       mov  cx,20
rysuj_cegielke_2:
       mov  es:[edi],al
       inc  edi
loop   rysuj_cegielke_2
       pop  cx
       inc  al
       add  edi,320-20
loop   rysuj_cegielke
       sub  edx,edx
       sub  edi,(320-20)*10+(20*9)      ;20 razy mamy 320-20 i 10-1 20
       ret
;--------------------------------------
wspolrzedne:
       sub   eax,eax
;       sub   ebx,ebx
       sub   edi,edi    ;liczymy od poczatku ekranu
       lodsw            ;odczytaj wspolrzedna X
       mov   bx,ax      ;zachowaj w bl
       lodsw            ;odczytaj wspolrzedna
       mov   dx,320
       mul   dx         ;ax=ah
       add   ax,bx      ;dodaj X
;       push  ax         ;zapamietaj wartosc
;       sub   eax,eax    ;wyzeruj eax
;       pop   ax         ;pobierz wartosc
       add   edi,eax    ;dodaj do przesuniecia
       jmp   odczytaj_bajt
ENDP