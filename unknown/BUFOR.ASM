;procedury zwi¥zane z buforem ekranu
clear proc near
;þ czy˜ci caˆy ekran na czarno -czasami przydatne
      push ds
      push edi
      mov  ax,seg BUFOR
      mov  ds,ax
      xor  edi,edi
      xor  eax,eax
      mov  ecx,8000
@@czysc_na_czarno:
      mov  ds:[edi],eax
      add  edi,4
      mov  ds:[edi],eax
      add  edi,4
      dec  ecx
      jns  @@czysc_na_czarno
      pop  edi
      pop  ds
      ret
clear endp
clear_bufor proc near
;þ czy˜ci bufor na kolory:
;         - g¢rna poˆowa kolor sufitu
;         - dolna poˆowa kolor podˆogi
      push ds
      push edi
      mov ax,seg BUFOR
      mov ds,ax
      xor edi,edi
      mov eax,05050505h ;kolor sufitu
      mov ecx,4000
@@czysc:
      mov dS:[edi],eax
      add edi,4
      mov ds:[edi],eax
      add edi,4
      dec ecx
jns   @@czysc
;      mov eax,0e0e0e0eh  ;kolor podˆogi
      xor eax,eax
      mov ecx,4000
@@czysc2:
      mov ds:[edi],eax
      add edi,4
      mov ds:[edi],eax
      add edi,4
      dec ecx
jns   @@czysc2
      pop edi
      pop ds
      ret
clear_bufor endp
;kopiuje zawarto˜† bufora na ekran
przepisz_bufor proc near
       push ds
       push es
       push esi
       push edi
       mov  ax,seg BUFOR
       mov  ds,ax
       mov  ax,0a000h
       mov  es,ax
       xor  edi,edi
       xor  esi,esi
       mov  ecx,8000
@@przepisz:
       mov eax,ds:[esi]
       add esi,4
       mov ebx,dS:[esi]
       add esi,4
       mov es:[edi],eax
       add edi,4
       mov es:[edi],ebx
       add edi,4
       dec ecx
jns    @@przepisz
       pop edi
       pop esi
       pop es
       pop ds
       ret
przepisz_bufor endp