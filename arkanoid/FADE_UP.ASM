 pal  db 768 dup (?)
 pal2 db 768 dup (?)
 virtualoffset dd ?
fade_up PROC near
    call  read_pal                      ;odczytaj palete obrazka
    call  set_black_pal                 ;ustaw pomocnicza czarna palete
    call  show_logo_screen              ;pokaz rysunek
    mov   cx,64                         ;powtarza 64 razy
fade_up_main:
    push  cx                            ;zachowaj licznik petli
    synch                               ;synchronizuj z plamka
    push  cs                            ;\
    pop   ds                            ; >ustaw si na pal
    lea   si,pal                        ;/
    call  fadeup                        ;przeprwoadz fadding
    call  ustaw_palete                  ;ustaw nowa palete
    pop   cx                            ;pobierz licznik
loop fade_up_main                          ;od nowa
    ret                                 ;powrot

ustaw_palete:
    push  cs                            ;\
    pop   ds                            ; >ustaw sie na pal2
    lea   si,pal2                       ;/
    mov   cx,256*3                      ;mamy 768 skladowych koloru
    mov   dx,3c8h                       ;numer portu
    sub   ax,ax                         ;od koloru 0
    out   dx,al                         ;wyslij
    inc   dx                            ;zwieksz numer portu
skok:
    lodsb                               ;odczytaj bajt
    out   dx,al                         ;wyslij
loop skok                               ;powtorz
    ret                                 ;powrot
;-----------------------------------------------------------------------
fadeup:
    push   cs                           ;\
    pop    es                           ; >ustaw sie na pal2
    lea    di,pal2                      ;/
    mov    cx,256*3                     ;mamy 768 skladowych kolorow
fade1:
    mov    al,byte ptr ds:[si]          ;pobierz i skladnik
    cmp    al,byte ptr es:[di]          ;czy rowne
    je     fade2                        ;tak-skocz
    inc    byte ptr es:[di]             ;nie zwieksz skladowa
fade2:
    inc    si                           ;zwieksz wskaznik
    inc    di                           ;i drugi
loop    fade1                           ;powtarzaj
    ret                                 ;powrot
;----------------------------------------------
set_black_pal:
    push  cs                            ;\
    pop   es                            ; >ustaw sie na pal2
    lea   di,pal2                       ;/
    mov   cx,768                        ;mamy 768 skladowych kolorow
    xor   al,al                         ;od zerowego
    rep   stosb                         ;wypelnij
    mov   cx,256                        ;mamy 256 kolorow
    mov   bl,0                          ;bl=numer koloru
wyczysc:
    mov   dx,3c8h                       ;numer portu
    mov   al,bl                         ;al= numer koloru
    out   dx,al                         ;wyslij
    inc   dx                            ;zwieksz numer portu
    xor   al,al                         ;al=0
    out   dx,al                         ;wyslij skladowa R
    out   dx,al                         ;wyslij skladowa G
    out   dx,al                         ;wyslij skladowa B
    inc   bl                            ;zwieksz numer koloru
loop      wyczysc                       ;powtorz
    ret                                 ;powrot
;-----------------------------------------------
show_logo_screen:
    mov   ax,0a000h             ;\
    mov   ds,ax                 ; \
    sub   si,si                 ;  \
    mov   eax,64000             ;   \
    mov   bx,xmmhandle          ;    >wyswietla rysunek z XMS'u
    mov   dx,2                  ;   /
    mov   ecx,virtualoffset     ; /436h lub 0001026ch
    call  xmmcopy               ;/
    ret
;-----------------------------------------
read_pal:
    mov  ax,seg DATA                    ;\
    mov  ds,ax                          ; >ds:esi wskazuje na palete obrazka
    mov  esi,54                         ;/
    push cs                             ;\
    pop  es                             ; >paleta w danych bliskich
    lea  di,pal                         ;/
    mov  cx,256                         ;rysunki w 256 kolorach
read:
    mov  al,ds:[esi]    ;odczytaj kolor
    shr  al,2           ;ten podziel przez 4
    push ax             ;zapamietaj na stosie
    inc  esi            ;nastepny kolor
    mov  al,ds:[esi]    ;pobierz go
    shr  al,2           ;podziel go przez 4
    push ax             ;zapamietaj na stosie
    inc  esi            ;nastepny kolor
    mov  al,ds:[esi]    ;odczytaj go
    shr  al,2           ;podziel go przez 4
    stosb               ;wstaw do palety
    pop  ax             ;pobierz ax(wartosc zielonego)
    stosb               ;wstaw
    pop  ax             ;pobierz ax(wartosc niebieskiego)
    stosb
    add  esi,2          ;przeskocz o 2 miejsca(omin 0)
loop read
    ret
fade_up ENDP            ;koniec procedury

fade_down PROC near
    mov   cx,64
fade_down_main:
    push  cx
    synch
    push  cs
    pop   es
    lea   di,pal2
    call  fadedown
    call  ustaw_palete
    pop   cx
loop fade_down_main
    ret

fadedown:
    mov  cx,256*3
fadn1:
    cmp  byte ptr es:[di],0
    je   fadn2
    dec  byte ptr es:[di]
fadn2:
    inc  di
loop  fadn1
    ret
ENDP