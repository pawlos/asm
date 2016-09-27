;reakcja.asm
zareaguj proc near
         cmp cs:[key_tab+4bh],01        ;czy strzaˆka w lewo wcisnieta
         jne @@next_key01               ;nie -sprawdz nastepny klawisz
         mov eax,cs:[view_angle]        ;zaladuj kat patrzeenia
         add eax,cs:[ANGLE_4]           ;dodaj obrot
         cmp eax,cs:[ANGLE_360]         ;czy wiekszy od 360ø
         jl @@ok_kat                    ;jesli mniejszy to nic nie rob
         xor eax,eax                    ;wyzeruj
@@ok_kat:
         mov cs:[view_angle],eax
@@next_key01:
         cmp cS:[key_tab+4dh],01
         jne @@next_key02
         mov eax,cs:[view_angle]
         sub eax,cs:[ANGLE_4]
         cmp eax,cs:[ANGLE_0]
         jg @@ok_kat02
         mov eax,cs:[ANGLE_360]
@@ok_kat02:
         mov cs:[view_angle],eax
@@next_key02:
         cmp cS:[key_tab+48h],01        ;czy wcisniety klawisz do gory
         jne @@next_key03
         mov ebx,cS:[view_angle]
         sal ebx,2
         mov eax,ds:[cosinus+ebx]
         cdq
         mov ecx,10
         imul ecx   ;10*cosinus
         sar eax,16
         add eax,cs:[x]
         mov cS:[new_x],eax     ;zachowaj nowy x
         mov eax,ds:[sinus+ebx]
         cdq
         imul ecx
         sar eax,16
         neg eax
         add eax,cs:[y]
         mov cs:[new_y],eax
         sar eax,6              ;y/64
         cmp eax,0
         jl  @@old_values
         cmp eax,15       ;max y
         jg  @@old_values
         sal eax,4              ;(y/64)*16
         mov ebx,eax
         mov eax,cs:[new_x]
         add eax,15
         sar eax,6
         cmp eax,0
         jl  @@old_values
         cmp eax,15
         jg  @@old_values
         add ebx,eax
         mov al,fs:[MAP+ebx]
         cmp al,0
         jne  @@old_values
         mov eax,cs:[new_x]
         mov cs:[x],eax
         mov eax,cs:[new_y]
         mov cs:[y],eax
@@old_values:
@@next_key03:
         cmp cs:[key_tab+50h],01        ;czy wcisnieto klawisz do dolu
         jne @@old_values2
         mov ebx,cS:[view_angle]
         sal ebx,2
         mov eax,ds:[cosinus+ebx]
         cdq
         mov ecx,10
         imul ecx
         sar eax,16
         mov edx,cs:[x]
         sub edx,eax
         mov cS:[new_x],edx
         mov eax,ds:[sinus+ebx]
         cdq
         imul ecx
         sar eax,16
         neg eax
         mov edx,cs:[y]
         sub edx,eax
         mov cs:[new_y],edx
         sar edx,6              ;y/64
         sal edx,4              ;(y/64)*16
         mov ebx,edx
         mov eax,cs:[new_x]
         sar eax,6
         add ebx,eax
         mov al,fs:[MAP+ebx]
         cmp al,0
         jne  @@old_values2
         mov eax,cs:[new_x]
         mov cs:[x],eax
         mov eax,cs:[new_y]
         mov cs:[y],eax
@@old_values2:
;@@wyjscie:
         ret
del_x    dd 0
del_y    dd 0
new_x    dd 0
new_y    dd 0

zareaguj endp