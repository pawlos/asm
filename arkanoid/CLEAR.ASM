wyczysc_bufor PROC near
     mov ax,DATA                 ;\
     mov es,ax                   ; >ustaw sie na ekran
;     mov edi,offset logo_bufor   ;/
     sub edi,edi
     sub eax,eax                 ;czyscimy zerem
     mov ecx,64000/4             ;liczba czyszczonych bajtow
;     cld
     rep stosd                   ;wyczysc
     ret
ENDP