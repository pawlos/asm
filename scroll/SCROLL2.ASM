.486
JUMPS
STOSIK SEGMENT STACK 'STACK'
       db 100h dup(?)
STOSIK ENDS
ASSUME cs:CODE
       include d:\macro.zbr
CODE SEGMENT use16
               plik db 'font.fnt',0 ;-nazwa pliku z fontem
               ilosc dd 0
               wynik dw ?
               align 4                         ;3072 bajt¢w
               scroll db '                    ',255
                      db '                    ',255
                      db '                    ',255
                      db '                    ',255
                      db '      GFX DEMO      ',255
                      db '                    ',255
                      db 'Greetings for people',255
                      db '                    ',255
                      db '  all of the WORLD  ',255
                      db '                    ',255
                      db '  This nice effect  ',255
                      db ' was code by pawlos ',255
                      db ' -----<<<*>>>-----  ',255
                      db '                    ',255
                      db '        2001        ',255
                      db '                    ',255
                      db '                    ',255,0
               align  4
               linia  dw 0 ;-kt¢ra linia w literze (0-15)
               align  4
               linia2 dw 0
               align  4
               color  db 255
     Start:
            cld
            call load_font      ;wczytuje font do bufora
            call clear_bufor    ;czy˜ci bufor
            mov  ax,0013h       ;wrzu† tryb graficzny
            int  10h            ;uruchom
            call ustaw_palete   ;ustawia kolory ognia (0-254)
            mov ax,seg DANE
            mov es,ax
            call time
            mov cs:[time1],eax
_main:
            call iskry          ;zaladuj nowe iskry na sam d¢ˆ
            synch               ;synchronizacja pionowa
            call show           ;poka¾ scroll'a
;            call move           ;przesuä scroll'a
            call rysuj          ;narysuj scroll'a
            call ogien          ;efekt ognia
            inc cs:[ilosc]      ;zwieksz ilo˜† klatek
            mov ah,01h
            int 16h
            jz  _main
            call time
            mov cs:[time2],eax
            mov ax,0003h        ;\
            int 10h             ; tryb tekstowy
            mov eax,cs:[ilosc]
            mov ebx,cs:[time2]
            sub ebx,cs:[time1]
            call fps
            mov ax,4c00h
            int 21h


;-------///procedury\\\-------
ogien proc
;przy wywoˆaniu es wskazuje na seg DANE
      mov di,320
      mov cx,203*320
fire:
      call pal_sie
      mov es:[di-320],dl
      inc di
      dec cx
jnz  fire
      ret
pal_sie:
      xor ax,ax
      mov al,es:[di]
      mov dx,ax
      mov al,es:[di+320]
      add dx,ax
      mov al,es:[di+321]
      add dx,ax
      mov al,es:[di+319]
      add dx,ax
      shr dx,2
omin_dec:
       cmp dl,0
       je  rys
       dec dl
rys:
       ret

ogien endp
iskry proc
        lea di,zacza
        mov cx,320
wstaw:
        call losuj
        mov es:[di],dl
        mov es:[di+320],dl
        mov es:[di+640],dl
        inc di
        dec cx
jnz    wstaw
        ret

losuj:
      mov ax,cs:[rand]
      mov dx,31413
      mul dx
      add ax,13849
      mov cs:[rand],ax
      mov dx,254       ;przedzial (0-254)
      mul dx
      ret
rand dw 12345
iskry endp
ustaw_palete proc
      xor bl,bl ;nr koloru;
      xor bh,bh ;jasnosc
      mov cx,64
ustaw_czer:
      mov dx,3c8h
      mov al,bl
      out dx,al
      inc dx
      mov al,bh
      out dx,al         ;skladowa czerwona
      xor al,al
      out dx,al         ;\
      out dx,al         ; zero
      inc bl
      inc bh
loop ustaw_czer
      mov bl,64
      xor bh,bh
      mov cx,64
ustaw_green:
      mov dx,3c8h
      mov al,bl
      out dx,al
      inc dx
      mov al,63
      out dx,al ;skladowa czerwona
      mov al,bh ;skladowa zielona
      out dx,al
      xor al,al
      out dx,al ;skladowa niebieska
      inc bl
      inc bh
loop ustaw_green
      mov cx,63
      mov bl,128
      xor bh,bh
ustaw_nieb:
      mov dx,3c8h
      mov al,bl
      out dx,al
      inc dx
      mov al,63
      out dx,al ;skladowa czerwona
      mov al,63 ;skladowa zielona
      out dx,al
      mov al,bh
      out dx,al ;skladowa niebieska
      inc bl
      inc bh
loop ustaw_nieb
      mov cx,62
      mov bl,192
ustaw_b:
      mov dx,3c8h
      mov al,bl
      out dx,al
      inc dx
      mov al,63
      out dx,al
      out dx,al
      out dx,al
      inc bl
loop ustaw_b
     ret
ustaw_palete endp
rysuj proc
      mov ax,seg FONT
      mov ds,ax
      lea si,font_buf   ;ustaw si© na tablic© definiuj¥c¥ FONT
      mov bx,cs:[linia2]
      lea bp,[scroll+bx] ;ustaw si© na tablic© z napisem+odpowiednia liniia
                         ;w znaku
      mov di,33600      ;32000
scroluj:
      xor bx,bx
      mov bl,cs:[bp]    ;pobierz znak
      cmp bl,255        ;koniec linii
      jz  end_of_line
      cmp bl,0          ;koniec napisu
      jz  end_of_scroll
      sub bx,20h        ;aby by† na odpowiedniej pozycji w FONT
      shl bx,5          ;wylicz offset
      mov ax,cs:[linia]
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
      dec  cx
jnz  pixel
      inc bp            ;nast©pny znak
jmp   scroluj
end_of_line:
      inc cs:[linia]    ;zwi©ksz wska«nik
      cmp cs:[linia],15
      jna exit
      add cs:[linia2],21
      mov cs:[linia],0
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
          push es
          mov ax,seg DANE
          mov ds,ax
          xor si,si
          mov ax,0a000h
          mov es,ax
          xor di,di
          mov cx,16000
ekran:
          mov eax,ds:[si]
          add si,4
          mov es:[di],eax
          add di,4
          dec cx
jnz    ekran
;          rep movsw     ;przepisz z bufora na ekran
          pop es
          ret
show endp
move proc
         mov ax,seg DANE
         mov ds,ax
         mov si,320   ;sk¥d przenosi†
         xor di,di     ;gdzie
         mov cx,4000 ;ile sˆ¢w
przenies:
         mov eax,dS:[si]
         add si,4
;         cmp al,50
;         ja omin_dec4
;omin_dec3:
;         cmp al,0
;         jbe omin_dec4
;         dec al
;omin_dec4:
         mov es:[di],eax
         add di,4
         dec cx
         jnz przenies
;loop      przenies
;         rep movsw
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
include time.asm
CODE ENDS
DANE SEGMENT use16
     bufor     db 64000 dup (?)
     zacza     db 3*320 dup (?)
DANE ENDS
FONT SEGMENT use16
     font_buf  db  3072 dup (?)
FONT ENDS
END Start