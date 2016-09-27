;procedura ustawia palete
ustaw_palete proc
       call ustaw_kolory_gwiazd
       call ustaw_palete_napisu
       call ustaw_palete_napisu_menu
       call ustaw_palete_menu
       call ustaw_palete_klawiszy
       call ustaw_palete_meteorytow
       ret
ustaw_palete_meteorytow:
       mov al,168
       mov dx,3c8h
       out dx,al
       inc dx
       mov al,43        ;R
       out dx,al
       mov al,23        ;G
       out dx,al
       mov al,10        ;B
       out dx,al
       ret


ustaw_palete_klawiszy:
      mov al,166       ;nr. koloru
      mov dx,3c8h
      out dx,al
      inc dx
      mov al,23         ;R
      out dx,al
      mov al,63         ;G
      out dx,al
      mov al,10         ;B
      out dx,al
      mov al,167        ;nr. koloru
      mov dx,3c8h
      out dx,al
      inc dx
      mov al,63
      out dx,al
      xor al,al
      out dx,al
      out dx,al
      ret

ustaw_palete_menu:
      mov al,134        ;zaczynamy od 134 koloru
      mov cx,16         ;16 kolorow
      mov bl,31         ;zaczynamy od jasnosci 15
kolory_menu_1:
      push ax
      mov dx,3c8h
      out dx,al         ;wyslij numer koloru
      inc dx
      mov al,bl
      out dx,al         ;R
      out dx,al         ;G
      xor al,al
      out dx,al         ;B=0
      pop ax
      add bl,2
      inc al
loop  kolory_menu_1
      mov cx,16
      mov bl,31
kolory_menu_2:
      push ax
      mov dx,3c8h
      out dx,al         ;wyslij numer koloru
      inc dx
      xor al,al
      out dx,al         ;R=0
      mov al,bl
      out dx,al         ;G=intensywnosc
      xor al,al
      out dx,al         ;B=0
      pop ax
      add bl,2
      inc al
loop  kolory_menu_2
      ret

ustaw_palete_napisu_menu:
      mov al,133
      mov dx,3c8h
      out dx,al
      inc dx
      mov al,43
      out dx,al
      mov al,23
      out dx,al
      mov al,10
      out dx,al
      ret
ustaw_palete_napisu:
      mov al,132
      mov dx,3c8h
      out dx,al
      inc dx
      mov al,0          ;Red
      out dx,al
      mov al,53         ;Green
      out dx,al
      mov al,23         ;Blue
      out dx,al
      ret
ustaw_kolory_gwiazd:
      mov cx,3
      mov al,129        ;zaczynamy od 129
      mov bl,63         ;i jasnosci 63
ustaw_gwiazde:
      push ax
      mov dx,3c8h
      out dx,al         ;wyslij nr. koloru
      inc dx
      mov al,bl
      out dx,al         ;\
      out dx,al         ; >wyslij skladowe R G B
      out dx,al         ;/
      sub bl,20         ;zmniejsz intensywnosc
      pop ax
      inc al            ;zwieksz nr. koloru
loop  ustaw_gwiazde
      ret
ustaw_palete endp