;procedura obslugujaca pilke
porusz_pilke PROC near
        mov ax,pozycja_X_pilki          ;niech ax zawiera pozycje X pilki
        add ax,przesuniecie_X           ;dodaj do tego aktualne przesuniecie
        mov dx,319                      ;niech dx zawiera koniec ekranu
        sub dx,rozmiar_pilki            ;odejmijmy id tego rozmiar pilki
        cmp ax,dx                       ;porownaj
        jae zmienX                      ;czy wieksze badz rowne tak to skocz
        cmp ax,1                        ;nie sprawdz lewy brzeg
        jbe zmienX                      ;jak mniejsze badz rowne to skocz
        mov pozycja_X_pilki,ax          ;w przeciwnym wypadku zapisz nowa pozycie X
sprawdz_Y:
        mov ax,pozycja_Y_pilki          ;niech ax zawiera pozycje Y pilki
        add ax,przesuniecie_Y           ;dodaj przesuniecie Y
        cmp ax,1                        ;czy odbijamy od gory
        jbe zmienY                      ;jesli tak to skocz
        mov pozycja_Y_pilki,ax          ;w przeciwnym wypadku zapisz nowa pozycje pilki Y
badanie_odbicia:
        mov ax,pozycja_Y_pilki          ;niech ax zawiera pozycje Y pilki
        add ax,rozmiar_pilki            ;dodaj rozmiar pilki
        mov dx,199                      ;niech dx zawiera numer dolnej lini ekranu
        sub dx,wysokosc_paletki         ;odejmij od tego wysokosc paletki
        cmp ax,dx                       ;porownaj
        jb  brak_odbicia                ;jesli mniejsze to odbij
        mov ax,pozycja_X_pilki          ;niech ax zawiera pozycje X pilki
        add ax,rozmiar_pilki            ;dodaj do tego rozmiar pilki
        mov dx,pozycja_X_paletki        ;niech dx zawiera pozycje X paletki
        cmp ax,dx                       ;porownaj
        jb  tracisz_zycie               ;jesli pilka poza paletka to tracisz zycie
        mov ax,pozycja_X_pilki          ;niech ax zawiera pozycje X pilki
        mov dx,pozycja_X_paletki        ;a dx pozycje paletki
        add dx,dlugosc_paletki          ;dodaj dlugosc paletki
        cmp ax,dx                       ;porownaj
        ja  tracisz_zycie               ;jesli pilka nie trafila w paletke to tracisz zycie
        call odbij_pod_katem            ;w przeciwnym wypadku zmien kierunek lotu pilki
        jmp koniec_badania              ;skocz nie chcemy aby blednie odczytac paletke za klocek
brak_odbicia:                           ;a moze odbicie od klocka
        mov ax,seg DATA                 ;\
        mov es,ax                       ; >ustaw sie na buforze
        call oblicz_offset              ;oblicz aktualny offset
        mov ax,przesuniecie_Y           ;niech ax zawiera przesuniecie Y
        and ax,8000h
        jnz badaj_gore_pilki
;        cmp ax,0ffffh                   ;czy jest ono ujemne
;        je badaj_gore_pilki             ;jesli tak to pilka mogla uderzyc tylko od gory
;        cmp ax,1                        ;czy rowne 1
        je badaj_dol_pileczki           ;jesli tak to pilka mogla uderzyc tylko od dolu
badaj_boki:
        mov ax,przesuniecie_X           ;niech ax zawiera przesuniecie X
        and ax,8000h
        jnz badaj_lewy_bok
;        cmp ax,0ffffh                   ;czy ujemne
;        je  badaj_lewy_bok              ;jesli tak to pilka mogla uderzyc tylko lewym bokiem
;        cmp ax,1                        ;czy rowne 1
        je  badaj_prawy_bok             ;jesli tak to mogla uderzyc tylko z prawej
koniec_badania:
        ret                             ;powrot

oblicz_offset:
        sub edi,edi                     ;wyzeruj edi
        sub eax,eax                     ;i eax
        mov ax,pozycja_Y_pilki          ;\
        mov bx,320                      ; |oblicz offset ekranu
        mul bx                          ; |
        add ax,pozycja_X_pilki          ;/
        add edi,eax                     ;dodaj offsety
        ret                             ;powrot
;----------------------------------------

badaj_lewy_bok:
        call oblicz_offset              ;oblicz aktualny offset ekranu
        dec edi                         ;zmniejsz o jeden offset
        mov cx,rozmiar_pilki            ;badamy 5 pixeli
badaj_l_bok:
        mov al,es:[edi]                 ;odczytaj bajt
        cmp al,0                        ;czy jest jakis kolor
        jne odbij_od_boku_l               ;jesli tak to odbij
        add edi,320                     ;przejdz o linijke nizej
loop    badaj_l_bok                     ;powtarzaj
        jmp koniec_badania              ;wyskocz
;----------------------------------------
badaj_prawy_bok:
        call oblicz_offset              ;oblicz atualny offset ekranu
        add di,rozmiar_pilki            ;dodaj rozmiar pilki
        mov cx,rozmiar_pilki            ;sprawdzamy 5 pixeli
badaj_p_bok:
        mov al,es:[edi]                 ;odczytaj bajt
        cmp al,0                        ;czy jest jakis kolor
        jne odbij_od_boku_p               ;jak tak to odbij
        add edi,320                     ;przejdz o linijke nizej
loop    badaj_p_bok                     ;powtarzaj
        jmp koniec_badania              ;wyskocz
;----------------------------------------
badaj_dol_pileczki:
        call oblicz_offset              ;oblicz aktualny offset ekranu
        add edi,320*5                   ;przejdz na dol pilki
        mov cx,rozmiar_pilki         ;do cx licznik petli
badaj_dol:
        mov al,es:[edi]                 ;odczytaj bajt
        cmp al,0                        ;czy rowne 0
        jne odbij_od_dolu               ;jesli nie to znaczy ,ze trafilismy w klocek
        inc edi
loop    badaj_dol
        jmp badaj_boki                  ;badaj bok
;----------------------------------------
badaj_gore_pilki:
        call oblicz_offset              ;oblicz aktualny offset ekranu
        sub edi,320                     ;przejdz linie w gore
        mov cx,rozmiar_pilki            ;do cx licznik petli
badaj_gore:
        mov al,es:[edi]                 ;odczytaj bajt
        cmp al,0
        jne odbij_od_gory
        inc edi
loop    badaj_gore
        jmp badaj_boki                  ;badaj boki pilki
;----------------------------------------
odbij_od_gory:                            ;pilka leci do gory
;w cx numer pixela w ktory uderzylismy
        push cs                           ;ustaw sie na tablice
        pop  ds                           ; /
        lea  si,level_01                  ;/
        xor  edx,edx                      ;wyzeruj edx
        xor  eax,eax                      ;wyzeruj eax
        mov  ax,pozycja_X_pilki           ;do ax zaladuj pozycje X pilki
        add  ax,rozmiar_pilki
        sub  ax,cx                        ;odejmij numer pixela
        mov  bx,20                        ;do bx 20
        div  bx                           ;podziel ax/20
        mov  poz_X,ax                     ;zapamietaj wynik(bez reszty)
        xor  edx,edx
        mov  ax,pozycja_Y_pilki           ;\
        dec  ax
        mov  bx,10                        ; >j.w
        div  bx                           ;/
        mov  poz_Y,ax                     ;zapamietaj wynik
        call sprawdz
        neg przesuniecie_y              ;zaneguj przesuniecie Y
        jmp koniec_badania              ;wyskocz
;----------------------------------------
sprawdz:
;ds:esi tablica
sprawdzaj:
        lodsw   ;odczytaj slowo
        cmp     ax,0ffh   ;czy rowne 255
        je      zbadaj_dalej
        cmp     ax,0eeh
        jne     sprawdzaj
        ret

zbadaj_dalej:
        xor  edx,edx
        lodsw           ;odczytaj X
        mov  bx,20
        div  bx         ;podziel
        cmp  ax,poz_X   ;rowne?
        jne  dalej0     ;jesli nie to skocz
        xor  edx,edx    ;wyzeruj edx
        lodsw           ;odczytaj slowo
        mov  bx,10      ;podziel przez 10
        div  bx         ;wykonaj
        cmp  ax,poz_Y   ;porownaj z wczesniej obliczona wartoscia
        jne  dalej1     ;jesli nie rowne to skocz
        mov  ax,00      ;niech ax zawiera 0
        mov  ds:[si],ax ;wyzeruj bajt
        lodsw           ;odczytaj slowo
        dec  ile_klockow
        cmp  ile_klockow,0
        je   QUIT
zbadaj_end:
       jmp   sprawdzaj  ;pomow sprawdzanie
dalej0:
      lodsw     ;pomin Y
dalej1:
      lodsw     ;pomin wartosc cegly
      jmp       sprawdzaj;ponow sprawdzanie
;----------------------------------------
odbij_od_dolu:
;pilka w dol
        push cs                           ;ustaw sie na tablice
        pop  ds                           ; /
        lea  si,level_01                  ;/
        xor  edx,edx                      ;wyzeruj edx
        xor  eax,eax                      ;wyzeruj eax
        mov  ax,pozycja_X_pilki           ;do ax zaladuj pozycje X pilki
        add  ax,rozmiar_pilki
        sub  ax,cx                        ;dodaj numer pixela w ktory uderzylismy
        mov  bx,20                        ;do bx 20
        div  bx                           ;podziel ax/20
        mov  poz_X,ax                     ;zapamietaj wynik(bez reszty)
        xor  edx,edx
        mov  ax,pozycja_Y_pilki           ;\
        add  ax,rozmiar_pilki
        inc  ax                           ;abysmy byli na pewno w klocku
        mov  bx,10                        ; >j.w
        div  bx                           ;/
        mov  poz_Y,ax                     ;zapamietaj wynik
        call sprawdz                      ;sprawdz ,ktory to klocek
        neg przesuniecie_Y                ;zaneguj przesuniecie Y
        jmp koniec_badania                ;koniec badania
;---------------------------------------------------------------
;przy wywolaniu w cx-ktory pixel trafiony
odbij_od_boku_l:
        push cs                           ;ustaw sie na tablice
        pop  ds                           ; /
        lea  si,level_01                  ;/
        xor  edx,edx                      ;wyzeruj edx
        xor  eax,eax                      ;wyzeruj eax
        mov  ax,pozycja_X_pilki           ;do ax zaladuj pozycje X pilki
        dec  ax                           ;abysmy byli na pewno w klocku
        mov  bx,20                        ;do bx 20
        div  bx                           ;podziel ax/20
        mov  poz_X,ax                     ;zapamietaj wynik(bez reszty)
        xor  edx,edx
        mov  ax,pozycja_Y_pilki           ;\
        add  ax,rozmiar_pilki
        sub  ax,cx                        ;dodaj numer trafionego pixela
        mov  bx,10                        ; >j.w
        div  bx                           ;/
        mov  poz_Y,ax                     ;zapamietaj wynik
        call sprawdz                      ;sprawdz ,ktora cegle trafilismy
        neg przesuniecie_X                ;naneguj przesuniecie X
        jmp koniec_badania                ;wyskocz

odbij_od_boku_p:
;pilka w prawo,przy wywolaniu w cx-numer pixela ktory trafila pilka
        push cs                           ;ustaw sie na tablice
        pop  ds                           ; /
        lea  si,level_01                  ;/
        xor  edx,edx                      ;wyzeruj edx
        xor  eax,eax                      ;wyzeruj eax
        mov  ax,pozycja_X_pilki           ;do ax zaladuj pozycje X pilki
        add  ax,rozmiar_pilki             ;\
        inc  ax                           ; abysmy byli na pewno w klocku
        mov  bx,20                        ;do bx 20
        div  bx                           ;podziel ax/20
        mov  poz_X,ax                     ;zapamietaj wynik(bez reszty)
        xor  edx,edx
        mov  ax,pozycja_Y_pilki           ;\
        add  ax,rozmiar_pilki
        sub  ax,cx                        ; dodaj numer pixela wktory trafilismy
        mov  bx,10                        ; >j.w
        div  bx                           ;/
        mov  poz_Y,ax                     ;zapamietaj wynik
        call sprawdz
        neg przesuniecie_X              ;zaneguj przesuniecie X
        jmp koniec_badania              ;wyskocz
;----------------------------------------
tracisz_zycie:
        mov pozycja_X_pilki,160
        mov pozycja_Y_pilki,130
        mov ah,86h
        mov cx,6
        mov dx,0
        int 15h
        jmp main_
;----------------------------------------
zmienY:
        neg przesuniecie_Y              ;zaneguj przesuniecie Y
        jmp badanie_odbicia             ;wykocz
;----------------------------------------
zmienX:
        neg przesuniecie_X              ;zaneguj przesuniecie X
        jmp sprawdz_Y                   ;badaj_dalej
;----------------------------------------
odbij_pod_katem:
        neg przesuniecie_Y
        ret
ENDP
;----------------------------------------

narysuj_pilke PROC near
;zrobic aby pilka byla okragla!
        mov  ax,seg DATA                ;do ax segment ekranu
        mov  es,ax                      ;przepisz go do ax
        sub  edi,edi                    ;wyzeruj edi
        sub  eax,eax                    ;i eax
        mov  ax,pozycja_Y_pilki         ;do ax pozycje Y pilki
        mov  bx,320                     ;pomnoz przez 320
        mul  bx                         ;wykonaj(zmienic na shl
        add  ax,pozycja_X_pilki         ;dodaj pozycje X pilki
        add  edi,eax                    ;dodaj do edi
        mov  cx,rozmiar_pilki           ;w cx rozmiar petli
        mov  al,90                      ;a w al kolor pilki
rysuj_pilke:
        push cx                         ;odloz cx(licznik petli)
        mov  cx,rozmiar_pilki           ;zaladuj nowy licznik
rysuj_pileczke:
        mov  es:[edi],al                ;wpisz bajt
        inc  edi                        ;zwieksz
loop    rysuj_pileczke                  ;powtarzaj
        pop  cx                         ;pobierz licznik petli
        add  edi,320-rozmiar_pilki      ;przesun sie do nowej lini
loop    rysuj_pilke                     ;powtarzaj
        ret                             ;powrot
ENDP