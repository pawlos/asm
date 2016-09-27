.386c
JUMPS
STOSIK SEGMENT STACK 'STACK'
       dw 200h dup(?)
STOSIK ENDS
ASSUME cs:CODE
       include macra.inc
CODE SEGMENT use16    ;tryb 16-bitowy
;plik niezb©dne grze
Start:
;procki odczytujace dane z plikow
       push ds
       call odczytaj_dane_asteroidow
       call odczytaj_dane_leveli
       call odczytaj_dane_gwiazdek
       call odczytaj_font_computer
       call odczytaj_font_menu
       call odczytaj_historyjke
;roszyfruj story
       call unconvert_story
;ustaw nowe przerwanie klawiatury
       call init_new_9h
;ustawia palete
       mov ax,0013h
       int 10h
       call ustaw_palete
;narysuj gwiazdki w buforze
       call clear_bufor
       call rysuj_gwiazdki
       call bufor2screen
       call pisz_litere
czek01:cmp  cs:[key_tab+1],1
       jne  czek01
;menu
_menu:
       call clear_bufor
       call rysuj_gwiazdki
       call zareaguj_w_menu
       call pisz_tytul_w_buforze
       call pisz_menu
       synch
       call bufor2screen
       mov al,zatwierdz
       cmp al,1
       jne omin_co_zrobic
       call co_zrobic_w_menu
omin_co_zrobic:
jmp    _menu
       call restore_old_9h
       mov ax,0003h
       int 10h
       pop ds
       mov ah,4ch
       int 21h
;----- end main code ------

;includy
include readfile.asm    ;odczytuje wszystkie niezbedne dane z plikow
include unstory.asm     ;rozszyfrowywuje historyjke
include pal.asm         ;procedura ustawia palete
include buf.asm         ;zawiera funkcje robiace co˜ w buforze
include new9h.asm       ;zawiera funkcje obslugujace nowe przerwanie klawiatury
include write.asm       ;procedura piszaca na ekranie
include reakc.asm       ;procedury reakcji na klawisze
include menu.asm        ;procedury menu
include dane.asm        ;dane programu
include game.asm        ;procedury dotyczace gry
include linia.asm       ;procedura rysujaca linie
include astr.asm        ;procedury dot. asteroidow

CODE ENDS
DATA SEGMENT use16
  bufor db 320*200 dup(?)
DATA ENDS
DANE SEGMENT use16
  aster_maly       dw 20 dup(?)   ;definicje wierzcholkow asteroidu malego
  aster_duzy       dw 20 dup(?)   ;definicje wierzcholkow asteroidu duzego
  aster_huge       dw 20 dup(?)   ;definicje wierzcholkow asteroidu olbrzymiego
  levels           dw 400 dup (?)     ;definicje poszczegolnych leveli
  star_field       dw 1200 dup(?) ;definicje gwiazdek na ekranie
  story            db 500  dup(?) ;miejsce na opowie˜†?!
  computer_font    db 4096 dup(?) ;miejsce na font
  mini_font        db 3072 dup(?) ;font
DANE ENDS
END Start