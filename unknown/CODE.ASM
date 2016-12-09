;gˆ¢wny kod gry(odskoki do poszczeg¢lnych procedur)
        mov  ax,0003h
        int  10h        ;wyczy˜† ekran
        call ekran_poczatkowy
        call wczytaj_pliki    ;wczytuje pliki z danymi
        lea dx,init_keyb
        call wypisz_kom
        call ustaw_nowe_int9h
        lea  dx,ok_text
        call wypisz_kom
        mov ah,86h
        mov cx,6
        mov dx,0
        int 15h
;tryb graficzny
        mov ax,0013h
        int 10h
;gˆ¢wny kod:
        call set_pal
        call clear
@@poczatek:
        call przygotuj_level    ;skopiuj potrzebny na podstawie danych o aktualnej
                                ;planszy
        mov  cs:[kolor],191
        mov  cx,cs
        lea  ebx,entering
        mov  ax,0a000h
        mov  edx,28900
        call wypisz_nazwe
        mov  cx,seg ACTUAL_MAP
        lea  ebx,tytul_mapy
        mov  ax,0a000h
        mov  edx,32100
        call wypisz_nazwe
@@czek:
        cmp cS:[key_tab+1ch],01
        jne @@czek
        mov ax,seg TABLICE
        mov ds,ax          ;ds-tablice z funkcjami
        mov ax,seg ACTUAL_MAP
        mov fs,ax
        mov ax,seg BUFOR
        mov es,ax
        mov ax,seg SKALUJ
        mov gs,ax

_main:
        cmp cS:[key_tab+01],01
        je  quit
;pobieranie klawiszy i rysowanie ekranu ,czy˜czenie bufora
        call clear_bufor         ;czy˜ci bufor na kolory sufitu i podˆogi
        call reakcja_na_klawisze ;sprawdza i podejmuje akcje w znale¾no˜ci
                                 ;od naci˜ni©tych klawiszy
        call ray_cast
        synch
        call przepisz_bufor      ;wyrzuca zawarto˜† bufora na ekran
jmp     _main
quit:
        mov  ax,0003h
        int  10h
        call usun_nowe_int9h
        lea  dx,end_text
        call wypisz_kom
        mov ax,4c00h
        int 21h         ;koniec pracy programu

wypisz_kom proc near
        mov ah,09h
        push cs
        pop  ds
        int 21h
        ret
wypisz_kom endp