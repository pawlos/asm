;co ma zrobic jesli nacisneto ENTER w menu
co_zrobic_w_menu proc
        mov al,pozycja_w_menu
        cmp al,0              ;jesli jestesmy na 'gra' i wcisnieto ENTER
        je  game              ;to zaczynamy GRE!!!
        cmp al,1
        je  klawisze
        cmp al,2                ; >jesli bylismy na 'koniec' i wcisnieto ENTER to wyjdz
        je  wyjscie             ;/
        ret


klawisze:
        call clear_bufor        ;wyczysc byfor
        call rysuj_gwiazdki     ;narysuj_gwiazdki
        call wypisz_info        ;wypisuje nazwe strony: 'KLAWISZE'
        call wypisz_klawisze    ;wypisuje dostepne klawisze
        call bufor2screen       ;wrzyc wszystko na ekran
czek_w_kalw:
        cmp [key_tab+01],01
        jne czek_w_kalw
        ret

wyjscie:
;zrobic aby pytal czy jest pewien(albo jakies smieszne teksty wypisywal)
        call restore_old_9h
        mov ax,0003h
        int 10h
        pisz_21h end_info
        mov ah,4ch
        int 21h

co_zrobic_w_menu endp