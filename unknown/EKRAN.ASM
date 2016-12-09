;przygotowuje ekran(rysuje belk© nagˆ¢wkow¥)
ekran_poczatkowy proc near
        mov ax,0b800h      ;seg ekr. w tr. textowym
        mov es,ax          ;przepisz
        xor di,di          ;wyzeruj
        mov ax,4f20h       ;parametry
        mov cx,80
        rep stosw          ;wstaw zanki
        mov di,68          ;offset tytulu
        lea si,tytul
@@wypisz_tytul:
        mov al,cs:[si]     ;do al bajt napisu
        cmp al,0
        je  @@koniec_tytulu
        inc si              ;przesun sie na nastepny
        stosw               ;wstaw slowo: al-znak ah-tlo
        jmp @@wypisz_tytul
@@koniec_tytulu:
        ret
ekran_poczatkowy endp