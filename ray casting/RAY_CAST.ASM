;procedura rzucania promieni v0.9 bardzo uboga
ray_cast proc near
         xor di,di
         mov eax,cs:[view_angle]
         sub eax,cs:[ANGLE_30]          ;kat-30ø -sub ustawia odpowiednie
                                        ;znaczniki
         jg  @@kat_ok
         add eax,cs:[ANGLE_360]
@@kat_ok:
         mov cs:[alfa],eax              ;kopia robocza
         mov ecx,319                    ;320 promieni
@@ray:
         push ecx               ;zachowaj licznik
         mov eax,cs:[alfa]
;sprawdz czy w prawo
         cmp eax,cS:[ANGLE_90]
         jl  @@prawo
         cmp eax,cs:[ANGLE_270]
         jg  @@prawo
         xor ebx,ebx
         mov cs:[direction_x],ebx
         jmp @@poziom
@@prawo:
         mov ebx,1
         mov cs:[direction_x],ebx
;g¢ra czy doˆ
@@poziom:
         cmp eax,cS:[ANGLE_180]
         jl  @@dol
         xor ebx,ebx
         mov cs:[direction_y],ebx
         jmp @@end_of_check
@@dol:
         mov ebx,1
         mov cs:[direction_y],ebx
@@end_of_check:
         shl eax,2                      ;kat razy 2
         mov cs:[alfa4],eax
         mov  cs:[ray],cx
         call cast_ray          ;wypu˜† promien
         pop  ecx
         dec  ecx
         jns  @@ray
         ret

;procedury pomocnicze
cast_ray:
;procedura sledzi promien pod wzgledem przeci©† pionowych i poziomych
        mov eax,cs:[alfa]     ;zaˆaduj k¥t
        cmp eax,cs:[ANGLE_90] ;alfa=90 -maksymalna odleglosc x
        je  @@max_dist_x
        cmp eax,cs:[ANGLE_360];alfa=360 -jw.
        je  @@max_dist_x
        call ray_x            ;szukaj przeciec pionowych
        jmp @@przeciecia_pionowe
@@max_dist_x:
        mov eax,cs:[MAX_DISTANCE]
        mov cs:[dist_x],eax
@@przeciecia_pionowe:
        mov eax,cs:[alfa]
        cmp eax,cs:[ANGLE_0]    ;alfa=0 -makasymalna odleglosc y
        je  @@max_dist_y
        cmp eax,cs:[ANGLE_180]  ;alfa=180 -aby nie bylo bledu
        je @@max_dist_y
        call ray_y              ;szukaj przeciec pionowych
        jmp @@rysuj_sciane
@@max_dist_y:
        mov eax,cs:[MAX_DISTANCE]
        mov cs:[dist_y],eax
@@rysuj_sciane:
;kod rysujacy sciane
;mamy odlegˆo˜ci do scian w zmiennych dist_x i dist_y
        mov eax,cs:[dist_x]
        mov ebx,cs:[dist_y]
        cmp ebx,eax             ;kt¢ra mniejsza
        jl  @@dist_ok           ;czy sciana pionowa czy pozioma jest bli¾sza
        xchg ebx,eax                    ;wymien
        mov  dx,cs:[pasek_textury_x]   ;offset paska textury
        mov  cs:[pasek_textury_y],dx
        mov  al,cs:[numer_textury_X]   ;numer uzywanej textury
        mov  cs:[numer_textury_Y],al
@@dist_ok:
        cmp ebx,0                       ;czy odleglosc do sciany =0
        jle  @@next_ray
        cmp ebx,99999
        jge  @@next_ray
        dec ebx
        sal ebx,2
        mov eax,gs:[skala+ebx]  ;odczytaj odlegˆo˜† od s˜ciany
        mov cs:[wysokosc_sciany],eax    ;zachowaj
        sar  eax,1                      ;skala/2
        mov cs:[skalaS],eax              ;zapisz
        mov  ebx,100
        sub  ebx,eax                    ;100-skala/2  -gorny punkt(y1)
        mov  cs:[Y1],bx                 ;zachowaj
        mov  eax,cs:[wysokosc_sciany]
        add  ebx,eax                    ;100+skala/2  -dolny punkt(y2)
        cmp  ebx,199                    ;czy wyczodzi poza ekran
        jb  @@y2_ok                     ;nie -ok
        mov bx,199                      ;zapisz jako koniec Y2=199
@@y2_ok:
        mov cs:[Y2],bx                  ;zachowaj
                                        ;x stanowi aktualnie wypuszcany promieä
        call put_texture                ;nakˆadaj textur©
@@next_ray:
        mov eax,cs:[alfa]               ;zwi©ksz kat patzrenia
        inc eax
        cmp eax,cs:[ANGLE_360]          ;wiekszy od 360
        jl  @@alfa_ok
        xor eax,eax                     ;kat=0
@@alfa_ok:
        mov cs:[alfa],eax
        ret

ray_x:
;sledzi promien pod wzgledem przeciec pionowych
;po wej˜ciu w eax -kopia k¥ta
;       cmp eax,cs:[ANGLE_90] ;kat<90
;       jl @@w_prawo          ;patrzysz w prawo
;       cmp eax,cs:[ANGLE_270];kat>270
;       jg @@w_prawo          ;patrzysz w prawo
        mov eax,cs:[direction_x]
        cmp eax,1
        je  @@w_prawo
;promien leci w lewo
       mov eax,-1
       mov cs:[x_delta],eax
       mov eax,cs:[CELL_X_SIZE]
       neg eax                  ;-64
       mov cs:[Xa],eax
       mov ebx,cs:[alfa4]
       mov eax,dS:[tangens+ebx]
       cdq              ;eax->edx:eax
       shld edx,eax,6   ;edx:eax->64*(edx:eax)
       shl  eax,6
       mov cs:[Ya],eax          ;Ya*65536
       mov eax,cs:[x]
       mov ebx,-64
       and eax,ebx
       mov cs:[xpos],eax    ;zachowaj wsp. x pierwszego przeciecia
       mov ebx,cs:[alfa4]
       mov eax,dS:[tangens+ebx] ;pobierz warto˜† tg
       mov ebx,cs:[x]           ;x- gracza
       sub ebx,cs:[xpos]        ;x-xpos =zawsze dodatnie
       cdq
       imul ebx                 ;ypos
       mov ebx,cs:[y]           ;do ebx y
       xor edx,edx
       shld edx,ebx,16          ;Y musi by† *65536
       shl  ebx,16
       add eax,ebx         ;dodaj
       _abs eax
       mov cS:[ypos],eax        ;ypos -wsp. y pierwszego przeci©cia
       jmp @@nastepne_pionowe   ;szukaj nast©pnych
@@w_prawo:
      mov eax,cs:[CELL_X_SIZE]
      mov cs:[Xa],eax
      mov cs:[x_delta],0
      mov ebx,cs:[alfa4]
      mov eax,dS:[tangens+ebx]        ;    Ya:=64*tg(kat_patrzenia)
      cdq                             ;   /
      shld edx,eax,6                  ;  /
      shl  eax,6                      ; /
      neg eax                         ;/
      mov cs:[Ya],eax           ;Ya *65536
;obliczenie pierwszego pionowego przeciecia
      mov eax,cs:[x]    ;pobierz pozycje gracza
      mov ebx,0ffc0h    ;x & 0ffc0 = kt¢ra kom¢rka w swiecie
      and eax,ebx
      add eax,64        ;(x/64)*64+x_delta(-1 lub 64) -musimy by† na koäcu kom.
      mov cs:[xpos],eax ;zachowaj x pierwszego przeciecia
      mov ebx,cs:[alfa4] ;zaladuj kat
      mov eax,ds:[tangens+ebx] ;pobierz warto˜†
      mov ebx,cs:[x]
      sub ebx,cs:[xpos]            ;(xpos-x)
      cdq
      imul ebx
      mov ebx,cs:[y]
      xor edx,edx
      shld edx,ebx,16        ;(xpos-x)*tg[alfa]+y
      shl  ebx,16
      add eax,ebx
      mov  cs:[ypos],eax
;szukanie przeci©†:
@@nastepne_pionowe:
      mov ebx,cs:[ypos]
      xor edx,edx
      shrd ebx,edx,22        ;(16+6) 16-aby przejsc do liczb calkowitych
                        ;        6-aby zamienic wsp. ekranowe na map©
      cmp ebx,0
      jl  @@maksymalne_oddalenie_pi
      cmp ebx,15                        ;zastapic maksymalnymi rozmiarami mapy
      jg  @@maksymalne_oddalenie_pi
      sal ebx,4
      mov eax,cs:[xpos]
      add eax,cs:[x_delta]
      sar eax,6
      cmp eax,0
      jl  @@maksymalne_oddalenie_pi
      cmp eax,15                        ;j.w.
      jg  @@maksymalne_oddalenie_pi
      add ebx,eax
      mov al,fs:[MAP+ebx]
      cmp al,0
      jne  @@jest_sciana_pionowa
      mov eax,cs:[Xa]
      add cs:[xpos],eax
      mov eax,cs:[Ya]
      add cs:[ypos],eax
      jmp @@nastepne_pionowe
@@maksymalne_oddalenie_pi:
      mov eax,cs:[MAX_DISTANCE]
      mov cs:[dist_x],eax
      jmp @@exit
@@jest_sciana_pionowa:
      mov cs:[numer_textury_X],al       ;zachowaj numer textury
      mov eax,cs:[ypos]
      mov  ebx,3F0000h  ;63<<16 dla dokˆadno˜ci paska textury
      and eax,ebx
      cdq
      shrd eax,edx,16
      mov cS:[pasek_textury_x],ax      ;zachowaj
      movzx ebx,cs:[ray]
      sal ebx,2
      mov eax,ds:[fish_table+ebx]
      mov ebx,cs:[xpos]
      sub ebx,cs:[x]
      jz  @@x_y
      cdq
      imul ebx
      push eax
      push edx
;w eax odlegˆo˜† od ˜ciany
;korekcja rybiego oka
@@korekcja_x:
      mov ebx,cS:[alfa4]
      mov eax,ds:[inv_cos+ebx]
      mov ebx,eax
;      cdq
      pop edx
      pop eax
      imul ebx
      shrd  eax,edx,16
      cmp  eax,0
      jg   @@no_add2
      inc  eax
@@no_add2:
      sar  eax,16
      _abs eax
      mov cs:[dist_x],eax
@@exit:
      ret
@@x_y:
      mov eax,cs:[ypos]
      sub eax,cs:[y]
      jmp @@korekcja_x
ray_y:
;sledzi promien pod wzgledem przeciec poziomych
;po wej˜ciu w procedur© w eax kopia k¥ta w alfa
;      cmp eax,cs:[ANGLE_180]
;      jl  @@do_dolu
      mov eax,cs:[direction_y]
      cmp eax,1
      je  @@do_dolu
;promien leci do g¢ry(zgodnie z Y czyli w d¢ˆ osi)
      mov eax,cs:[CELL_Y_SIZE]
      mov cs:[Ya],eax
      mov cs:[y_delta],0
      mov ebx,cs:[alfa4]
      mov eax,ds:[inv_tan+ebx]  ;inv_tan
      neg eax
      cdq
      shld edx,eax,6
      shl  eax,6
      mov cs:[Xa],eax   ;Xa jest w trybie *65536
      mov eax,cs:[y]
      mov ebx,0ffc0h
      and eax,ebx
      add eax,64
      mov cs:[ypos],eax    ;ok
      mov ebx,cs:[alfa4]
      mov eax,ds:[inv_tan+ebx]
      mov ebx,cs:[y]
      sub ebx,cs:[ypos]
      add ebx,cs:[y_delta]
      cdq
      imul ebx
      mov ebx,cs:[x]
      xor edx,edx
      shld edx,ebx,16
      shl  ebx,16
      add eax,ebx
      _abs eax
      mov cs:[xpos],eax
      jmp @@nastepne_poziome
@@do_dolu:
      mov eax,-1
      mov cs:[y_delta],eax
      mov eax,cs:[CELL_Y_SIZE]
      neg eax
      mov cs:[Ya],eax
      mov ebx,cs:[alfa4]
      mov eax,ds:[inv_tan+ebx] ;inv_tan
      cdq
      shld edx,eax,6
      shl eax,6
      mov cs:[Xa],eax   ;*65536
;@@pierwsze_poziome:
      mov eax,cs:[y]
      mov ebx,0ffc0h
      and eax,ebx
      mov cs:[ypos],eax    ;zachowaj !ok!
      mov ebx,cs:[alfa4]
      mov eax,ds:[inv_tan+ebx]
      mov ebx,cs:[y]
      sub ebx,cs:[ypos]
      cdq
      imul ebx
      mov ebx,cs:[x]
      xor edx,edx
      shld edx,ebx,16
      shl  ebx,16
      add eax,ebx
      _abs eax
      mov cs:[xpos],eax ;xpos*65536
@@nastepne_poziome:
      mov ebx,cs:[ypos]
      sar ebx,6
      add ebx,cs:[y_delta]
      cmp ebx,0
      jl  @@maksymalne_oddalenie_po
      cmp ebx,15                        ;zastapic maksymalnymi wymiarami mapy
      jg  @@maksymalne_oddalenie_po
      sal ebx,4
      mov eax,cs:[xpos]
      cdq
      shrd eax,edx,22        ;(16+6)
      cmp eax,0
      jl  @@maksymalne_oddalenie_po
      cmp eax,15                        ;zastapic maksymalnymi wymiarami mapy
      jg  @@maksymalne_oddalenie_po
      add ebx,eax
      mov al,fs:[map+ebx]
      cmp al,0
      jne  @@sciana_pozioma
      mov eax,cs:[Xa]
      add cs:[xpos],eax
      mov eax,cs:[Ya]
      add cs:[ypos],eax
      jmp @@nastepne_poziome
@@maksymalne_oddalenie_po:
      mov eax,cs:[MAX_DISTANCE]
      mov cs:[dist_y],eax
      jmp @@exit_po
@@sciana_pozioma:
      mov cs:[numer_textury_Y],al
      mov eax,cs:[xpos]
      mov ebx,3f0000h   ;63<<16 dla dokˆadno˜ci paska textury
      and eax,ebx
      cdq
      shrd eax,edx,16
      mov cS:[pasek_textury_y],ax
      movzx ebx,cs:[ray]
      sal ebx,2
      mov eax,ds:[fish_table+ebx]
      mov ebx,cs:[ypos]
      sub ebx,cs:[y]
      jz @@y_greki
      cdq
      imul ebx
      push eax
      push edx
;w eax odlegˆo˜† od ˜ciany
;korekcja rybiego oka
@@korekcja_y:
      mov ebx,cS:[alfa4]
      mov eax,ds:[inv_sin+ebx]
      mov ebx,eax
      cdq
      pop edx
      pop eax
      imul ebx
      shrd eax,edx,16
      cmp  eax,0
      jg   @@no_add
      inc  eax
@@no_add:
      sar  eax,16
      _abs eax
      mov cs:[dist_y],eax
@@exit_po:
      ret
@@y_greki:
      mov eax,cs:[ypos]
      sub eax,cs:[y]
      jmp @@korekcja_y
;zmienne i staˆe
MAX_DISTANCE dd 99999   ;maksymalna odlegˆo˜† gracza od obiektu
skalas        dd 0      ;przechowuje skale sciany
poz_y   dd 0
poz_x   dd 0
xpos    dd 0
ypos    dd 0
Xa      dd 0    ;przyros x-a
Ya      dd 0    ;przyrost Y-a
alfa    dd 0    ;kopia k¥ta
alfa4  dd 0     ;k¥t razy 4
ray     dw 0    ;kt¢ry to promien
dist_x  dd 0    ;odlegˆo˜† gracza od przeci©cia pionowego
dist_y  dd 0    ;j.w. z tym ,¾e od poziomego
x_delta dd 0
y_delta dd 0
direction_x dd 0  ;kierunek patrzenia pionowego (prawo-1 ;lewo-0)
direction_y dd 0  ;kierunek patrzenia pionowego (gora-0 ;d¢ˆ-1)
numer_textury_X  db 0   ;numer textury pionowych scian
numer_textury_Y  db 0   ;j.w. tyle ,¾e poziomych
pasek_textury_X dw 0    ;\
pasek_textury_Y dw 0    ; kt¢ry pasek textury
wysokosc_sciany  dd 0   ;wysoko˜† siany
ray_cast endp