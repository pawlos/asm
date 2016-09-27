;procedura rysuje gwiazdki w buforze
rysuj_gwiazdki proc
        mov ax,seg DANE         ;\
        mov ds,ax               ; >skad pobierane dane
        lea si,star_field       ;/
        mov ax,seg DATA         ;\
        mov es,ax               ; >gdzie wrzuca† dane
        lea di,bufor            ;/
        mov cx,400              ;czterysta razy powtarzaj
draw_stars:
        lodsw                   ;odczytaj wsp. x
        mov di,ax
        mov al,129               ;kolor bialy
        mov es:[di],al          ;wstaw gwiazd©
;nastepna bedzie szara
        lodsw                    ;odczytaj wsp. x
        mov di,ax
        mov al,130               ;kolor szary
        mov es:[edi],al          ;postaw gwiazdke
;nastepna ciemno-szara
        lodsw                    ;odczytaj wsp. x
        mov di,ax
        mov al,131               ;kolor szary
        mov es:[edi],al          ;postaw gwiazdke
loop    draw_stars
        ret
rysuj_gwiazdki endp
;procedura czysci bufor
clear_bufor proc
       mov ax,seg DATA
       mov es,ax
       xor edi,edi
       xor eax,eax
       mov ecx,16000
       rep stosd
       ret
clear_bufor endp
;przepisuje z bufora na ekran
bufor2screen proc
       mov ax,seg DATA
       mov ds,ax
       xor si,si
       mov ax,0a000h
       mov es,ax
       xor di,di
       mov cx,16000
       rep movsd
       ret
bufor2screen endp