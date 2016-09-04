wektor_do_starego_przerwania dd ?
key_tab db 128 dup (?)
ustaw_nowe_int9h PROC near              ;pobiera adres starego i ustawia nowy wektor int9h
          push  ds                      ;odloz ds
          mov   ax,3509h                ;\
          int   21h                     ; funkcja pobierz adres przerwania
          mov   word ptr cs:Wektor_do_starego_przerwania,bx     ;zapisz offset
          mov   word ptr cs:Wektor_do_starego_przerwania+2,es   ;i segment
          pop   es                     ;es=ds
          mov   dx,offset  new9h       ;dx=offset nowego przerwania klawiatury
          mov   ax,2509h               ;\
          int   21h                    ; ustaw je
          ret
ENDP
usun_nowe_int9h PROC near              ;przywraca stare przerwanie klawiatury
        push ds                        ;odloz ds
        mov  dx,word ptr cs:Wektor_do_starego_przerwania        ;do dx offset
        mov  bx,word ptr cs:Wektor_do_starego_przerwania+2      ;do bx segment
        mov  ds,bx                     ;wstaw segment do ds
        mov  ax,2509h                  ;funkcja ustaw przerwanie klawiatury
        int  21h                       ;wykonaj
        pop  ds                        ;odtworz ds
        ret                            ;powrot
ENDP
new9h PROC near                 ;nowe przerwanie klawiatury
       pushf                    ;odloz znaczniki
       push  ax                 ;..i ax
       push  es                 ;..es..
       push  di                 ;..di..
       push  cs                 ;\
       pop   es                 ; >ustaw sie na bufor klawiszy
       lea   di,key_tab         ;/
       sub   ax,ax              ;wyzeruj ax
       in    al,60h             ;pobierz klawisz
       test  al,80h             ;czy puszczony
       jnz   klawisz_zostal_puszczony  ;jesli tak to skocz
       add   di,ax              ;dodaj do di kod klawisza
       mov   byte ptr es:[di],01         ;01=klawisz wcisniety
koniec:
       in    al,61h
       mov   ah,al
       or    al,80h
       out   61h,al
       xchg  ah,al
       out   61h,al
       nop
       nop
       nop
       nop
       nop
       nop
       mov  al,20h
       out  20h,al
       pop   di        ;pobierz ds
       pop   es        ;..i es..
       pop   ax        ;..i ax..
       popf            ;..i znaczniki
       iret            ;powrot z przerwania
klawisz_zostal_puszczony:
       and  al,01111111b  ;wyzeruj najwyzszy bit
       add  di,ax         ;do di dodaj kod klawisza
       mov  byte ptr es:[di],00    ;00=klawisz puszczony
       jmp  koniec        ;skocz do konca
ENDP                      ;koniec procedury