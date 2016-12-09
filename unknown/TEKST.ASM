wypisz_nazwe proc near
;wypisuje tekst ,kt¢rego offset podany jest w cx:ebx
;zapisuje ax:edx
;w kolor kolor
        push es
        push fs
        push ds
        push edi
        push esi
        mov  es,ax      ;zachowaj gdzie b©dziemy zapisuwa†
        mov  edi,edx    ;seg:offset
        mov  fs,cx      ;zachowaj
        mov  ax,seg FONT ;skad definicje fontu
        mov  ds,ax
        lea  esi,font_buf
@@pisz_znak:
        xor eax,eax
        movsx eax,byte ptr fs:[ebx] ;pobierz znak
        cmp al,0
        je  @@koniec
        sub al,20h   ;konwertuj do odpowiedniej czcionki
        movsx ecx,al
        sal cx,2
        sal ax,1
        add ax,cx       ;w al -przesuni©cie znaku w tablicy font¢w
        mov esi,eax
        mov cx,5
@@linia:
        push cx
        xor ax,ax
        mov al,ds:[esi] ;pobierz definicje linii
        mov dx,10000000b
        mov cx,8
@@bity:
        test ax,dx ;czy zapalony 7 bit
        jz   @@omin_bit
        call  @@postaw_kropke
@@omin_bit:
        inc  edi        ;przejdz do nast©pnej kolumny
        shr  dx,1
        dec  cx
        jns  @@bity
        add  edi,311
        inc  esi    ;nastepny znak
        pop  cx
        dec  cx
        jns  @@linia
        sub  edi,1912
        inc  ebx
jmp     @@pisz_znak
@@koniec:
        pop esi
        pop edi
        pop ds
        pop fs
        pop es
        ret
@@postaw_kropke:
        push ax
        mov al,cs:[kolor]
        mov es:[edi],al
        pop ax
        ret
wypisz_nazwe endp