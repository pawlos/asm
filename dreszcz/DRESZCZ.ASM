JUMPS
STOSIK SEGMENT STACK 'STACK'
 db 100 dup(?)
STOSIK ENDS
;===============================================================
ASSUME cs:CODE

include  D:\macro.zbr
wypisz MACRO co
       mov   dl,co
       mov   ah,02h
       int   21h
ENDM
set_   MACRO  x,y,strona
      mov    ah,02h
      mov    bh,strona
      mov    dh,y
      mov    dl,x
      int    10h
ENDM

CODE SEGMENT
;==========================  DANE ==============================
menu    db  13,10,9,9,9,9,' v.0.96  ',13,10
        db  9,9,9,'P…ƒ-GRA         P…ƒ-OPOWIE†',13,10,13,10,13,10
        db  9,9,9,9,'1.Rozpocz‹cie gry.',13,10
        db  9,9,9,'        2.O grze(Wane).',13,10
        db  9,9,9,9,'3.Wyjcie.',13,10
        db  'Podaj wybŽr: $'

txt_end db 'DRESZCZ v.0.96',13,10
        db '        by Paul',13,10
        db 'FREEWARE',13,10,'$'

f               db  '001.dat',0
file_name       db  '001.dat',0
dir             db  'teksty',0
dir2            db  'teksty',0
root            db  '..',0
error_msg       db  13,10,'Brak pliku $';lub katalogu',13,0
;                db  'Sprawd‘ w pliku spis_p.txt czy masz wszystkie pliki.',13,10,'$'
handle          dw  ?
wytrzymalosc    db  21
zrecznosc       db  11
szczescie       db  9
speed           dw  28000
info_file       db  'info.dat',0
logo_file       db  'dreszcz.log',0
end_logo_file   db  'end.log',0
win_txt         db  13,10,'WygraŒes!!',13,10,'$'
lose_txt        db  13,10,13,10,9,9,9,9,'  Niestety przegraŒes.',13,10
                db  9,9,9,'Twoja przygoda koczy si‹ w tym miejscu.',13,10
                db  9,9,9,'   ‡ycz‹ powodzenia nast‹pnym razem.',13,10,13,10
                db  9,9,9,' NACI†NIJ ABY POWR…CI DO MENU Gƒ…WNEGO  ',13,10,'$'
liczba       db ?
zrecznosc_wroga db ?
wytrzymalosc_wroga      db ?
zloto           db 0
dos             db 13,10,'DostaŒes!$'
ok_cios         db 13,10,'PotwŽr oberwaŒ!$'
grubas_hit      db 13,10,'Grubas oberwaŒ!$'
grubas          db 13,10,'Nie udaŒo si‹!$'
straciles       db 13,10,'StraciŒe $'
wszystko        db ' wszystko!$'
stawka_txt          db 13,10,'Stawka: $'
razy            db ' razy$'
zly_hit         db 13,10,'ZŒy trafiŒ: $'
you_hit         db 13,10,'Ty pocelowaŒe: $'
wygrales_gold   db 13,10,'WygraŒe $'
zly_win         db 13,10,'ZƒY wygraŒ!$'
zly_gold        db 10
you_win         db 13,10,'Zwyci‹yŒe!$'
jasnosc         db 63
stawka          db 0
liczba_zlych    db 3
liczba_zlych_w_grze  db 3
                ;przedmioty
kody                           db 0
komnata_000                    db 0
komnata_001                    db 0     ;komnata z pomarszczonym stworkiem
tajne_przejscie                db 0     ;tajne przejscie zawalone glazem
komnata_002                    db 0     ;OGRE i SCHOWEK
komnata_003                    db 0   ;MINOTAUR I 2 WYJSCIA
komnata_004                    db 0   ;GRUBASY
tajne_przejscie_02             db 0   ;tajne przejscie dla komnaty z GRUBASAMI
komnata_005                    db 0   ;TROLL
komnata_006                    db 0   ;KRASNOLUDY
komnata_007                    db 0   ;SWIATYNIA
komnata_008                    db 0   ;Komnata z GIGANTEM
komnata_009                    db 0   ;komnata z GARAZANEM
komnata_010                    db 0   ;komnata ze ZƒYMI
klucz_045                      db 0
klucz_012                      db 0
klucz_070                      db 0
klucz_122                      db 0
klucz_093                      db 0
pek_kluczy                     db 0
liczba_przeplyniec             db 0
kierunek                       db 0
inne_wejscie                   db 0
lina                           db 0
skalp                          db 0
flaszka                        db 0
kosc_potwora                   db 0
sloj                           db 0
blaszany_motyl                 db 0
wlocznia                       db 0
miecz                          db 0
helm                           db 0
kosciany_kordelas              db 0
tarcza                         db 0
mlot                           db 0
el_niew                        db 0
zaczarowana_woda               db 0
siec                           db 0
woda_z_jeziora                 db 0
szmaragd                       db 0
ognista                        db 0
pal                            db 0
zracy_plyn                     db 0
smok                           db 0
GIGANT                         db 0  ;czy gracza przyslal GIGANT
haslo                          db 0  ;haslo od goblina
;zmienne i stale potrzebne do informacji o graczu
list_txt    db 'LISTA EKWIPUNKU',13,10,'$'
kluczyk_122 db 'KLUCZ Z NUMEREM 122$'
kluczyk_045 db 'KLUCZ Z NUMEREM  45$'
kluczyk_012 db 'KLUCZ Z NUMEREM  12$'
kluczyk_070 db 'KLUCZ Z NUMEREM  70$'
kluczyk_093 db 'KLUCZ Z NUMEREM  93$'
linka       db 'LINA Z HAKIEM$'
flacha      db 'PUSTA FLASZKA$'
wloczenka   db 'Wƒ…CZNIA$'
sloik       db 'Sƒ…J WSZYSTKO‡ERC…W$'
kosc        db 'KO† POTWORA$'
motyl       db 'BLASZANY BOTYL$'
skalpik     db 'SKALP WILKOƒAKA$'
mieczyk     db 'MIECZ$'
kordelas    db 'KO†CIANY KORDELAS$'
tarczyca    db 'TARCZA$'
mlotek      db 'MƒOT GOBLIN…W$'
helmik      db 'HEƒM$'
eliksir_nie db 'ELIKSIR NIEWIDZILNO†CI$'
zaczar_woda db 'ZACZAROWANA WODA$'
siecka      db 'SIE$'
w_z_j       db 'WODA Z JEZIORA$'
dar         db 'SZMARAGD$'
ognistakula db 'OGNISTA KULA$'
palik       db 'DREWNIANY PAL$'
plyn_zracy  db '‡R€CY PƒYN$'
smoczek     db 'SMOK$'
pek         db 'P‚K KLUCZY$'
ch_postaci  db 'CHARAKTERYSTYKA POSTACI$'
sila        db 'WYTRZYMAƒO†:  $'
luck        db 'SZCZ‚SZCIE:    $'
zrecz       db 'ZR‚CZNO†:     $'
gold        db 'ZƒOTO:         $'
gold_end    db ' szt. zŒotych monet.$'
;=============================================================

Start:
        mov     ax,0003h
        int     10h             ;       wyczyszczenie_ekranu
        set_pal 7,0,0,0        ;macro ustawiajacy kolor zielony
;narysuj        logo
       push     cs
       pop      ds
       lea      dx,logo_file
       mov     ah,3dh
       mov     al,0
       int     21h
       jc      ERROR
       mov     handle,ax
       mov     ah,3fh
       mov     bx,handle
       push    cs
       pop     ds
       lea     dx,info_buf
       mov     cx,565
       int     21h
       mov     ah,3eh
       mov     bx,handle
       int     21h
       push    cs
       pop     ds
       lea     si,info_buf
       mov     cx,565
jeszcze_raz:
       lodsb
       add   al,5
       mov   dl,al
       mov   ah,02h
       int   21h
loop   jeszcze_raz
       call        polskie_znaki
        push    cs              ;\
        pop     ds              ; \
        lea     dx,menu         ;  >wypisanie menu
        mov     ah,09h          ; /
        int     21h             ;/
        mov    cx,63
        mov    bl,0
set_up:
        push   cx
        set_pal 7,0,bl,0
        mov  ah,86h
        mov  cx,0
        mov  dx,20000
        int  15h
        pop  cx
        inc  bl
loop    set_up
odczytuj:
        mov     ah,10h          ;odczyt znaku
        int     16h
;       mov     ah,86h          ;\
;       mov     cx,0            ;  pusta petla
;       mov     dx,6000         ;       opozniajaca
        int     15h             ;/
        cmp     al,'3'          ;jesli nacisnieto 3 to
        je      QUIT            ;       wyjdz
        cmp     al,'2'          ;jesli 2 to
        je      info            ;      info o grze!
        cmp     al,'1'          ;jesli 1 to
        je      r_game          ;       rozpocznik gre
        cmp     al,'G'          ;jak rowne to kody
        je      cody
        jmp     odczytuj           ;jesi inny przycisk to od nowa
QUIT:
        mov     cx,63
set_quit:
        push cx
        set_pal  7,0,bl,0
        mov     ah,86h
        mov     cx,0
        mov     dx,20000
        int     15h
        dec     bl
        pop     cx
loop    set_quit
        set_pal 7,40,40,40
        mov     ax,0003h        ;wyczyszczenie ekranu
        int     10h             ;
WYJSCIE:
        pisz_21h txt_end
        set_pal 7,40,40,40
        kopiuj_lancuchy root,dir,2
        call    zmien_dir
        mov     ax,4c00h        ;wyjscie do dos'a
        int     21h             ;


r_game          PROC
        mov     ax,0003h        ;wyczysc ekran
        int     10h             ;
        set_pal 7,0,63,0        ;ustaw na kolor zielony
        call    polskie_znaki
        call    zmien_dir       ;zmien katalog
        call    zmienne
gra:
        call    open            ;otworz plik
        call    odczyt          ;odczytaj dane do bufora
        push    cs              ;\
        pop     ds              ; >ustaw sie na bufor
        lea     si,tekst_bufor  ;/
pisz:
        lodsb                   ;odczytaj bajt
        add     al,5            ;dodaj 5(odkoduj)
        cmp     al,232          ;porownaj z è
        je      koniec_tekstu   ;jesli rowne koniec tekstu
        cmp     al,235          ;porownaj z ë
        je      walka
        cmp     al,236          ;porownaj z ì
        je      zmiana_wskaznikow
        cmp     al,234          ;porownaj z ê
        je      kasa_dla_nas
        cmp     al,238          ;porownaj z î
        je      SPRAWDZ_CZY_JUZ_TU_BYLES
        cmp     al,239          ;porownaj z ï
        je      ZOSTAW_DRZWI_OTWARTE
        cmp     al,224          ;porownaj z à
        je      Nowy_przedmiot
        cmp     al,244          ;porownaj z ô
        je      sprawdz_czy_masz_przedmiot
        cmp     al,247          ;porownaj z ÷
        je      SSS
        cmp     al,248
        je      przeplyniecie   ;porownaj z ø
        cmp     al,246
        je      ile_razy        ;porownaj z ö
        cmp     al,242          ;porownaj z ò
        je      grubasy
        mov     dl,al           ;\
        mov     ah,02h          ; >wypisz odczytany bajt
        int     21h             ;/
        mov     ah,86h          ;\
        mov     cx,0            ; |odczekaj chwile
        mov     dx,speed        ; | (12000)
        int     15h             ;/
        mov     ah,01h          ;\
        int     16h             ; sprawdz bufor klawiatury
        jz      nie_ma_znakow
        cmp     al,'['          ;porownaj znak z '['
        je      speed_down      ;jak rowne speed down
        cmp     al,']'          ;porownaj z ']'
        je      speed_up        ;jak rowne to speed up
no_speed:
        mov     ah,0ch          ;\
        mov     al,0            ; >wyczysc bufor
        int     21h             ;/
nie_ma_znakow:
        jmp     pisz            ;od nowa
koniec_tekstu:
        call    close           ;zamknij plik
        mov     ah,0ch          ;\
        mov     al,0            ; >wyczysc bufor
        int     21h             ;/
        push    cs              ;\
        pop     es              ; >ustaw sie na zmienna file_name
        lea     di,file_name    ;/
new_file:
        lodsb                   ;odczytaj bajt
        add     al,5            ;odkoduj
        cmp     al,231          ;porownaj z 'ç'
        jne     bez_wyboru      ;jak nie rowne to tylko jeden plik do wyboru
czek:
                                ;jesli program tu doszedl tz. ze trzeba
                                ;wybierac
        mov     ah,07h          ;czekaj
        int     21h             ;   na znak bez ^PAUSE/BREAK
        cmp     al,27           ;Porownaj z ESC
        je      Przygotuj_sie           ;jak rowne to wyjdz do menu
        mov     bl,al           ;niech bl=kod klawisza
        cmp     bl,'1'          ;porownaj bl='1'
        jne     dalej           ;jesli rowne to znalezlismy plik do otwarcia
        jmp     bez_wyboru
dalej:
        cmp     bl,'2'          ;porownaj bl='2'
        jne     dalej_1         ;jesli rowne to znalezlismy plik to otwarcia
        add     si,8            ;dodaj do si 8
        jmp     bez_wyboru
dalej_1:
        cmp     bl,'3'          ;\
        jne     dalej_2         ; >jak wyzej
        add     si,16           ;/
        jmp     bez_wyboru
dalej_2:
        cmp     bl,'4'
        jne     dalej_3
        add     si,24            ;\
        jmp     bez_wyboru
dalej_3:
        cmp     bl,'5'          ; >jak wyzej
        jne     dalej_4         ;/
        add     si,32
        jmp    bez_wyboru
dalej_4:
         cmp   bl,'6'
         jne   dalej_6
         add   si,40
         jmp   bez_wyboru
dalej_6:
        cmp    bl,'l'
        jne    jasnosc_up
        jmp    informacje
jasnosc_up:
        cmp    bl,'='
        jne    jasnosc_down
        jmp    jas_up
jasnosc_down:
        cmp    bl,'-'
        jne    charakter
        jmp    jas_down
charakter:
         cmp   bl,'c'
         jne   czek
         jmp   charakterystyka_postaci
bez_wyboru:
        lodsb                   ;\
        add     al,5            ; \
        cmp     al,233          ;  przepisuje nazwe nowego pliku
        je      ok              ;  do zmiennej file_name
        stosb                   ; /
        jmp     bez_wyboru      ;/
ok:
        mov     al,0            ;dodaje zero na
        mov     es:[di+1],al    ;   koncu
        jmp     gra             ;od nowa
ENDP

zmien_dir PROC
        mov     ah,3bh          ;\
        push    cs              ; \
        pop     ds              ; procedura zmienia
        lea     dx,dir          ; katalog na podany w zm. dir
        int     21h             ; /
        jc      ERROR           ;jesli blad to skacz
        ret
ENDP

walka   PROC
;        mov  ah,86h
;        mov  cx,0
;        mov  dx,30000
;        int  15h
        lodsb
        add     al,5
        mov     zrecznosc_wroga,al
        lodsb
        add     al,5
        mov     wytrzymalosc_wroga,al
        cmp  kody,1
        je   juz_nie_walka
od_nowa:
        mov     ah,86h
        mov     cx,0
        int     15h
        mov     ah,2ch
        int     21h     ;DL=1/100 s  dla gracza
        cmp     dl,12
        ja      od_nowa
        mov     bl,dl
        add     bl,zrecznosc  ;bl=dla gracz
        push    bx
od_nowa2:
        mov     ah,86h
        mov     cx,0
        int     15h
        mov     ah,2ch          ;bl=player
        int     21h             ;dl=potwor
        cmp     dl,12
        ja      od_nowa2
        add     dl,zrecznosc_wroga
        pop     bx
        cmp     bl,dl
        jb      k_win
        cmp     bl,dl
        ja      p_win
        jmp     od_nowa

p_win:
        pisz_21h ok_cios
        sub     wytrzymalosc_wroga,2
        cmp     wytrzymalosc_wroga,0
        jle     juz_nie_walka
        jmp     jeszcze_walka
juz_nie_walka:
        pisz_21h win_txt
        jmp     Pisz

jeszcze_walka:
        jmp     od_nowa

k_win:
        pisz_21h dos
        mov     cx,63
        mov     bl,0
petla:
        set_pal 7,bl,0,0
        set_pal 0,bl,0,0
        push    cx
        mov     ah,86h
        mov     cx,0
        mov     dx,3500
        int     15h
        pop     cx
        inc     bl
loop    petla
        set_pal 7,0,63,0
        set_pal 0,0,0,0
        mov     ah,2
        sub     wytrzymalosc,ah
        cmp     wytrzymalosc,0
        jle     juz_nie_walka2
        jmp     jeszcze_walka

juz_nie_walka2:
        mov     ax,0003h
        int     10h
        call    polskie_znaki
        set_pal 7,63,0,0
        pisz_21h lose_txt
        mov     ah,0ch
        mov     al,0
        int     21h
        mov     ah,07h
        int     21h
        call    przygotuj_sie
        jmp     Start
ENDP

kasa_dla_nas    PROC
        inc     cs:[zloto]
        jmp     Pisz
ENDP

ERROR   PROC                    ;\
        push    cs              ; \
        pop     ds              ;  \
        lea     dx,error_msg    ;   >proc obslugi bledow
        mov     ah,09h          ;  /
        int     21h             ; /
        push    cs
        pop     ds
        lea     si,file_name
        mov     al,13
        mov     ds:[si+7],al
        mov     al,10
        mov     ds:[si+8],al
        mov     al,'$'
        mov     ds:[si+9],al
        push    cs
        pop     ds
        lea     dx,file_name
        mov     ah,09h
        int     21h
        jmp     WYJSCIE         ;/
ENDP

OPEN    PROC                    ;\
        push    cs              ; \
        pop     ds              ;  \
        lea     dx,file_name    ;   >otwiera plik w zmm. file_name
        mov     ah,3dh          ;  /
        mov     al,0            ; /
        int     21h             ;/
        jc      ERROR           ;obsluguje bledy
        mov     handle,ax       ;przepisuje uchwyt pliku do zmm. handle
        ret

ENDP

CLOSE   PROC                    ;\
        mov     ah,3eh          ; \
                                ;  >zamyka plik
        mov     bx,handle       ; /
        int     21h             ;/
        ret
ENDP

ODCZYT  PROC
        mov     ah,3fh          ;\
        mov     bx,handle       ; \
        push    cs              ;  \
        pop     ds              ;   \
        lea     dx,tekst_bufor  ;    >odczytuje 3000 (?) bajtow z pliku ktory
                                ;    >jest otwarty
        mov     cx,3000         ;  /
        int     21h             ; /
        ret                     ;/
ENDP

info    PROC
        mov     ax,0003h        ;tryb tekstowy wyczyszczenie
        int     10h             ;  ekranu
        set_pal 7,0,63,0        ;ustaw na kolor zielony
        call    polskie_znaki
        mov     ah,3dh          ;\
        push    cs              ; \
        pop     ds              ;  \
        lea     dx,info_file    ;   \
        int     21h             ;    \
        mov     bx,ax           ;     \
        mov     ah,3fh          ;      otwarcie,odczyt
        push    cs              ;       zamkniecie pliku
        pop     ds              ;      /
        lea     dx,info_buf     ;    /
        mov     cx,929          ;   /
        int     21h             ;  /
        mov     ah,3eh          ; /
        int     21h             ;/
        push    cs              ;\
        pop     ds              ; \
        lea     si,info_buf     ;  \
        push    cs              ;   \
        pop     es              ;   \
        lea     di,info_buf     ;   \
odkoduj:                        ;   \
        lodsb                   ;   \
        add     al,5            ;   odkodowanie i wypisanie infa
        cmp     al,233          ;   /
        je      zakoncz         ;   /
        mov     dl,al           ;   /
        mov     ah,02h          ;  /
        int     21h             ; /
        jmp     odkoduj         ;/
zakoncz:
        mov     ah,0ch
        mov     al,0
        int     21h
        mov     ah,08h          ;pocz na klawisz
        int     21h
        jmp     Start           ;do MENU
ENDP


Przygotuj_sie   PROC
        kopiuj_lancuchy root,dir,2
        call zmien_dir
        kopiuj_lancuchy dir2,dir,6
        kopiuj_lancuchy f,file_name,7
        jmp     Start
ENDP

zmiana_wskaznikow       PROC
        lodsb           ;odczytaj bajt =co bedzie modyfikowane
        add     al,5
        cmp     al,'w'  ;czy wytrzymalosc do dolu
        je      w_down
        cmp     al,'z'  ;czy zrecznosc do dolu
        je      z_down
        cmp     al,'s'  ;czy szczescie do dolu
        je      s_down
        cmp     al,'W'  ;czy wytrzymalosc do gory
        je      W_up
        cmp     al,'Z'  ;czy zreczcznosc do gory
        je      Z_up
        cmp     al,'S'  ;czy szczescie do gory
        je      S_up

w_down:
        dec     wytrzymalosc
        cmp     wytrzymalosc,0
        jnbe    wytrzymalosc_ok
        call    juz_nie_walka2
wytrzymalosc_ok:
        jmp     Pisz
z_down:
        dec     zrecznosc
        jmp     Pisz
s_down:
        dec     szczescie
        jmp     Pisz
w_up:
        inc     wytrzymalosc
        jmp     Pisz
z_up:
        inc zrecznosc
        jmp     Pisz
s_up:
        inc     szczescie
        jmp     Pisz
ENDP

SPRAWDZ_CZY_JUZ_TU_BYLES        PROC
        lodsb
        add   al,5
        cmp   al,6
        jne   moze_nastepna_001         ;\
        mov   bl,komnata_000            ; komnata
        cmp   bl,0                      ;   z
        je   nie_byles_000              ; ORKIEM
        call   wiec_juz_byles           ;/
nie_byles_000:
        call  odczytaj_plik
        jmp   gra
moze_nastepna_001:
        cmp   al,7
        jne   moze_nastepna_002
        mov   bl,komnata_001            ;komnata z pomarszczonym stworkiem
        cmp   bl,0
        je    nie_byles_000
        call  wiec_juz_byles
        jmp   nie_byles_000
moze_nastepna_002:
        cmp   al,8
        jne   moze_nastepna_003
        mov   bl,tajne_przejscie        ;tajne przejscie dla komnaty_001
        cmp   bl,0
        je    nie_byles_000
        call  wiec_juz_byles
        jmp   nie_byles_000
moze_nastepna_003:
        cmp   al,9
        jne   moze_nastepna_004
        mov   bl,komnata_002            ;z OGRE I SCHOWKIEM
        cmp   bl,0
        je    nie_byles_000
        call  wiec_juz_byles
        jmp   nie_byles_000
moze_nastepna_004:
        cmp   al,10
        jne   moze_nastepna_005
        mov   bl,komnata_003            ;KOMNATA Z MINOTAUREM I 2 DZWIAMI
        cmp   bl,0
        je    nie_byles_000
        call  wiec_juz_byles
        jmp   nie_byles_000
moze_nastepna_005:
        cmp   al,11
        jne   moze_nastepna_006
        mov   bl,komnata_004            ;komnata ze znikajacymi grubasami
        cmp   bl,0
        je    nie_byles_000
        call  wiec_juz_byles
        jmp   nie_byles_000
moze_nastepna_006:
        cmp   al,12
        jne   moze_nastepna_007
        mov   bl,tajne_przejscie_02     ;tajne przejscie w komnacie z GRUBASAMI
        cmp   bl,0
        je    nie_byles_000
        call  wiec_juz_byles
        jmp   nie_byles_000
moze_nastepna_007:
        cmp   al,13
        jne   moze_nastepna_008
        mov   bl,komnata_005    ;KOMNATA Z TROLLEM I ZBROJOWNIA
        cmp   bl,0
        je    nie_byles_000
        call  wiec_juz_byles
        jmp   nie_byles_000
moze_nastepna_008:
        cmp   al,14
        jne   moze_nastepna_009
        mov   bl,komnata_006    ;komnata z KRASNOLUDAMI
        cmp   bl,0
        je    nie_byles_000
        call  wiec_juz_byles
        jmp   nie_byles_000
moze_nastepna_009:
        cmp   al,15
        jne   moze_nastepna_010
        mov   bl,komnata_007
        cmp   bl,0
        je    nie_byles_000
        call  wiec_juz_byles
        jmp   nie_byles_000
moze_nastepna_010:
        cmp   al,16
        jne   moze_nastepna_011
        mov   bl,komnata_008    ;komnata z GIGANTEM
        cmp   bl,0
        je    nie_byles_000
        call  wiec_juz_byles
        jmp   nie_byles_000
moze_nastepna_011:
        cmp   al,17
        jne   moze_nastepna_012
        mov   bl,komnata_009    ;komnata z GARAZANEM
        cmp   bl,0
        je    nie_byles_000
        call  wiec_juz_byles
        jmp   nie_byles_000
moze_nastepna_012:
        cmp   al,18
        jne   moze_nastepna_013
        mov   bl,komnata_010    ;komnata ze Zlymi
        cmp   bl,0
        je    nie_byles_000
        call  wiec_juz_byles
        jmp   nie_byles_000
moze_nastepna_013:
        jmp   gra
wiec_juz_byles:
        add     si,8
        ret

odczytaj_plik:
        push cs
        pop  es
        lea  di,file_name
here:
        lodsb
        add   al,5
        cmp   al,232
        je    koniec_pliku
        mov   es:[di],al
        inc   di
loop    here
koniec_pliku:
        mov   al,0
        mov   es:[di+1],al
ret

ENDP

ZOSTAW_DRZWI_OTWARTE    PROC
        lodsb                ;odczytaj bajt=nr. komnaty
        add   al,5           ;odkoduj go
        cmp   al,6                  ;\
        jne   inna_001              ; \
        mov   bl,1                  ;  z ORKIEM
        mov   komnata_000,bl        ; /
        jmp   Pisz                  ;/
inna_001:
        cmp   al,7
        jne   inna_002
        mov   bl,1
        mov   komnata_001,bl            ;komnata ze stworkiem
        jmp   Pisz
inna_002:
        cmp   al,8
        jne   inna_003
        mov   bl,1
        mov   tajne_przejscie,bl        ;tajne przejscie zawalone glazem
        jmp   Pisz
inna_003:
        cmp   al,9
        jne   inna_004
        mov   bl,1
        mov   komnata_002,bl    ;OGRE I SCHOWEK
        jmp   Pisz
inna_004:
        cmp   al,10
        jne   inna_005
        mov   bl,1
        mov   komnata_003,bl    ;MINOTAUR I 2 WYJSCIA
        jmp   Pisz
inna_005:
        cmp   al,11
        jne   inna_006
        mov   bl,1
        mov   komnata_004,bl    ;komnata z GRUBASAMI
        jmp   Pisz
inna_006:
        cmp   al,12
        jne   inna_007
        mov   bl,1
        mov   tajne_przejscie_02,bl
        jmp   Pisz
inna_007:
        cmp   al,13
        jne   inna_008
        mov   bl,1
        mov   komnata_005,bl    ;komnata Z TROLLEM I ZBROWOJNIA
        jmp   Pisz
inna_008:
        cmp   al,14
        jne   inna_009
        mov   bl,1
        mov   komnata_006,bl    ;komnata Z KRASNOLUDAMI
        jmp   Pisz
inna_009:
        cmp   al,15
        jne   inna_010          ;swiatynia
        mov   bl,1
        mov   komnata_007,bl
        jmp   Pisz
inna_010:
        cmp   al,16
        jne   inna_011
        mov   bl,1
        mov   komnata_008,bl    ;GIGANT
        jmp   Pisz
inna_011:
        cmp   al,17
        jne   inna_012
        mov   bl,1
        mov   komnata_009,bl    ;GARAZAN
        jmp   Pisz
inna_012:
        cmp   al,18
        jne   inna_013
        mov   bl,1
        mov   komnata_010,bl    ;ZLE
        jmp   pisz
inna_013:
        jmp   Pisz
ENDP

Nowy_przedmiot  PROC
       lodsb
       add   al,5
       cmp   al,6
       jne   inny_przedmiot_001
       mov   al,45
       mov   klucz_045,al
       jmp   Pisz
inny_przedmiot_001:
       cmp   al,7
       jne   inny_przedmiot_002
       mov   al,1
       mov   pek_kluczy,al
       jmp   Pisz
inny_przedmiot_002:
       cmp   al,8
       jne   inny_przedmiot_003
       mov   al,12
       mov   klucz_012,al
       jmp   Pisz
inny_przedmiot_003:
       cmp   al,9
       jne   inny_przedmiot_004
       mov   al,70
       mov   klucz_070,al
       jmp   Pisz
inny_przedmiot_004:
       cmp   al,10
       jne   inny_przedmiot_005
       mov   al,1
       mov   lina,al    ;ognioodporna lina z hakiem
       jmp   Pisz
inny_przedmiot_005:
       cmp   al,11
       jne   inny_przedmiot_006
       mov   al,1
       mov   skalp,al   ;skalp WILKOLAKA
       jmp   Pisz
inny_przedmiot_006:
       cmp   al,12
       jne   inny_przedmiot_007
       mov   al,1
       mov   flaszka,al ;pusta omszala flasza
       jmp   Pisz
inny_przedmiot_007:
       cmp  al,13
       jne  inny_przedmiot_008
       mov  al,1
       mov  kosc_potwora,al     ;kosc potwora
       jmp  Pisz
inny_przedmiot_008:
       cmp  al,14
       jne  inny_przedmiot_009
       mov  al,1
       mov  sloj,al             ;sloj wszystkozercow
       jmp  Pisz
inny_przedmiot_009:
       cmp  al,15
       jne  inny_przedmiot_010
       mov  al,1
       mov  blaszany_motyl,al   ;blaszany motyl
       jmp  Pisz
inny_przedmiot_010:
       cmp  al,16
       jne  inny_przedmiot_011
       mov  al,1
       mov  wlocznia,al         ;wlocznia
       jmp  Pisz
inny_przedmiot_011:
       cmp  al,17
       jne  inny_przedmiot_012
       mov  al,122
       mov  klucz_122,al        ;klucz_122
       jmp  Pisz
inny_przedmiot_012:
       cmp  al,18
       jne  inny_przedmiot_013
       mov  al,1
       mov  miecz,al            ;miecz
       jmp  Pisz
inny_przedmiot_013:
       cmp  al,19
       jne  inny_przedmiot_014
       mov  al,1
       mov  kosciany_kordelas,al        ;kosciany kordelas
       jmp  Pisz
inny_przedmiot_014:
       cmp  al,21
       jne  inny_przedmiot_015
       mov  al,1
       mov  tarcza,al           ;tarcza
       jmp  Pisz
inny_przedmiot_015:
       cmp  al,22
       jne  inny_przedmiot_016
       mov  al,1
       mov  helm,al             ;helm
       jmp  Pisz
inny_przedmiot_016:
       cmp  al,23
       jne  inny_przedmiot_017
       mov  al,1
       mov  mlot,al             ;mlot
       jmp  Pisz
inny_przedmiot_017:
       cmp  al,24
       jne  inny_przedmiot_018
       mov  al,1
       mov  el_niew,al          ;eliksir niewidzialnosci
       jmp  Pisz
inny_przedmiot_018:
       cmp  al,25
       jne  inny_przedmiot_019
       mov  al,1
       mov  zaczarowana_woda,al
       jmp  Pisz
inny_przedmiot_019:
       cmp   al,26
       jne   inny_przedmiot_020
       mov   al,1
       mov   siec,al
       jmp   Pisz
inny_przedmiot_020:
       cmp   al,27
       jne   inny_przedmiot_021
       mov   al,1
       mov   woda_z_jeziora,al
       jmp   Pisz
inny_przedmiot_021:
       cmp   al,28
       jne   inny_przedmiot_022
       mov   al,1
       mov   szmaragd,al
       jmp   Pisz
inny_przedmiot_022:
       cmp   al,29
       jne   inny_przedmiot_023
       mov   al,1
       mov   ognista,al
       jmp   Pisz
inny_przedmiot_023:
       cmp   al,30
       jne   inny_przedmiot_024
       mov   al,1
       mov   pal,al
       mov   zracy_plyn,al
       jmp   Pisz
inny_przedmiot_024:
       cmp   al,31
       jne   inny_przedmiot_025
       mov   al,1
       mov   smok,al
       jmp   Pisz
inny_przedmiot_025:
       cmp   al,32
       jne   inny_przedmiot_026
       mov   al,1
       mov   klucz_093,al
       jmp   Pisz
inny_przedmiot_026:
       jmp   Pisz
ENDP

sprawdz_czy_masz_przedmiot        PROC
       lodsb
       add   al,5
       cmp   al,6
       jne   nastepny_001
       cmp   helm,1
       jne   koniec_testu
       add   Wytrzymalosc,3
       jmp   koniec_testu
nastepny_001:
       cmp    al,7
       jne    nastepny_002
       cmp    flaszka,1
       je     mam
       add    si,8
mam:
       call   odczytaj_plik
       jmp    Gra
nastepny_002:
       cmp    al,8
       jne    nastepny_003
       cmp    zaczarowana_woda,1
       jne    nie_mam_wody
       mov    al,0
       mov    zaczarowana_woda,al
       jmp    Pisz
nie_mam_wody:
       add    si,47
       jmp    Pisz
nastepny_003:
        cmp   al,9
        jne   nastepny_004
        cmp   lina,1
        je    lina_ok
        add   si,8
lina_ok:
        call   odczytaj_plik
        jmp    Gra
nastepny_004:
        cmp    al,10
        jne    nastepny_005
        cmp    zloto,10
        ja     zloto_ok
        add    si,8
zloto_ok:
        call  odczytaj_plik
        jmp   Gra
nastepny_005:
        cmp    al,11
        jne    nastepny_006
        sub    zloto,10
        jmp    Pisz
nastepny_006:
        cmp    al,12
        jne    nastepny_007
        cmp    zloto,0
        jne    masz_zloto
        add    si,8
masz_zloto:
        call    odczytaj_plik
        jmp     Gra
nastepny_007:
        cmp    al,13
        jne    nastepny_008
        mov    kierunek,0
        jmp    Pisz
nastepny_008:
        cmp    al,14
        jne    nastepny_009
        cmp    liczba_przeplyniec,2
        je     dwa_razy
        add    si,8
dwa_razy:
        call    odczytaj_plik
        jmp     Gra
nastepny_009:
        cmp   al,15
        jne   nastepny_010
        cmp   kierunek,0
        je    kierunek_0
        add   si,8
kierunek_0:
        call    odczytaj_plik
        jmp     Gra
nastepny_010:
        cmp   al,16
        jne   nastepny_011
        xor   bx,bx
        mov   cx,5
        mov    dx,0
losuj_w:
        push    cx
        push    bx
losuj_ww:
        mov     ah,86h
        mov     cx,0
        int     15h
        mov     ah,2ch
        int     21h
        cmp     dl,6
ja      losuj_ww
        pop     bx
        pop     cx
        add     bl,dl
        dec     cx
        cmp     cx,0
jne  losuj_w
        cmp     bl,10
        jnb     wartosc_ok
        add     si,8
wartosc_ok:
        call    odczytaj_plik
        jmp     Gra
nastepny_011:
        cmp    al,17
        jne    nastepny_012
        cmp    siec,1
        je     ok_siec
        add    si,8
ok_siec:
        call    odczytaj_plik
        jmp     Gra
nastepny_012:
         cmp  al,18
         jne  nastepny_013
         mov  al,0
         mov  lina,al
         jmp  Pisz
nastepny_013:
         cmp  al,19
         jne  nastepny_014
         mov  al,el_niew
         cmp  al,0
         jne  mam_eliksiru
         add  si,8
mam_eliksiru:
         call   odczytaj_plik
         jmp    gra
nastepny_014:
         cmp  al,20
         jne  nastepny_015
         sub  zloto,10
         jmp  Pisz
nastepny_015:
         cmp   al,21
         jne   nastepny_016
         cmp   kosc_potwora,0
         jne   koniec_t
         cmp   mlot,0
         jne   koniec_t
         cmp   tarcza,0
         jne   koniec_t
         cmp   siec,0
         jne   koniec_t
         cmp   pek_kluczy,0
         jne   koniec_t
         add   si,8
koniec_t:
         call   odczytaj_plik
         jmp    gra
nastepny_016:
         cmp  al,22
         jne  nastepny_017
         cmp  kosc_potwora,0
         jne  kosc_ok
         add  si,8
kosc_ok:
         call   odczytaj_plik
         jmp    gra
nastepny_017:
         cmp  al,23
         jne  nastepny_018
         cmp  mlot,0
         jne  mlot_ok
         add  si,8
mlot_ok:
         call   odczytaj_plik
         jmp    gra
nastepny_018:
         cmp  al,24
         jne  nastepny_019
         cmp  tarcza,0
         jne  tarcza_ok
         add  si,8
tarcza_ok:
         call   odczytaj_plik
         jmp    gra
nastepny_019:
         cmp  al,25
         jne  nastepny_020
         cmp  siec,0
         jne  siec_ok
         add  si,8
siec_ok:
         call   odczytaj_plik
         jmp    gra
nastepny_020:
         cmp  al,26
         jne  nastepny_021
         cmp  pek_kluczy,0
         jne  klucze_ok
         add  si,8
klucze_ok:
         call   odczytaj_plik
         jmp    gra
nastepny_021:
         cmp   al,27
         jne   nastepny_022
         cmp   blaszany_motyl,0
         jne   ok_przedmioty
         cmp   pal,0
         jne   ok_przedmioty
         cmp   szmaragd,0
         jne   ok_przedmioty
         add   si,8
ok_przedmioty:
         call odczytaj_plik
         jmp  gra
nastepny_022:
         cmp  al,28
         jne  nastepny_023
         cmp  blaszany_motyl,0
         jne  ok_motyl
         add  si,8
ok_motyl:
          call odczytaj_plik
          jmp  Gra
nastepny_023:
         cmp   al,29
         jne   nastepny_024
         cmp   szmaragd,0
         jne   ok_szmaragd
         add   si,8
ok_szmaragd:
         call  odczytaj_plik
         jmp   gra
nastepny_024:
         cmp   al,30
         jne   nastepny_025
         cmp   pal,0
         jne   ok_pal
         add   si,8
ok_pal:
         call odczytaj_plik
         jmp  Gra
nastepny_025:
         cmp  al,31
         jne  nastepny_026
         cmp  zracy_plyn,0
         je   nie_ma_plynu
         add  si,8
nie_ma_plynu:
         cmp  sloj,0    ;sloj wszystkorzercow
         je   nie_ma_sloju
         add  si,8
nie_ma_sloju:
         call  odczytaj_plik
         jmp   gra
nastepny_026:
         cmp  al,32
         jne  nastepny_027
         add  zloto,10
         jmp  Pisz
nastepny_027:
         cmp  al,33
         jne  nastepny_028
         mov  motyl,0
         jmp  Pisz
nastepny_028:
         cmp  al,34
         jne nastepny_029
         mov dx,1000
         mov  ah,86h
         mov  cx,0
         int  15h
         mov  ah,2ch
         int  21h
         cmp  al,50
         jnb  nie_ma_informacji
         add  si,8
nie_ma_informacji:
         call  odczytaj_plik
         jmp   gra
nastepny_029:
         cmp   al,35
         jne   nastepny_030
         mov   GIGANT,1
nastepny_030:
         cmp   al,36
         jne   nastepny_031
         mov   bl,GIGANT
         cmp   bl,0
         jne   przyslal_GIGANT
         add   si,8
przyslal_GIGANT:
         call  odczytaj_plik
         jmp   Gra
nastepny_031:
         cmp   al,37
         jne   nastepny_032
         mov dx,1000
jjj:
         mov  ah,86h
         mov  cx,0
         int  15h
         mov  ah,2ch
         int  21h
         cmp  al,6
         ja   jjj
         cmp  al,3
         jnb  traczisz_zdrowie
         add  si,8
traczisz_zdrowie:
         call  odczytaj_plik
         jmp   gra
nastepny_032:
         cmp   al,38
         jne   nastepny_033
         mov   al,helm
         cmp   al,0
         jne   ok_helmik
         add   si,8
ok_helmik:
         call odczytaj_plik
         jmp  Gra
nastepny_033:
         cmp   al,39
         jne   nastepny_034
         mov   al,haslo
         cmp   al,0
         jne   ok_haslo
         add   si,8
ok_haslo:
         call odczytaj_plik
         jmp  Gra
nastepny_034:
         cmp  al,40
         jne  nastepny_035
         jmp  juz_nie_walka2
nastepny_035:
         cmp  al,41
         jne  nastepny_036
         cmp  woda_z_jeziora,0
         jne  ok_woda
         add  si,8
ok_woda:
         call odczytaj_plik
         jmp  Gra
nastepny_036:
         cmp  al,42
         jne  nastepny_037
         mov  dx,1000
sprawdzaj:
         mov    ah,86h
         mov    cx,0
         int    15h
         mov    ah,2ch
         int    21h
         cmp    dl,6
         ja     sprawdzaj
         cmp    dl,3
         jna    ok_bron
         add    si,8
ok_bron:
         call   odczytaj_plik
         jmp    gra
nastepny_037:
         cmp  al,43
         jne  nastepny_038
         mov  bl,cs:[wytrzymalosc]
         cmp  bl,18
         jb   za_malo
         mov  bl,cs:[zrecznosc]
         cmp  bl,9
         jb   za_malo
         add  si,8
za_malo:
         call  odczytaj_plik
         jmp   Gra
nastepny_038:
         cmp  al,44
         jne  nastepny_039
         mov  dx,1000
czy_sie_uda:
         mov    ah,86h
         mov    cx,0
         int    15h
         mov    ah,2ch
         int    21h
         cmp    dl,6
         ja     czy_sie_uda
         cmp    dl,2
         jnb    skok_ok
         add    si,8
skok_ok:
         call   odczytaj_plik
         jmp    gra
nastepny_039:
         cmp  al,45
         jne  nastepny_040
         mov  al,szmaragd
         cmp  al,0
         jne  nie_ma_daru
         add  si,8
nie_ma_daru:
         call   odczytaj_plik
         jmp    Gra
nastepny_040:
         cmp   al,46
         jne   nastepny_041
         cmp   zloto,13
         jnb   ok_13
         add   si,8
ok_13:
         call   odczytaj_plik
         jmp    Gra
nastepny_041:
         cmp    al,47
         jne    nastepny_042
         mov    al,0
         mov    pal,al
         jmp    Pisz
nastepny_042:
         cmp  al,48
         jne  nastepny_043
         mov  al,1
         mov  smok,al
         mov  al,0
         mov  pal,al
         jmp  pisz
nastepny_043:
         cmp  al,49
         jne  nastepny_044
         mov  al,zloto
         cmp  al,5
         jb   nie_masz_5
         add  si,8
nie_masz_5:
         call  odczytaj_plik
         jmp   Gra
nastepny_044:
         cmp  al,50
         jne  nastepny_045
         mov  dx,1000
losuj_ile_straciles:
         mov  ah,86h
         mov  cx,0
         int  15h
         mov  ah,2ch
         int  21h
         cmp  dl,0ch
         ja   losuj_ile_straciles
         cmp  dl,zloto
         ja   wszystko_zloto
lose:
         sub  zloto,dl
         push  dx
         pisz_21h straciles
         pop  dx
         mov  liczba,0
         mov  liczba,dl
         call wypisz_liczbe
         pisz_21h gold_end
         jmp  Pisz
wszystko_zloto:
          mov   zloto,0
          pisz_21h straciles
          pisz_21h wszystko
          jmp      Pisz
nastepny_045:
         cmp  al,51
         jne  nastepny_046
         mov  dx,1000
losuj_ile_wygrales:
         mov  ah,86h
         mov  cx,0
         int  15h
         mov  ah,2ch
         int  21h
         cmp  dl,12
         ja   losuj_ile_wygrales
win:
         add  zloto,dl
         push dx
         pisz_21h wygrales_gold
         pop  dx
         mov  liczba,0
         mov  liczba,dl
         call wypisz_liczbe
         pisz_21h gold_end
         jmp  Pisz
nastepny_046:
        cmp   al,52
        jne   nastepny_047
        mov   dx,2222
losuj_czy_wygrales:
        mov   ah,86h
        mov   cx,0
        int   15h
        mov   ah,2ch
        int   21h
        cmp   dl,12
        ja    losuj_czy_wygrales
        xor   ax,ax
        mov   al,dl
        mov   bh,2
        div   bh
        cmp   ah,1
        jne   lose
        jmp   win
nastepny_047:
         cmp  al,53
         jne  nastepny_048
         cmp  mlot,1
         je   ok_bronie_przeciwko_S_T
         cmp  ognista,1
         je   ok_bronie_przeciwko_S_T
         cmp  wlocznia,1
         je   ok_bronie_przeciwko_S_T
         add  si,8
ok_bronie_przeciwko_S_T:
         call  odczytaj_plik
         jmp   Gra
nastepny_048:
         cmp  al,54
         jne  nastepny_049
         cmp  ognista,0
         jne  ognista_ok
         add  si,8
ognista_ok:
         call odczytaj_plik
         jmp  Gra
nastepny_049:
         cmp  al,55
         jne  nastepny_050
         cmp  wlocznia,0
         jne  wlocznia_ok
         add  si,8
wlocznia_ok:
         call odczytaj_plik
         jmp  Gra
nastepny_050:
         cmp  al,56
         jne  nastepny_051
         cmp  smok,0
         jne  smok_ok
         add  si,8
smok_ok:
         call  odczytaj_plik
         jmp   Gra
nastepny_051:
         cmp  al,57
         jne  nastepny_052
         cmp  klucz_122,0
         jne  ok_1
         cmp  klucz_045,0
         jne  ok_1
         cmp  klucz_070,0
         jne  ok_1
         cmp  klucz_012,0
         jne  ok_1
         cmp  klucz_093,0
         jne  ok_1
         add  si,8
         jmp  ok_2
ok_1:
         cmp  klucz_122,0
         jne  ok_2
         cmp  klucz_045,0
         jne  ok_2
         cmp  klucz_070,0
         jne  ok_2
         cmp  klucz_012,0
         jne  ok_2
         cmp  klucz_093,0
         jne  ok_2
         add  si,8
         jmp  ok_2
ok_2:
         call   odczytaj_plik
         jmp    Gra
nastepny_052:
         cmp  al,58
         jne  nastepny_053
         cmp  klucz_122,0
         jne  ok_klucz_122
         add  si,8
         jmp  klucze_do_skarbca
ok_klucz_122:
         cmp  klucz_012,0
         jne  ok_klucz_012
         add  si,8
         jmp  klucze_do_skarbca
ok_klucz_012:
         cmp  klucz_070,0
         jne  klucze_do_skarbca
         add  si,8
klucze_do_skarbca:
         call  odczytaj_plik
         jmp   Gra
nastepny_053:
         cmp  al,59
         jne  nastepny_054
         cmp  cs:[zloto],25
         ja   zloto_25
         add  si,8
zloto_25:
          call  odczytaj_plik
          jmp   Gra
nastepny_054:
          cmp   al,60
          jne   nastepny_055
          sub   cs:[zloto],25
          mov   al,1
          mov   pal,al
          mov   zracy_plyn,al
          jmp   Pisz
nastepny_055:
          cmp   al,61
          jne   nastepny_056
          pisz_21h stawka_txt
badaj_stawke:
          mov   ah,08h
          int   21h
          cmp   al,'1'
          jne   stawka_2
          mov   stawka,1
          mov   dl,'1'
          mov   ah,02h
          int   21h
          jmp   stawka_ok
stawka_2:
          cmp   al,'2'
          jne   stawka_3
          mov   stawka,2
          mov   dl,'2'
          mov   ah,02h
          int   21h
          jmp   stawka_ok
stawka_3:
          cmp   al,'3'
          jne   stawka_4
          mov   stawka,3
          mov   dl,'3'
          mov   ah,02h
          int   21h
          jmp   stawka_ok
stawka_4:
          cmp   al,'4'
          jne   stawka_5
          mov   stawka,4
          mov   dl,'4'
          mov   ah,02h
          int   21h
          jmp   stawka_ok
stawka_5:
          cmp   al,'5'
          jne   badaj_stawke
          mov   stawka,5
          mov   dl,'5'
          mov   ah,02h
          int   21h
          jmp   stawka_ok
stawka_ok:
           mov  dx,211
losuj_ile_strzalek_trafil_gracz:
           mov  ah,86h
           mov  cx,0
           int  15h
           mov  ah,2ch
           int  21h
           cmp  dl,6
           ja   losuj_ile_strzalek_trafil_gracz
           push dx          ;ile trafil gracz
           mov  dx,1345
losuj_ile_strzalek_trafil_zly:
           mov  ah,86h
           mov  cx,0
           int  15h
           mov  ah,2ch
           int  21h
           cmp  dl,6
           ja   losuj_ile_strzalek_trafil_zly
           mov  bl,dl                         ;ile zly
           pop  dx
           cmp  bl,dl
           ja   zly_won
           cmp  bl,dl
           jb   you_won
           cmp  bl,dl
           je   stawka_ok

zly_won:
           pisz_21h zly_win
           mov  al,stawka
           add  zly_gold,al
           sub  zloto,al
           cmp  zloto,0
           jnle sytuacja_ok
           mov  cs:[zloto],0
           add  si,16
           jmp  sytuacja_ok

you_won:
           pisz_21h you_win
           mov      al,stawka
           sub      zly_gold,al
           add      zloto,al
           cmp      zly_gold,0
           jnle     sytuacja_ok
           add      si,8
           jmp      sytuacja_ok

sytuacja_ok:
           call odczytaj_plik
           jmp  Gra

nastepny_056:
           cmp  al,62   ;>
           jne  nastepny_057
           mov  cx,63
end_game:
          push  cx
          set_pal 7,0,jasnosc,0
          mov     ah,86h
          mov     cx,0
          mov     dx,40000
          int     15h
          dec     cs:[jasnosc]
          pop     cx
loop      end_game
          mov      ax,0003h
          int      10h
         mov     ah,3bh          ;\
         push    cs              ; \
         pop     ds              ; procedura zmienia
         lea     dx,root          ; katalog na podany w zm. dir
         int     21h             ; /
         jc      ERROR
         push     cs
         pop      ds
         lea      dx,end_logo_file
         mov     ah,3dh
         mov     al,0
         int     21h
         jc      ERROR
         mov     handle,ax
         mov     ah,3fh
         mov     bx,handle
         push    cs
         pop     ds
         lea     dx,info_buf
         mov     cx,563
         int     21h
         mov     ah,3eh
         mov     bx,handle
         int     21h
         push    cs
         pop     ds
         lea     si,info_buf
         mov     cx,563
jeszcze_:
         lodsb
         add   al,5
         mov   dl,al
         mov   ah,02h
         int   21h
loop   jeszcze_
         mov   cx,63
end_game_up:
         push cx
         set_pal 7,0,jasnosc,0
         mov     ah,86h
         mov     cx,0
         mov     dx,40000
         int     15h
         inc     cs:[jasnosc]
         pop     cx
loop     end_game_up
         mov     ah,08h
         int     21h
         jmp     Start

nastepny_057:
         cmp  al,63
         jne  nastepny_058
         mov  al,liczba_zlych
         cmp  al,0
         je   koniec_zlych
         dec  cs:[liczba_zlych]
koniec_zlych:
         jmp  Pisz
nastepny_058:
         cmp  al,64
         jne  nastepny_059
         cmp  liczba_zlych_w_grze,0
         jne  jeszcze_zyja
         add  si,8
jeszcze_zyja:
         call odczytaj_plik
         jmp  Gra
nastepny_059:
         cmp  al,65
         jne  nastepny_060
         mov  zly_gold,10
         jmp  Pisz
nastepny_060:
         cmp  al,66
         jne  nastepny_061
         dec  cs:[liczba_zlych_w_grze]
         jmp  Pisz
nastepny_061:
          cmp   al,67
          jne   nastepny_062
          cmp   liczba_zlych,1
          jbe   zabiles_dwoch
          add   si,8
zabiles_dwoch:
          call odczytaj_plik
          jmp  Gra
nastepny_062:
koniec_testu:
jmp           Pisz
ENDP

SSS     PROC
        mov  dx,2000
losuj:
        mov     ah,86h
        mov     cx,0
        int     15h
        mov     ah,2ch
        int     21h
        cmp     dl,12
        ja      losuj
        mov     al,szczescie
        cmp     dl,al            ;porownaj wylosowana liczbe z szczesciem.
        jbe     masz_szczescie  ;jak mniejsza/rowna to masz szczescie
        add     si,8
masz_szczescie:
        dec     szczescie
        call    odczytaj_plik
        jmp     Gra
ENDP

przeplyniecie   PROC
                mov  al,liczba_przeplyniec
                inc  al
                mov  liczba_przeplyniec,al
                jmp  pisz
ENDP

ile_razy        PROC
                mov  al,liczba_przeplyniec
                cmp  al,1
                jnz  juz_kilka
                call odczytaj_plik
                jmp  gra
juz_kilka:
                add       si,8
                call      odczytaj_plik
                jmp       gra
ENDP

zmienne         PROC
                ;ustawia wartosci poczatkowe dla zmiennych.
                ;poczatkowa wartosc:
                mov cs:[wytrzymalosc],21        ;wytrzymalosci
                mov cs:[zrecznosc],11            ;zrecznosci
                mov cs:[szczescie],7           ;szczescia
                mov cs:[zloto],0                ;zlota
                mov cs:[komnata_000],0          ;komnat ORK
                mov cs:[komnata_001],0          ;pomarszczony stwor
                mov cs:[komnata_002],0          ;OGRE
                mov cs:[komnata_003],0          ;MINOTAUR 2 WYJSCIA
                mov cs:[komnata_004],0          ;GRUBASY
                mov cs:[komnata_005],0          ;TROLL
                mov cs:[komnata_006],0          ;komnata z KRASNOLUDAMI
                mov cs:[komnata_007],0          ; SWIATYNIA
                mov cs:[komnata_008],0          ;GIGANT
                mov cs:[komnata_009],0          ;GARAZAN
                mov cs:[komnata_010],0          ;ZƒE
                mov cs:[tajne_przejscie],0      ;tajne przejscie dla komnaty_001
                mov cs:[tajne_przejscie_02],0   ;tajne przejscie dla komnaty z grubasami
                mov cs:[klucz_045],0    ;kluczy\
                mov cs:[klucz_012],0    ;kluczy/
                mov cs:[klucz_070],0    ;klucze
                mov cs:[klucz_122],0    ;klucze
                mov cs:[klucz_093],0
                mov cs:[helm],0         ;helmu
                mov cs:[pek_kluczy],0   ;peku_kluczy
                mov cs:[liczba_przeplyniec],0
                mov cs:[inne_wejscie],0       ;skala ,ktora zaslaniala
                mov cs:[lina],0         ;ognioodp. lina z hakiem
                mov cs:[skalp],0        ;skalp WILKOLAKA
                mov cs:[flaszka],0        ;pusta flaszka
                mov cs:[kosc_potwora],0
                mov cs:[sloj],0
                mov cs:[blaszany_motyl],0
                mov cs:[wlocznia],0
                mov cs:[jasnosc],63
                mov cs:[miecz],0
                mov cs:[kosciany_kordelas],0
                mov cs:[tarcza],0
                mov cs:[mlot],0
                mov cs:[el_niew],0
                mov cs:[siec],0
                mov cs:[zaczarowana_woda],0
                mov cs:[woda_z_jeziora],0
                mov cs:[szmaragd],0
                mov cs:[ognista],0
                mov cs:[pal],0
                mov cs:[zracy_plyn],0
                mov cs:[smok],0
                mov cs:[GIGANT],0       ;czy gracza przyslal GIGANT
                mov cs:[haslo],0        ;haslo z ksiegi czarow
                mov cs:[stawka],0
                mov cs:[liczba_zlych],3
                mov cs:[zly_gold],10    ;liczba_sztuk_zlota_zlych
                mov cs:[liczba_zlych_w_grze],3 ;liczba z ktorymi nie grales
                RET
ENDP

speed_down      PROC
         cmp    speed,42000
         jae    no_speed_down
         add    speed,100
no_speed_down:
         jmp   no_speed
ENDP

speed_up        PROC
          cmp   speed,14000
          jbe   no_speed_up
          sub   speed,100
no_speed_up:
          jmp   no_speed
ENDP

informacje      PROC
        mov     ah,05h
        mov     al,1
        int     10h
        mov     ah,02h
        mov     bh,1
        mov     dh,0
        mov     dl,0
        int     10h
        pisz_21h list_txt
tutaj:
        cmp    klucz_045,0
        je     nie_ma
        set_   5,3,1
        pisz_21h kluczyk_045
nie_ma:
        cmp   klucz_122,0
        je    nie_ma_000
        set_  25,3,1
        pisz_21h kluczyk_122
nie_ma_000:
        cmp    klucz_012,0
        je     nie_ma_001
        set_   45,3,1
        pisz_21h kluczyk_012
nie_ma_001:
        cmp    klucz_070,0
        je     nie_ma_002
        set_   65,3,1
        pisz_21h kluczyk_070
nie_ma_002:
        cmp    lina,0
        je     nie_ma_003
        set_   5,5,1
        pisz_21h linka
nie_ma_003:
        cmp    flaszka,0
        je     nie_ma_004
        set_   25,5,1
        pisz_21h flacha
nie_ma_004:
        cmp    wlocznia,0
        je     nie_ma_005
        set_   45,5,1
        pisz_21h wloczenka
nie_ma_005:
        cmp    sloj,0
        je     nie_ma_006
        set_   60,5,1
        pisz_21h sloik
nie_ma_006:
        cmp    kosc_potwora,0
        je     nie_ma_007
        set_   5,7,1
        pisz_21h kosc
nie_ma_007:
       cmp     blaszany_motyl,0
       je      nie_ma_008
       set_    25,7,1
       pisz_21h motyl
nie_ma_008:
       cmp     skalp,0
       je      nie_ma_009
       set_    45,7,1
       pisz_21h skalpik
nie_ma_009:
       cmp     miecz,0
       je      nie_ma_010
       set_    65,7,1
       pisz_21h mieczyk
nie_ma_010:
       cmp     kosciany_kordelas,0
       je      nie_ma_011
       set_    5,9,1
       pisz_21h kordelas
nie_ma_011:
       cmp     tarcza,0
       je      nie_ma_012
       set_    25,9,1
       pisz_21h tarczyca
nie_ma_012:
        cmp    mlot,0
        je     nie_ma_013
        set_   45,5,1
        pisz_21h mlotek
nie_ma_013:
        cmp    helm,0
        je     nie_ma_014
        set_   65,9,1
        pisz_21h helmik
nie_ma_014:
        cmp   el_niew,0
        je    nie_ma_015
        set_  1,11,1
        pisz_21h eliksir_nie
nie_ma_015:
        cmp   zaczarowana_woda,0
        je    nie_ma_016
        set_  25,11,1
        pisz_21h zaczar_woda
nie_ma_016:
        cmp    siec,0
        je     nie_ma_017
        set_   45,11,1
        pisz_21h siecka
nie_ma_017:
        cmp    woda_z_jeziora,0
        je     nie_ma_018
        set_   65,11,1
        pisz_21h w_z_j
nie_ma_018:
        cmp    szmaragd,0
        je     nie_ma_019
        set_   5,13,1
        pisz_21h dar
nie_ma_019:
        cmp    ognista,0
        je     nie_ma_020
        set_   25,13,1
        pisz_21h ognistakula
nie_ma_020:
        cmp    pal,0
        je    nie_ma_021
        set_   45,13,1
        pisz_21h palik
nie_ma_021:
        cmp    zracy_plyn,0
        je    nie_ma_022
        set_   65,13,1
        pisz_21h plyn_zracy
nie_ma_022:
        cmp    smok,0
        je     nie_ma_023
        set_   5,15,1
        pisz_21h smoczek
nie_ma_023:
        cmp    pek_kluczy,0
        je     nie_ma_024
        set_   25,15,1
        pisz_21h pek
nie_ma_024:
        cmp    klucz_093,0
        je     nie_ma_025
        set_   45,15,1
        pisz_21h kluczyk_093
nie_ma_025:
        mov    cx,63
        mov    bl,0
set:
        push  cx
        set_pal 7,bl,0,0
        mov     ah,86h
        mov     cx,0
        mov     dx,20000
        int     15h
        pop     cx
        inc      bl
loop set
        mov      ah,08h
        int      21h
        mov    cx,63
        mov    bl,63
set_end:
        push  cx
        set_pal 7,bl,0,0
        mov     ah,86h
        mov     cx,0
        mov     dx,20000
        int     15h
        pop     cx
        dec      bl
loop set_end
        mov      ah,05h
        mov      al,0
        int      10h
        set_pal  7,0,63,0
        jmp      czek
ENDP

charakterystyka_postaci PROC
        mov     ah,05h
        mov     al,2
        int     10h
        mov     ah,02h
        mov     bh,2
        mov     dh,0
        mov     dl,0
        int     10h
        set_pal     7,0,0,0
        pisz_21h    ch_postaci
        set_     1,5,2
        pisz_21h    sila
;---------------------------------------wypisanie wytrzymalosci
        mov     al,wytrzymalosc
        mov     liczba,al
        call    wypisz_liczbe
;---------------------------------------wypisanie zrecznosci]
        set_     1,9,2                  ; MACRO USTAW X,Y
        pisz_21h    zrecz               ;Wypisz tekst
        mov     al,zrecznosc            ;\
        mov     liczba,al               ; >wypisz wytrzymalosc
        call    wypisz_liczbe           ;/
;---------------------------------------wypisanie szczescia]
        set_     1,13,2                           ;\
        pisz_21h luck                             ; \
        mov     al,szczescie                      ;  >t.j.w
        mov     liczba,al                         ; /
        call    wypisz_liczbe                     ;/
;---------------------------------------wypisanie zlota]
        set_    1,17,2                            ;\
        pisz_21h gold                             ; \
        mov     al,zloto                          ;  >t.j.w
        mov     liczba,al                         ; /
        call    wypisz_liczbe                     ;/
        pisz_21h gold_end
;----------------------------------------]
        mov     bl,0
        mov    cx,63
rozjasnij:
        push  cx
        set_pal 7,bl,0,0
        mov     ah,86h
        mov     cx,0
        mov     dx,20000
        int     15h
        pop     cx
        inc    bl
loop rozjasnij
        mov     ah,08h
        int     21h
        mov     bl,63
        mov     cx,63
sciemnij:
        push  cx
        set_pal 7,bl,0,0
        mov     ah,86h
        mov     cx,0
        mov     dx,20000
        int     15h
        pop     cx
        dec    bl
loop sciemnij
        mov      ah,05h
        mov      al,0
        int      10h
        set_pal  7,0,63,0
        jmp      czek
ENDP

jas_up      PROC
        cmp     jasnosc,63
        je      end_up
        inc     jasnosc
        set_pal 7,0,jasnosc,0
end_up:
        jmp     czek
ENDP

jas_down    PROC
        cmp     jasnosc,0
        je      end_down
        dec     jasnosc
        set_pal 7,0,jasnosc,0
end_down:
          jmp   czek
ENDP

cody    PROC
        cmp  kody,0
        jne  kody_on
        mov  al,1
        mov  kody,al
        set_pal 7,0,0,0
        mov ah,86h
        mov cx,3
        mov dx,0
        int 15h
        set_pal 7,0,63,63
        jmp  odczytuj

kody_on:
        set_pal 7,63,0,63
        set_pal 0,63,63,63
        mov   al,0
        mov  kody,al
        mov  ah,86h
        mov  cx,3
        mov  dx,0
        int  15h
        set_pal 0,0,0,0
        set_pal 7,0,63,0
        jmp  odczytuj
ENDP



grubasy         PROC
losuj_ktory_grubas:
        mov     ah,86h
        mov     cx,0
        int     15h
        mov     ah,2ch
        int     21h     ;DL=1/100 s  dla gracza
        cmp     dl,6
        ja      losuj_ktory_grubas
        push    dx
losuj_czy_trafiles:
        mov     ah,86h
        mov     cx,0
        int     15h
        mov     ah,2ch
        int     21h
        cmp     dl,6
        ja      losuj_czy_trafiles
        mov     al,dl              ;czy trafiles
        pop     dx                 ;ktoregos
        cmp     al,dl
        jne     pudlo
        pisz_21h grubas_hit
        jmp      Pisz
pudlo:
        pisz_21h grubas
        jmp      Pisz
ENDP

include pl_proc.asm

include liczby.asm

info_buf        db 650 dup(?)

tekst_bufor     db   3000 dup(?)

CODE ENDS
END Start