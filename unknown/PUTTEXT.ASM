;kladzie teksture na zadany pasek
put_texture proc near
            push ds
            push es
            push edi
            push esi
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
;            mov al,cs:[numer_textury_y]
            dec ax
            mov bx,4
            div bx                             ;reszta
            shl ax,8                           ;Iloraz*256
            add ax,dx                          ;iloraz*256+reszta
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
            mov eax,199
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
            lea esi,pics
            add esi,cs:[texture_ofs]
            xor ebx,ebx
            mov edi,cs:[bufor_offset]
;            mov edx,cs:[step]               ;edx -krok petli
            xor edx,edx
@@pixele:
            mov al,byte ptr ds:[esi+ebx]     ;pobierz bajt
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
            pop esi
            pop edi
            pop es
            pop ds

            ret
offset_obrazka  dd 0
nr_obrazka      dw -1  ;na pocz¥tek
texture_ofs dd 0
bufor_offset dd 0
step dd 0
counter dd 0
put_texture endp