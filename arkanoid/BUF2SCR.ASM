bufor2screen PROC near
        mov  ax,seg DATA                ;\
        mov  ds,ax                      ; >ds:esi wskazuje na logo bufor
        sub  esi,esi                    ;/
        mov  ax,0a000h                  ;\
        mov  es,ax                      ; >es:edi wskazuje na ekran
        sub  edi,edi                    ;/
        mov  ecx,64000/4                ;liczba bajtow do przeslania
        rep  movsd                      ;przeslij
        ret                             ;powrot
ENDP