narysuj_boisko PROC near
       mov ax,seg DATA          ;\
       mov es,ax                ; >ustaw sie na ekran
       sub edi,edi              ;/
       mov eax,32323232h        ;kolor nr 32
       mov ecx,320/4            ;liczba bajtow
       rep stosd                ;narysuj
       mov ecx,198              ;w ecx liczba bajtow do narysowania
rysuj_linie:
       mov es:[edi],al          ;wstaw bajt(linia po lewej stronie)
       add edi,319              ;zwieksz wskaznik
       mov es:[edi],al          ;wstaw bajt(linia po prawej stronie)
       inc edi                  ;zwieksz wskaznik
loop rysuj_linie
;       mov edi,320*198          ;offset dolnej lini
       mov ecx,320/4            ;liczba bajtow
       rep stosd                ;wstaw
       ret                      ;powrot
ENDP