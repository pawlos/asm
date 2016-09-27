;procedura odczytje dane na temat asteroid¢w i umieszcza je w odpowiedniej
;strukturze
odczytaj_dane_asteroidow proc
      mov ax,3d00h ;funkcja: odczyt z pliku
      push cs
      pop  ds
      lea  dx,aster_def
      int 21h         ;otworz plik
      jc  error_aster_open ;jesli blad to skacz
      mov bx,ax
      mov cx,26         ;ilosc danych do odczytania
      mov ax,seg DANE   ;\
      mov ds,ax         ; >gdzie zapisac
      lea dx,aster_maly ;/
      mov ah,3fh        ;funkcja odczytuj
      int 21h           ;wykonaj
      mov cx,38
      lea dx,aster_duzy ;gdzie zapisac
      mov ah,3fh
      int 21h           ;wykona†
      mov cx,30
      lea dx,aster_huge ;gdzie zapisac
      mov ah,3fh
      int 21h           ;wykona†
      mov ah,3eh        ;funkcja: zamknij plik
      int 21h           ;wykonaj
      ret

error_aster_open:
     pisz_21h no_aster_file
     mov ah,4ch
     int 21h

odczytaj_dane_asteroidow endp

;procedura odczytuje dane na temat leveli w grze i umieszcza je w odpowiedniej
;strukturze
odczytaj_dane_leveli proc
        mov ax,3d00h      ;funkcja: odczytaj dane
        push cs
        pop ds
        lea dx,levels_def ;gdzie nazwa pliku
        int 21h           ;wykonaj
        jc  error_level_open
        mov bx,ax            ;przepisz uchwyt
        mov ax,seg DANE      ;\
        mov ds,ax            ; >gdzie zapisac uchwyt
        lea dx,levels        ;/
        mov cx,206           ;ile danych odczytac
        mov ah,3fh           ;funkcja:odczytuj dane
        int 21h              ;wykonaj
        mov ah,3eh
        int 21h              ;zamknij plik
        ret

error_level_open:
      pisz_21h no_levels_file
      mov ah,4ch
      int 21h

odczytaj_dane_leveli endp

;procedura czytajaca z pliku stars.dat informacje na temat wspolrzednych
;gwiazdek
odczytaj_dane_gwiazdek proc
        mov ax,3d00h            ;funcja: otworz plik
        push cs
        pop  ds
        lea  dx,stars_def       ;gdzie nazwa pliku
        int  21h                ;wykonaj
        jc   error_open_stars   ;jak blad to skocz
        mov bx,ax               ;przepisz uchwyt
        mov ax,seg DANE         ;\
        mov ds,ax               ; >gdzie zapisac gwiazdki
        lea dx,star_field       ;/
        mov cx,2400             ;ile bajtow danych
        mov ah,3fh              ;funkcja: odczytaj dane
        int 21h                 ;wykonaj
        mov ah,3eh              ;funkcja: zamknij plik
        int 21h                 ;wykonaj
        ret

error_open_stars:
         pisz_21h no_stars_file
         mov ah,4ch
         int 21h


odczytaj_dane_gwiazdek endp
;procedura odczytuje historyjke z pliku stroy.dat i zapisuje ja do bufora
odczytaj_historyjke proc
         mov ax,3d00h           ;funkcja: odczytaj plik
         push cs
         pop  ds
         lea  dx,story_file     ;gdzie nazwa
         int  21h               ;wykonaj
         jc   error_story_file
         mov  bx,ax            ;uchwyt przepisz
         mov  ax,seg DANE      ;\
         mov  ds,ax            ; >gdzie zapisac dane
         lea  dx,story         ;/
         mov  cx,403           ;ile
         mov  ah,3fh           ;funkcja:odczytaj dane
         int 21h               ;wykonaj
         mov ah,3eh
         int 21h
         ret

error_story_file:
        pisz_21h no_story_file
        mov ah,4ch
        int 21h

odczytaj_historyjke endp
;procedura odczytuje font i wrzuca do bufora
odczytaj_font_computer proc
        mov ax,3d00h            ;funkcja: odczytaj plik
        push cs                 ;\
        pop  ds                 ; >gdzie nazwa
        lea  dx,font_file       ;/
        int  21h                ;wykonaj
        jc   font_error
        mov  bx,ax              ;przepisz uchwyt
        mov  ax,seg DANE        ;\
        mov  ds,ax              ; >gdzie zapisac
        lea  dx,computer_font            ;/
        mov  cx,4096            ;ile bajtow danych
        mov  ah,3fh             ;funkcja: odczytaj
        int  21h                ;wykonaj
        mov  ah,3eh             ;funkcja:zamknij plik
        int  21h                ;wykonaj
        ret

font_error:
        pisz_21h no_font_file
        mov  ah,4ch
        int  21h

odczytaj_font_computer endp
;odczytuje font dla tytulu gierki
odczytaj_font_menu proc
        mov ax,3d00h            ;funkcja: odtworz plik
        push cs                 ;\
        pop  ds                 ; >gdzie nazwa
        lea  dx,menu_font       ;/
        int  21h                ;wykonaj
        jc   menu_font_error    ;jezeli blad top skocz
        mov  bx,ax              ;przepisz uchwyt
        mov  ax,seg DANE        ;\
        mov  ds,ax              ; >gdzie zapisywac odczytane dane
        lea  dx,mini_font       ;/
        mov  cx,3072            ;ile ich odczytac
        mov  ah,3fh             ;funkcja: odczytaj
        int  21h                ;wykonaj
        mov  ah,3eh             ;zamknij plik
        int  21h                ;wykonaj
        ret
menu_font_error:
        pisz_21h no_menu_font_file
        mov ah,4ch
        int 21h

odczytaj_font_menu endp