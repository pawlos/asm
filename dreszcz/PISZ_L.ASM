ASSUME cs:CODE
CODE SEGMENT
       x db ?
       y db ?
       zmi  db 022
       Liczba dw ?
       Pomoc  dw ?
Start:
       mov      ax,0003h
       int      10h
       mov    al,zmi
       cbw
       mov      Liczba,ax
       call  Pisz_Liczbe
       mov   ah,08h
       int   21h
       sub   zmi,2
       mov    al,zmi
       cbw
       mov      Liczba,ax
       call  Pisz_Liczbe
       mov   ah,08h
       int   21h
       mov   ax,4c01h
       int   21h
Pisz_Liczbe:
       mov ax,cs:[Liczba]
       mov cs:[Pomoc],ax
       mov cx,1
       cmp ax,10
       jb  Koniec_testu2
       inc cs:[x]
       inc cx
       cmp ax,100
       jb  Koniec_testu2
       inc cs:[x]
       inc cx
       cmp ax,1000
       jb  Koniec_testu2
       inc cs:[x]
       inc cx
Koniec_testu2:
       mov ax,cs:[Pomoc]
       cwd
       mov bx,10
       mov dx,0
       div bx
       call Pisz_dl
       mov al,dl
       cbw
       sub cs:[Pomoc],ax
       mov ax,cs:[Pomoc]
       cwd
       mov bx,10
       mov dx,0
       div bx
       mov cs:[Pomoc],ax
loop Koniec_testu2
ret
Pisz_dl:
       cmp  cx,0
       jne  ok_01
       cmp  dl,'0'
       je   tut
ok_01:
       push dx
       mov ah,02h
       mov dh,cs:[y]
       mov dl,cs:[x]
       int 10h
       pop dx
       add dl,48
       mov ah,02h
       int 21h
       dec cs:[x]
       sub dl,48
tut:
       ret
CODE ENDS
END Start
