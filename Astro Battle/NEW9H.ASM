init_new_9h PROC               ;pobiera adres starego i ustawia nowy wektor int9h
          cli
          push  cs                      ;odloz ds
          mov   ax,3509h                ;\
          int   21h                     ; funkcja pobierz adres przerwania
          mov   word ptr cs:Wektor_do_starego_przerwania,bx     ;zapisz offset
          mov   word ptr cs:Wektor_do_starego_przerwania+2,es   ;i segment
          pop   ds                     ;ds=cs
          mov   dx,offset new9h       ;dx=offset nowego przerwania klawiatury
          mov   ax,2509h               ;\
          int   21h                    ; ustaw je
          sti
          ret
ENDP
restore_old_9h PROC               ;przywraca stare przerwanie klawiatury
        cli
        push ds                        ;odloz ds
        mov  dx,word ptr cs:Wektor_do_starego_przerwania        ;do dx offset
        mov  bx,word ptr cs:Wektor_do_starego_przerwania+2      ;do bx segment
        mov  ds,bx                     ;wstaw segment do ds
        mov  ax,2509h                  ;funkcja ustaw przerwanie klawiatury
        int  21h                       ;wykonaj
        pop  ds                        ;odtworz ds
        sti
        ret                            ;powrot
ENDP
new9h PROC                  ;nowe przerwanie klawiatury
       cli
       pushf                    ;odloz znaczniki
       pusha
       push  es                 ;..es..
       push  ds                 ;..di..

       push  cs
       pop   es
       lea   di,key_tab         ;/
       sub   ax,ax              ;wyzeruj ax
       in    al,60h             ;pobierz klawisz
       test  al,80h             ;czy puszczony
       jnz   klawisz_zostal_puszczony  ;jesli tak to skocz
       add   di,ax              ;dodaj do di kod klawisza
       mov   byte ptr es:[di],01         ;01=klawisz wcisniety
koniec:
       sti
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
       pop   ds
       pop   es        ;..i es..
       popa            ;..i zwykle
       popf            ;..i znaczniki
       iret            ;powrot z przerwania
klawisz_zostal_puszczony:
       and  al,01111111b  ;wyzeruj najwyzszy bit
       add  di,ax         ;do di dodaj kod klawisza
       mov  byte ptr es:[di],00    ;00=klawisz puszczony
       jmp  koniec        ;skocz do konca
new9h ENDP                      ;koniec procedury