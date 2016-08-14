STOSIK SEGMENT STACK 'STACK'
       db 100h dup(?)
STOSIK ENDS
ASSUME cs:CODE
       include d:\macro.zbr
CODE SEGMENT
               plik db 'font.fnt',0 ;-nazwa pliku z fontem
                                    ;3072 bajt¢w
               scroll db '  To jest scroll!   ',255
                      db '  A to druga linia  ',255
                      db ' Jest tez i trzecia ',255
                      db '.....I TAK DALEJ....',255
                      db '                    ',255
                      db '                    ',255
                      db '                    ',255,0
               linia  db 0 ;-kt¢ra linia w literze (0-15)
               linia2 dw 0
               color  db 15
     Start:
            cld
            call load_font      ;wczytuje font do bufora
            call clear_bufor    ;czy˜ci bufor
            mov  ax,0013h       ;wrzu† tryb graficzny
            int  10h            ;uruchom
            

_main:
            synch               ;synchronizacja pionowa
            call show           ;pokarz scroll'a
            call move           ;przesuä scroll'a
            call rysuj          ;narysuj scroll'a
            mov ah,01h
            int 16h
            jz  _main
            mov ax,0003h        ;\
            int 10h             ; tryb tekstowy
            mov ax,4c00h
            int 21h


;-------///procedury\\\-------
rysuj proc
      mov ax,seg FONT
      mov ds,ax
      lea si,font_buf   ;ustaw si© na tablic© definiuj¥c¥ FONT
      lea bp,scroll     ;ustaw si© na tablic© z napisem
      add bp,cs:[linia2] ;dodaj ,w kt¢rej linii si© znajdujemy
      mov ax,seg DANE
      mov es,ax
      lea di,bufor      ;ustaw si© na bufor ,w kt¢rym rysujemy
      add di,63680
scroluj:
      xor bx,bx
      mov bl,cs:[bp]    ;pobierz znak
      cmp bl,255        ;koniec linii
      jz  end_of_line
      cmp bl,0          ;koniec napisu
      jz  end_of_scroll
      sub bx,20h        ;aby by† na odpowiedniej pozycji w FONT
      shl bx,5          ;wylicz offset
      xor ax,ax
      mov al,cs:[linia]
      shl ax,1
      add bx,ax         ;odpowiednia linia
      mov ax,ds:[si+bx] ;pobierz wz¢r litery
      xchg ah,al
      mov cx,16         ;ilo˜† pixeli w rzedzie
      mov dx,1000000000000000b
pixel:
      test ax,dx        ;czy jest pixel
      jz  omin_put
      call put_pixel
omin_put:
      inc  di
      shr  dx,1
loop  pixel
      inc bp            ;nast©pny znak
jmp   scroluj
end_of_line:
      inc cs:[linia]    ;zwi©ksz wska«nik
      mov al,cs:[linia]
      cmp al,15
      jna omin_dec
      xor al,al
      add cs:[linia2],21
omin_dec:
      mov cs:[linia],al
exit:
      ret

end_of_scroll:
      mov cs:[linia2],0
      jmp exit
put_pixel:
      mov bl,cs:[color]
      mov es:[di],bl
      ret
rysuj endp
show proc
          mov ax,seg DANE
          mov ds,ax
          xor si,si
          mov ax,0a000h
          mov es,ax
          xor di,di
          mov cx,32000
          rep movsw     ;przepisz z bufora na ekran
          ret
show endp
move proc
         mov ax,seg DANE
         mov es,ax
         mov ds,ax
         mov si,320   ;sk¥d przenosi†
         mov di,0     ;gdzie
         mov cx,31840 ;ile sˆ¢w
         rep movsw      ;przepisz
         mov di,63680
         xor ax,ax
         mov cx,160
         rep stosw      ;wyczy˜† ostatni¥ linie
         ret
move endp
clear_bufor proc
          mov ax,seg DANE
          mov es,ax
          lea di,bufor
          xor ax,ax
          mov cx,32000
          rep stosw
          ret
clear_bufor endp
load_font proc
        mov  ah,3dh
        xor  al,al
        push cs
        pop  ds
        lea  dx,plik
        int  21h       ;otw¢rz plik
;obsˆuga bˆedu -tutaj
        mov bx,ax
        mov ax,seg FONT
        mov ds,ax
        lea dx,font_buf
        mov ah,3fh
        mov cx,3072
        int 21h        ;odczytaj zawarto˜†
        mov ah,3eh
        int 21h        ;zamknij plik
        ret
load_font endp
CODE ENDS
DANE SEGMENT
     bufor     db 64000 dup (?)
DANE ENDS
FONT SEGMENT
     font_buf  db  3072 dup (?)
FONT ENDS
END Start