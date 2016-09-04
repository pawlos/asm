;wlasciwy kod programu
    call xmminit                ;procedura inicjujaca xms
    mov  ax,216                 ;\
    call xmmrun                 ; zarezerwuj 216 kilo pamieci XMS
    mov  xmmhandle,ax            ;przepisz uchwyt
;------------------
    mov  ax,3d00h               ;otworz plik
    push cs                     ;\
    pop  ds                     ; >nazwa pliku w danych bliskich
    lea  dx,logo_file           ;/
    int  21h                    ;-wykonaj
    jc   file_error_01
    mov  bx,ax                  ;przepisz uchwyt
    mov  ah,3fh                 ;odczytaj dane
    mov  cx,65078               ;wielkosc pliku BMP
    mov  dx,seg DATA            ;\
    mov  ds,dx                  ; >tablica bufor w zmiennych dalekich
    sub  edx,edx
;    mov  edx,offset logo_bufor  ;/
    int  21h
;---------------------------------
    push bx                     ;odloz uchwyt pliku
    mov  ax,seg DATA            ;\
    mov  ds,ax                  ; \
    sub  esi,esi
;    mov  esi,offset logo_bufor  ;  \
    mov  eax,65078              ;   \
    mov  bx,xmmhandle           ;    >przepisz do XMS pierwszy obrazek
    mov  dx,1                   ;  /
    mov  ecx,00000000           ; /
    call xmmcopy                ;/
    pop  bx                     ;pobierz go
;--------------=-=-=-=-=-=-=-=-=-=-=------------------
    przesun 65078,bx,pocz,0     ;przesun na drugi obrazek
    mov  ah,3fh                 ;odczytaj dane
    mov  cx,65078               ;wielkosc pliku BMP
    mov  dx,seg DATA            ;\
    mov  ds,dx                  ; >tablica bufor w zmiennych dalekich
    sub  edx,edx
;    mov  edx,offset logo_bufor  ;/
    int  21h
    mov  ah,3eh                 ;\
    int  21h                    ; zamknij plik
;--------------=-=-=-=-=-=-=-=-=-=-=-=-=--------------
    mov  ax,seg DATA            ;\
    mov  ds,ax                  ; \
    sub  esi,esi
;    mov  esi,offset logo_bufor  ;  \
    mov  eax,65078              ;   \
    mov  bx,xmmhandle           ;    >przepisz do XMS drugi obrazek
    mov  dx,1                   ;  /
    mov  ecx,0000fe36h          ; /
    call xmmcopy                ;/
    mov  ax,0013h               ;\
    int  10h                    ; uruchom odpowiedni tryb ekranu
    mov  eax,436h               ;\
    mov  cs:[virtualoffset],eax ; ustaw wirtualny wskaznik do pierwszego pliku
    call fade_up                ; wywolaj rozjasnianie ekranu
    mov  ax,86h                 ;\
    mov  cx,33                  ; \
    mov  dx,3333                ;  -odczekaj okolo 6 sekund
    int  15h                    ;/
    call fade_down              ;sciemnij ekran
    mov  eax,0001026ch          ;\
    mov  cs:[virtualoffset],eax ; ustaw wirtualny offset do drugiego obrazka
    call fade_up                ;rozjacnij ekran
    mov  ax,86h                 ;\
    mov  cx,33                  ; \
    mov  dx,3333                ;  -odczekaj ok. 6 s
    int  15h                    ;/
    mov  ah,0ch                 ;\
    mov  al,99                  ; >wyczysc bufor klawiatury
    int  21h                    ;/
    mov  ah,08h                 ;poczkaj na nacisniecie klawisza
    int  21h                    ;wykonaj
    call ustaw_nowe_int9h
    mov  ax,0013h               ;\
    int  10h                    ; wyczysc ekran
    call ustaw_kolory_cegiel    ;ustaw kolory dla cegiel
    push cs
    pop  ds
    lea  si,level_01
    lodsw               ;odczytaj ile klockow
    mov  ile_klockow,ax
main_:
;    push cs             ;\
;    pop  ds             ; >ustaw sie na tablice wcisnietych klawiszy
;    lea  si,key_tab     ;/
    cmp  cs:[key_tab+1h],01   ;czy nacisnieto ENTER
    je   QUIT           ;jesli tak to wyjdz
    call wyczysc_bufor         ;wyczysc bufor
    call zareaguj              ;procedura badajaca jaki klawisz nacisniety
    call narysuj_boisko        ;narysuj boisko w buforze
    call narysuj_cegly         ;narysuj cegly w buforze
    call narysuj_pilke         ;narysuj pileczke
    call narysuj_paletke       ;narysuj paletke w buforze
    call porusz_pilke
    synch                      ;poczekaj na powrot pionowy
    call bufor2screen          ;wyrzuc wszystko na ekran
    jmp  main_                 ;od nowa petla
QUIT:
    call stan_poprzedni
    mov  ax,0003h               ;przywroc tryb tekstowy
    int  10h                    ;wywolaj
    pisz_21h end_txt            ;wypizs komunikat koncowy
    mov ah,4ch                  ;\
    int 21h                     ; zakoncz program

stan_poprzedni PROC near
    call usun_nowe_int9h        ;usun nowe przerwanie klawiatury
    mov  ax,xmmhandle           ;do ax zaladuj uchwyt
    call xmmend                 ;wylacz pamiec xms
    ret
ENDP