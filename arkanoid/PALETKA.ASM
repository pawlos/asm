narysuj_paletke PROC near
        mov  ax,seg DATA                ;\
        mov  es,ax                      ; >es:edi wskazuje na bufor
;        mov  edi,offset logo_bufor      ;/
        sub  edi,edi
        sub  eax,eax
        mov  ax,320                     ;mamy 320 bajtow w lini
        mov  dx,wysokosc_paletki        ;dx wysokosc paletki
        mov  bx,199                     ;bx=koniec ekranu
        sub  bx,dx                      ;odejmij
        mul  bx                         ;pomnoz bx*ax
        add  ax,pozycja_X_paletki       ;dodaj pozycje X paletki
        add  edi,eax                    ;przepisz ja do bufora
        mov  al,28h                     ;rysujemy kolorem 28h=40
        mov  cx,wysokosc_paletki        ;cx=wysokosc paletki
rysuj_paletke:
        push cx                         ;odloz licznik petli
        mov  cx,dlugosc_paletki         ;do cx licznik petli wewnetrznej
rys:
        mov  es:[edi],al                ;wstaw bajt
        inc  edi                        ;zwieksz wskaznik
loop    rys                             ;powtarzaj
        add  edi,320                    ;nowa linia...
        sub  di,dlugosc_paletki        ;..-dlugosc paletki
        pop  cx                         ;pobierz licznik
loop    rysuj_paletke                   ;powtarzaj
        ret                             ;powrot
ENDP