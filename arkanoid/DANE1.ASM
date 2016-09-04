;bliskie dane programu
logo_file db 'logo.dat',0
end_txt db 'Copyright 1999 LEX Corp.',13,10,'$'
xmserr1 db 'HIMEM.SYS NIE ZAINSTALOWANY',13,10,'$'
xmserr2 db 'Braklo pamieci XMS!!!',13,10,'$'
xmserr3 db 'Wystapil blad podczas przenoszenia blokow UMB',13,10,'$'
xmserr4 db 'Wystapil blad podczas wylacznaia blokow UMB',13,10,'$'
xmserr5 db 'Gate20 not disable najlepiej zresetuj comput...',13,10,'$'
xmmhelp dw 00
xmmsegm dw 00,00
xmmtab  dw 00,00
        dw 00
        dw 00,00
        dw 00
        dw 00,00
xmmhandle dw ?
pozycja_X_paletki dw 155
dlugosc_paletki dw  30
wysokosc_paletki dw 6
pozycja_X_pilki  dw 160
pozycja_Y_pilki  dw 180
przesuniecie_X   dw 1
przesuniecie_Y   dw 1
rozmiar_pilki    equ 5
file_error_txt_01 db 'Brak pliku logo.dat!',13,10,'$'
klocki_error_txt_01 db 'Blad w strukturze danych!',13,10,'$'
poz_X    dw ?
poz_Y    dw ?
ile_klockow dw ?
level_01 dw 02,0ffh,100,60,05,0ffh,120,60,05,0ffh,140,60,05,0eeh