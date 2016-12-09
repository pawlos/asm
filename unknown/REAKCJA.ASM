;sprawdza i odpowiada akcj¥ na naci˜ni©cie odpowiednich klawiszy
;przy wej˜ciu ds -tablica z aktualn¥ map¥
reakcja_na_klawisze proc near
        cmp cs:[key_tab+4bh],01 ;czy naci˜ni©to strzaˆk© w lewo
                                ;-obr¢t w lewo
        jne @@strzalka_w_prawo  ;nie-no to sprawdz kolejny
        mov eax,fs:[view_angle] ;zaˆaduj kat patrzenia
        add eax,cs:[ANGLE_4]    ;dodaj k¥t obrotu
        cmp eax,cs:[ANGLE_360]  ;czy wiekszy ni¾ 360
        jl  @@obrot_w_lewo_ok
        xor eax,eax             ;wyzeruj k¥t patrzenia
@@obrot_w_lewo_ok:
        mov fs:[view_angle],eax ;zapisz
@@strzalka_w_prawo:
        cmp cS:[key_tab+4dh],01
                                ;czy obr¢t w prawo
        jne @@strzalka_w_gore
        mov eax,fs:[view_angle] ;\
        sub eax,cs:[ANGLE_4]    ; dodaj k¥t obrotu
        cmp eax,cs:[ANGLE_0]
        jg  @@obrot_w_prawo_ok  ;wiekszy od 0ø
        mov eax,cs:[ANGLE_360]  ;nie-wstaw 360ø
@@obrot_w_prawo_ok:
        mov fs:[view_angle],eax ;zapisz w zmiennej
@@strzalka_w_gore:
        push esi                 ;zachowaj
        cmp cs:[key_tab+48h],01 ;czy wcisneli˜my klawisz do g¢ry
        jne @@strzalka_do_dolu
        mov ecx,cs:[dist2wall]
        push ecx                ;zachowaj
        mov ebx,fs:[view_angle]
        sal ebx,2                ;ka¾da warto˜† cosinusa dla k¥ta zajmuje 4 bajty
        lea esi,[cosinus+ebx]    ;zaˆaduj offset k¥ta w tablicy cosinus¢w
        mov edx,ds:[esi]         ;pobierz warto˜†
        imul eax,edx,10
        sar eax,16               ;cosinus>>16
        cmp eax,0
        jg  @@nie_neguj
        neg ecx      ;minimalna odleglosc od sciany
@@nie_neguj:
        mov cs:[_cos],eax        ;zachowaj ,aby po«niej m¢c wykorzysta†
        add eax,ecx
        add eax,fs:[x]           ;pobierz aktualn¥ wsp. x-ow¥ gracza i dodaj
        mov cs:[player_x1],eax   ;zachowaj
;teraz sinus x
        pop ecx                  ;przywr¢c poprzednie warto˜ci
        lea esi,[sinus+ebx]      ;zaˆaduj offset k¥ta w tablicy sinus¢w
        mov edx,ds:[esi]         ;pobierz warto˜†
        imul ebx,edx,10
        sar ebx,16               ;sinus>>16
        neg ebx
        cmp ebx,0
        jg  @@nie_neguj2
        neg ecx
@@nie_neguj2:
        mov cs:[_sin],ebx        ;zachowaj
        add ebx,ecx
        add ebx,fs:[y]
        mov cs:[player_y1],ebx          ;zachowaj
;sprawdzenie czy nowe wsp. nie lokuj¥ gracza na kom¢rk© ze ˜cian¥
        mov eax,0ffffffc0h
        and ebx,eax             ;y*64 - rz¥d
        mov eax,cs:[player_x1]
        shr eax,6
        add ebx,eax
        mov al,fs:[ebx]          ;pobierz bajt(0-nic ,<>0 sciana
        cmp al,0
        je  @@brak_sciany_na_drodze_do_przodu
;gdzie˜ jest ˜ciana albo na x albo na y trzeba to sprawdzi†
;najpierw x
        mov ebx,fs:[y]
        mov eax,0ffffffc0h
        and ebx,eax
        mov eax,cs:[player_x1]
        shr eax,6
        add ebx,eax             ;dodaj x do 64*y czyli wiersz+kolumna
        mov al,fs:[ebx]
        cmp al,0                ;czy jest sciana
        jne @@druga_mozliwosc_przod
        xor eax,eax
        mov cs:[_sin],eax
        jmp @@brak_sciany_na_drodze_do_przodu
@@druga_mozliwosc_przod:
;y
        mov ebx,cs:[player_y1]
        mov eax,0ffffffc0h
        and ebx,eax
        mov eax,fs:[x]
        shr eax,6
        add ebx,eax
        mov al,fs:[ebx]         ;sprawdz
        cmp al,0
        jne @@strzalka_do_dolu
        xor eax,eax
        mov cs:[_cos],eax
@@brak_sciany_na_drodze_do_przodu:
        mov eax,cs:[_sin]
        add fs:[y],eax
        mov eax,cs:[_cos]       ;j.w.
        add fs:[x],eax
@@strzalka_do_dolu:
        cmp cS:[key_tab+50h],01  ;czy wcisni©to klawisz do doˆu
        jne @@nastepny
;        mov ecx,cs:[dist2wall]   ;minimalna odleglosc gracza od sciany
;        push ecx
        mov edx,cs:[_cos]
;        cmp edx,0
;        jle @@nie_neguj3
;        neg ecx
;@@nie_neguj3:
        mov eax,fs:[x]
        add eax,edx
;        add eax,ecx
        mov cs:[player_x1],eax
        ;----
;        pop ecx
        mov edx,cs:[_sin]
;        cmp edx,0
;        jge @@nie_neguj4
;        neg ecx
;@@nie_neguj4:
        mov ebx,fs:[y]
        add ebx,edx
;        add ebx,ecx
        mov eax,0ffffffc0h
        and ebx,eax
        mov eax,cs:[player_x1]
        shr eax,6
        add ebx,eax     ;mamy przesuniecie
        mov al,fs:[ebx] ;pobierz bajt
        cmp al,0
        je  @@brak_sciany_na_drodze_do_tylu
        xor eax,eax
        mov cs:[_sin],eax
        mov cs:[_cos],eax
@@brak_sciany_na_drodze_do_tylu:
        mov eax,cs:[_sin]
        sub fs:[y],eax
        mov eax,cs:[_cos]
        sub fs:[x],eax
@@nastepny:
        pop esi
        ret
_cos dd ?   ;na warto˜† cosinusa ...
_sin dd ?   ; .. i sinusa
player_x1   dd ?   ;na tymczasowe warto˜ci x-a ...
player_y1   dd ?   ;.. i y-greka
dist2wall   dd 50  ;minimaln odleglosc od sciany

reakcja_na_klawisze endp