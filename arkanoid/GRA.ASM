;szkielet programu
.386               ;tryb procesora 386
.model large
STOSIK SEGMENT STACK use16 'STACK'
 db 300h dup(?)
STOSIK ENDS
ASSUME cs:CODE
include d:\macro.zbr    ;dodaj macrodefinicje
CODE SEGMENT use16

include dane1.asm       ;dodaj plik z danymi bliskimi

Start:

include code.asm        ;dodaj plik z wlasciwym kodem gry
include fade_up.asm     ;dodaj procedure z rozjasnianiem i sciemnianiem ekranu
include xmmproc.asm     ;dodaj procedure oblsugi xms'u
include cegly.asm       ;dodaj procedure z ustawianiem kolorow cegielek
include clear.asm       ;dodaj procedure czyszczaca bufor
include boisko.asm      ;dodaj procedure rysujaca boisko
include buf2scr.asm     ;dodaj procedure przerzucajaca bufor na ekran
include paletka.asm     ;dodaj procedure rysujaca paletki
include new9h.asm       ;dodaj procedure klawiatury
include errors.asm      ;dodaj procedure z bledami
include reakcja.asm     ;dodaj procedure z reakcjami klawiszy
include porusz.asm      ;dodaj procedure z poruszeniem pilki
CODE ENDS

DATA SEGMENT use32

include dane2.asm       ;dodaj plik z danymi dalekimi

DATA ENDS
END Start               ;zacznij za slowem start