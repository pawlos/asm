;procedura przygotowuje level
przygotuj_level proc near
        movsx eax,cs:[aktualny_level]
        mov ebx,4300
        xor edx,edx
        mul ebx    ;wylicz offset w segmencie na aktualny level
        mov esi,eax ;zapisz offset
        mov ax,seg MAPY
        mov ds,ax   ;segment
        mov ax,seg ACTUAL_MAP
        mov es,ax
        lea edi,tytul_mapy             ;seg:off docelowy tytul
@@read_title:
        mov al,ds:[esi] ;odczytaj znak
        cmp al,0
        jz  @@end_of_title
        inc esi            ;next znak
        mov es:[edi],al
        inc edi            ;next docelowy
        jmp @@read_title
@@end_of_title:
        xor al,al
        mov es:[edi],al ;zapisz zero na koäcu
        add esi,3       ;skocz na x i y
        lea edi,x
        mov eax,dword ptr ds:[esi]        ;odczytaj x
        add esi,4
        mov dword ptr es:[edi],eax
        lea edi,y
        mov eax,dword ptr ds:[esi]
        mov dword ptr es:[edi],eax
        add esi,6
        lea edi,view_angle
        mov eax,dword ptr ds:[esi]  ;odczytaj k¥t patrzenia
        mov esi,19h                   ;kat + enter
        mov dword ptr es:[edi],eax
        lea edi,mapka   ;zapisz mapk©
        mov ecx,4024
@@odczytaj_mape:
        mov al,dS:[esi] ;odczytaj znak
        cmp al,13       ;czy enter
        je  @@nie_zapisuj
        cmp al,10       ; j.w.
        je  @@nie_zapisuj
;        cmp al,0
;        je  @@nie_zapisuj
        sub al,30h        ;odejmij kod zera
        mov es:[edi],al
        inc edi
@@nie_zapisuj:
        inc esi           ;nastepny znak
        dec ecx
        jns @@odczytaj_mape
@@koniec:
;wypisac aktualny tytul mapy na ekranie
        ret
przygotuj_level endp