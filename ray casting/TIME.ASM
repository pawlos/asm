;biblioteka pomocnicza przy obliczaniu ilo˜ci klatek na sekunde
time1 dd ?
time2 dd ?
time proc
;pobiera aktuakny czas i zwraca go w eax(w sekundach)
         mov ah,2ch
         int 21h
         xor eax,eax
         mov  al,ch
         mov  bl,60
         mul  bl
         mul  bl
         mov  cs:[@@temp],eax     ;Godziny
         mov  al,cl
         mul  bl
         add  cs:[@@temp],eax     ;minuty
         mov  al,dh
         add  cs:[@@temp],eax      ;sekundy
         mov eax,cs:[@@temp]
         ret
@@temp dd ?
time endp
fps proc
;procedura oblicza ilo˜† fps
;przy wywoˆaniu eax-ilo˜† klatek
;               ebx-r¢¾nica czasu jaki upˆyn¥ˆ mi©dzy pocz¥tkiem a koäcem
       xor edx,edx
       div ebx              ;oblicz fps
       mov cs:[@@fps],ax    ;zapisz wynik
       lea si,@@znaki+4     ;ustaw si© na tablic©
@@wypisz:
       xor dx,dx
       mov ax,cs:[@@fps]
       mov bx,10
       div bx
       mov cs:[@@fps],ax
       add dl,30h
       mov cs:[si],dl
       dec si
       cmp cs:[@@fps],0
       jne @@wypisz
;wypisz na ekran
       mov ah,02h
@@na_ekran:
       mov dl,cs:[si]
       inc si
       cmp dl,0
       je  @@wyj˜cie
       int 21h
       jmp @@na_ekran
@@wyj˜cie:
       ret
@@znaki db 5 dup(' ')
      db ' fps',0
@@fps dw ?
fps endp