;odczytuje texture
load_drzwi proc near
        mov ax,3d00h
        push cs
        pop  ds
        lea dx,drzwi_file
        jnt 21h
        mov bx,ax
        mov ah,42h
        xor al,al
        xor cx,cx
        mov dx,1078
        int 21h
;wczytaj do bufora
        mov ax,seg DRZWI
        mov ds,ax
        lea dx,drzwi_buf
        mov ah,3fh
        int 21h
        mov ah,3eh
        int 21h
        ret
load_drzwi endp
wczytaj_texture proc near
        mov ax,3d00h
        push cs
        pop  ds
        lea  dx,texture_file
        int 21h
        jc  @@texture_open_error
        mov bx,ax
        mov ah,42h
        xor al,al
        xor cx,cx
        mov dx,54
        int 21h
        lea dx,paleta
        mov ah,3fh
        mov cx,1024     ;ile bajtow
        int 21h
        mov ah,42h
        xor al,al
        xor cx,cx
        mov dx,1078
        int 21h
        mov ax,seg TEXTURE
        mov ds,ax
        lea dx,texture_bufor
        mov ah,3fh
        mov ecx,256*192    ;ile bajt¢w
        int 21h
        mov ah,3eh
        int 21h
        ret
@@texture_open_error:
        push cs
        pop  ds
        lea  dx,textu_open_error
        mov ah,09h
        int 21h
        mov ax,4c01h
        int 21h
textu_open_error db 'þ Brak pliku mur.dat!$'
wczytaj_texture endp
przygotuj_palete proc near
        lea si,paleta
        lea di,paleta
        mov cx,256
        xor ax,ax
@@konvertuj:
        mov al,cs:[si]          ;pobierz BLUE
        shr al,2
        push ax
        mov al,cS:[si+1]        ;pobierz GREEN
        shr al,2
        push ax
        mov al,cs:[si+2]        ;pobierz RED
        shr al,2
        mov cs:[di],al          ;zapisz RED
        pop ax
        mov cs:[di+1],al        ;zapisz GREEN
        pop ax
        mov cs:[di+2],al        ;zapisz BLUE
        add di,3
        add si,4                ;omin bajt zerowy
        dec cx
        jns @@konvertuj
        ret
przygotuj_palete endp
ustaw_palete proc
       lea si,paleta
       mov cx,255
       xor bl,bl
@@ustawiaj:
       mov dx,3c8h
       mov al,bl
       out dx,al
       inc dx
       mov al,cS:[si]
       out dx,al
       mov al,cs:[si+1]
       out dx,al
       mov al,cs:[si+2]
       out dx,al
       inc bl
       add si,3
       dec cx
       jns @@ustawiaj
       ret
ustaw_palete endp
put_texture proc
            push ds
            push edi
;sprawdz czy ostatnio u¾ywali˜my ju¾ tej tekstury-wi©† mamy wyliczony offset w pliku
            movzx ax,cs:[numer_textury_y]
            mov   bx,cs:[nr_obrazka]    ;-czy ten sam obrazek
            cmp   ax,bx
            je  @@nie_obliczaj_obrazka
;wylicz kt¢r¥ teksture wzi¥†
;64*(iloraz/5*256+Reszta/5)
            mov cs:[nr_obrazka],ax      ;zachowaj na p¢«niej ,aby nast©pnym
                                        ;razem nie obliczba† tego samego
            xor dx,dx
            mov al,cs:[numer_textury_y]
            dec al
            mov bx,4
            div bx                             ;reszta
            shl ax,8                           ;Iloraz*256
            add ax,dx                          ;iloraz*320+reszta
            shl ax,6                           ;ktory obrazek w pliku
            mov cs:[offset_obrazka],eax
@@nie_obliczaj_obrazka:
;oblicz skale dla textury
            mov eax,800000h
            mov ebx,cS:[wysokosc_sciany]
            cmp ebx,0
            je  @@wyjscie
            xor edx,edx
            idiv ebx            ;oblicz krok inkrementacji tekstury*1024
            mov cs:[step],eax
            mov ax,seg TEXTURE  ;\
            mov ds,ax           ; ustaw segment na teksture
            cmp cS:[Y1],0       ; czy sciana wyczodzi poza ekran
            jge @@y1_ok
            ;tak
            movzx eax,cs:[ray]          ;dodaj kolumne aktualnego promienia
            mov   cs:[bufor_offset],eax   ;zachowaj-offset w buforze ekranu

            movsx eax,cs:[Y1]
            neg eax
            sal eax,8   ;Y*256
            mov ebx,cs:[step]
            xor edx,edx
            imul ebx
            mov ebx,0fe000000h  ;Y1*step
            and eax,ebx
            shrd eax,edx,17
            add ax,cs:[pasek_textury_y] ;
            add eax,cs:[offset_obrazka]
            mov cs:[texture_ofs],eax    ;zachowaj - pocz¥tek pobierania danych
            xor eax,eax
            mov cs:[Y1],ax             ;zachwaj Y1
            mov eax,200
            mov cs:[wysokosc_sciany],eax
            jmp @@wstawiaj
@@y1_ok:
            xor eax,eax
            mov ax,cs:[pasek_textury_y]          ;offset paska textury
            add eax,cs:[offset_obrazka]
            mov cs:[texture_ofs],eax           ;zachwaj
            xor ebx,ebx
            movzx eax,cs:[Y1]
            mov ebx,eax
            sal eax,6
            sal ebx,8
            add ebx,eax
            add bx,cs:[ray]                     ;dodaj kolumne
            mov cS:[bufor_offset],ebx           ;zachowaj
@@wstawiaj:
            mov ecx,cs:[wysokosc_sciany]
            cmp ecx,199
            jl  @@wysokosc_ok
            mov ecx,199
@@wysokosc_ok:
;obliczony licznik petli w ecx
            mov esi,cs:[texture_ofs]
            xor ebx,ebx
            mov edi,cs:[bufor_offset]
;            mov edx,cs:[step]               ;edx -krok petli
            xor edx,edx
@@pixele:
            mov al,ds:[esi+ebx]     ;pobierz bajt
            mov es:[edi],al     ;wstaw
            add edi,320         ;nastepna kolumna
            push edx            ;zachowaj
            sar  edx,17         ;edx/1024
            cmp  edx,63         ;wielkosc tekstury
            jl   @@ok_text
            mov  edx,63
@@ok_text:
            sal  edx,8          ;(edx/1024)*128
            mov  ebx,edx
            pop  edx
            add  edx,cs:[step]
            dec  ecx
            jns  @@pixele
@@wyjscie:
            pop edi
            pop ds

            ret
offset_obrazka  dd 0
nr_obrazka      dw -1  ;na pocz¥tek
texture_ofs dd 0
bufor_offset dd 0
step dd 0
counter dd 0
put_texture endp