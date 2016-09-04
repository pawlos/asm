;procedura badajaca nacisniecie klawiszy
;!!!ZROBIC ABY Z SHIFTEM BYLO PRZYSPIESZANE!!!
zareaguj PROC near
         cmp  cs:[key_tab+4bH],01          ;czy Strzalka w lewo wcisnieta
         jne  inny_02                      ;jak nie to badaj inny
         mov  ax,pozycja_X_paletki         ;niech ax zawiera pozycje paletki
         sub  ax,2                         ;odejmij od niej 2
         cmp  ax,1                         ;czy doslismy do poczatku ekranu
         jbe  inny_02                      ;jesli tak to nie zapisuj nowego polozenia
         mov  pozycja_X_paletki,ax         ;w inny wypadku zapisz ja
inny_02:
         cmp  cs:[key_tab+4dH],01          ;czy strzalka w prawo wcisnieta
         jne  inny_03                      ;jak nie to badaj inny klawisz
         mov  ax,pozycja_X_paletki         ;niech ax zawiera pozycje paletki
         add  ax,2                         ;dodaj do niej 2
         mov  dx,318                       ;niech dx zawiera 318
         sub  dx,dlugosc_paletki           ;odejmij dlugosc paletki
         cmp  ax,dx                        ;czy doslismy do konca ekranu
         ja   inny_03                      ;jesli tak to nie zmieniaj polozenia paletki
         mov  pozycja_X_paletki,ax         ;jesli nie to zapamietaj nowa pozycja
inny_03:
         ret                               ;powrot
ENDP