;procedura piszaca na ekranie

pisz_litere proc
        mov      ax,seg DANE
        mov      fs,ax
        mov      ax,seg DANE
        mov      ds,ax
        mov      ax,0a000h
        mov      es,ax
        ;Policz offset punktu, od kt¢rego ma byç
        ;wypisany tekst
        xor      di,di
        lea      bx,story   ;BX - offset wzglëdem TXT
PiszZnak:
        cmp      cs:[key_tab+01],01
        je       _menu
        mov      al,fs:[bx]
        inc      bx         ;15
        cmp      al,0dh
        je       enter_key
        cmp      al,0
        jne      NieKoniec
        jmp      Koniec_napisu
NieKoniec:
        xor      ah,ah
        ;Policz offset znaku w tablicy FONT
        shl      ax,4
        lea      si,computer_font
        add      si,ax
        mov      cx,16
        mov      ah,132
        push     di
Linia:
        push     di
        lodsb
        mov      dl,10000000b
        mov      dh,8
Kropka:
        test     al,dl      ;Jest punkt?
        jz       NieKropka
        mov      es:[di],ah
NieKropka:
        inc      di
        shr      dl,1
        dec      dh
        jns      Kropka
        pop      di
        add      di,320
        loop     Linia
        mov      ah,86h
        mov      dx,9000h
        int      15h
        pop      di
        add      di,9
        jmp      PiszZnak
Koniec_napisu:
        ret
enter_key:
        push bx
        mov ax,di
        xor dx,dx
        mov bx,320
        div bx
        mov bx,320
        mul bx
        add ax,16*320
        mov di,ax
        pop bx
        inc bx
        jmp PiszZnak
endp

pisz_tytul_w_buforze proc
        mov     ax,seg DANE     ;\
        mov     ds,ax           ; gdzie font
        mov     dx,seg DATA
        mov     es,dx
        ;Policz offset punktu, od kt¢rego ma byç
        ;wypisany tekst
;do di obliczony offset
        mov      di,3258
        lea      bx,tytul   ;BX - offset wzglëdem TXT
PiszZnak_w_menu:
        xor      eax,eax
        mov      al,cs:[bx]
        inc      bx         ;15
        cmp      al,0
        jne      NieKoniec_w_menu
        jmp      Koniec_w_menu
NieKoniec_w_menu:
        dec      al
        xor      ah,ah
        ;Policz offset znaku w tablicy FONT
        shl      ax,5
        lea      si,mini_font
        add      si,ax
        mov      cx,16
        push     di
Linia_w_menu:
        push     cx
        push     di
        lodsw
        xchg     ah,al
        mov      edx,1000000000000000b
        mov      cx,16
Kropka_w_menu:
        test     eax,edx      ;Jest punkt?
        jz       NieKropka_w_menu
        push     eax
        mov      ah,133
        mov      es:[di],ah
        pop      eax
NieKropka_w_menu:
        inc      di
        shr      edx,1
        dec      cx
        jns      Kropka_w_menu
        pop      di
        add      di,320
        pop      cx
        loop     Linia_w_menu
        pop      di
        add      di,17
        jmp      PiszZnak_w_menu
Koniec_w_menu:
        ret
pisz_tytul_w_buforze endp
;pisze menu na ekranie
pisz_menu proc
          lea  bx,_start        ;skad napis
          mov  ax,80           ;wspolrzedna Y
          mov  wspY,ax
          mov  ax,138            ;wspolrzedna X
          mov  wspX,ax
          mov  al,134           ;poczatkowy kolor
          mov  color,al
          mov  al,pozycja_w_menu;\
          cmp  al,0             ; >czy pozycja w menu to start
          je  start_swieci      ;/
          mov al,16             ; nie dodaj do koloru 16
          add color,al          ;/
start_swieci:
          call pisz_napis       ;wypisz tekst
          lea  bx,_klaw         ;ustaw sie na dane
          mov  ax,112           ;\
          mov  wspY,ax          ; >
          mov  ax,124            ; >wspolrzedne Y i X
          mov  wspX,ax          ;/
          mov  al,134           ;poczatkowy kolor
          mov  color,al
          mov  al,pozycja_w_menu;czy jestesmy w klawiszach
          cmp  al,1
          je   klawisze_swieca  ;tak skocz
          mov  al,16            ;nie dodaj 16 do koloru
          add  color,al
klawisze_swieca:
          call pisz_napis       ;wypisz
          lea  bx,_koniec       ;wypisz tekst
          mov  ax,144           ;\
          mov  wspY,ax          ; >wspolrzedne Y i X
          mov  ax,133            ; >
          mov  wspX,ax          ;/
          mov  al,134           ;poczatkowy kolor
          mov  color,al
          mov  al,pozycja_w_menu;czy jestesmy w koniec
          cmp  al,2
          je   koniec_swieci    ;tak skocz
          mov  al,16            ;nie dodaj 16 do kolorow
          add  color,al
koniec_swieci:
          call pisz_napis       ;wypisz tekst
          ret


pisz_napis:
        mov     dx,seg DATA
        mov     es,dx
        mov     ax,seg DANE
        mov     ds,ax
        ;Policz offset punktu, od kt¢rego ma byç
        ;wypisany tekst
        mov      ax,wspY
        mov      dx,wspY
        shl      ax,8
        shl      dx,6
        add      ax,dx
        mov      dx,wspX
        add      ax,dx
        mov      di,ax
PiszZnakMenu:
        mov      al,cs:[bx]
        inc      bx         ;15
        cmp      al,0
        jne      NieKoniecMenu
        jmp      KoniecMenu
NieKoniecMenu:
        xor      ah,ah
        ;Policz offset znaku w tablicy FONT
        shl      ax,4
        lea      si,computer_font
        add      si,ax
        mov      cx,16
        mov      ah,color
        push     di
LiniaMenu:
        push     di
        lodsb
        mov      dl,10000000b
        mov      dh,8
KropkaMenu:
        test     al,dl      ;Jest punkt?
        jz       NieKropkaMenu
        mov      es:[di],ah
NieKropkaMenu:
        inc      di
        shr      dl,1
        dec      dh
        jns      KropkaMenu
        pop      di
        add      di,320
        inc      ah
        loop     LiniaMenu
        pop      di
        add      di,9
        jmp      PiszZnakMenu
KoniecMenu:
        ret
pisz_menu endp
wypisz_info proc
        mov     ax,seg DANE     ;\
        mov     ds,ax           ; gdzie font
        mov     dx,seg DATA
        mov     es,dx
        ;Policz offset punktu, od kt¢rego ma byç
        ;wypisany tekst
;do di obliczony offset
        mov      di,1692
        lea      bx,klawiatura   ;BX - offset wzglëdem TXT
PiszZnak_w_klaw:
        xor      eax,eax
        mov      al,cs:[bx]
        inc      bx         ;15
        cmp      al,0
        jne      NieKoniec_w_klaw
        jmp      Koniec_w_klaw
NieKoniec_w_klaw:
        xor      ah,ah
        ;Policz offset znaku w tablicy FONT
        shl      ax,5
        lea      si,mini_font
        add      si,ax
        mov      cx,16
        push     di
Linia_w_klaw:
        push     cx
        push     di
        lodsw
        xchg     ah,al
        mov      edx,1000000000000000b
        mov      cx,16
Kropka_w_klaw:
        test     eax,edx      ;Jest punkt?
        jz       NieKropka_w_klaw
        push     eax
        mov      ah,166
        mov      es:[di],ah
        pop      eax
NieKropka_w_klaw:
        inc      di
        shr      edx,1
        dec      cx
        jns      Kropka_w_klaw
        pop      di
        add      di,320
        pop      cx
        loop     Linia_w_klaw
        pop      di
        add      di,17
        jmp      PiszZnak_w_klaw
Koniec_w_klaw:
        ret
wypisz_info endp
wypisz_klawisze proc
        lea bx,menu_txt
        mov ax,30
        mov wspX,ax
        mov wspY,ax
        mov al,167
        mov color,al
        call pisz_napisy_klawiszy
        lea bx,sterow
        mov al,166
        mov color,al
        mov ax,50
        mov wspY,ax
        call pisz_napisy_klawiszy
        lea bx,accept
        mov ax,70
        mov wspY,ax
        call pisz_napisy_klawiszy
        lea  bx,gra_txt
        mov  ax,100
        mov  wspY,ax
        mov  al,167
        mov  color,al
        call pisz_napisy_klawiszy
        lea bx,sterow
        mov al,166
        mov color,al
        mov ax,120
        mov wspY,ax
        call pisz_napisy_klawiszy
        lea bx,fire_txt
        mov ax,140
        mov wspY,ax
        call pisz_napisy_klawiszy
        lea bx,panel_txt
        mov ax,160
        mov wspY,ax
        call pisz_napisy_klawiszy
        lea bx,pause_txt
        mov ax,180
        mov wspY,ax
        call pisz_napisy_klawiszy
        ret
pisz_napisy_klawiszy:
        mov     dx,seg DATA
        mov     es,dx
        mov     ax,seg DANE
        mov     ds,ax
        ;Policz offset punktu, od kt¢rego ma byç
        ;wypisany tekst
        mov      ax,wspY
        mov      dx,wspY
        shl      ax,8
        shl      dx,6
        add      ax,dx
        mov      dx,wspX
        add      ax,dx
        mov      di,ax
PiszZnakKlaw:
        mov      al,cs:[bx]
        inc      bx         ;15
        cmp      al,0
        jne      NieKoniecKlaw
        jmp      KoniecKlaw
NieKoniecKlaw:
        xor      ah,ah
        ;Policz offset znaku w tablicy FONT
        shl      ax,4
        lea      si,computer_font
        add      si,ax
        mov      cx,16
        mov      ah,color
        push     di
LiniaMenuKlaw:
        push     di
        lodsb
        mov      dl,10000000b
        mov      dh,8
KropkaMenuKlaw:
        test     al,dl      ;Jest punkt?
        jz       NieKropkaMenuKlaw
        mov      es:[di],ah
NieKropkaMenuKlaw:
        inc      di
        shr      dl,1
        dec      dh
        jns      KropkaMenuKlaw
        pop      di
        add      di,320
        loop     LiniaMenuKlaw
        pop      di
        add      di,9
        jmp      PiszZnakKlaw
KoniecKlaw:
        ret
wypisz_klawisze endp