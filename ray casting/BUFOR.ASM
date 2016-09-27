clear_bufor proc near
;czysci g¢rn¥ poˆ¢wke kolorem 65h
      push ds
      mov ax,seg BUFOR
      mov ds,ax
      xor edi,edi
      mov eax,49494949h
      mov ecx,4000
@@czysc:
      mov dS:[edi],eax
      add edi,4
      mov ds:[edi],eax
      add edi,4
      dec ecx
jns   @@czysc
;czysci dolna poˆ¢wk© ekranu kolorem 85h
      mov eax,00000000h
      mov ecx,4000
@@czysc2:
      mov ds:[edi],eax
      add edi,4
      mov ds:[edi],eax
      add edi,4
      dec ecx
jns   @@czysc2
      pop ds
      ret
clear_bufor endp

przepisz proc near
      push es
      push ds
      mov ax,seg BUFOR
      mov ds,ax
      mov ax,0a000h
      mov es,ax
      xor edi,edi
      xor esi,esi
      mov ecx,8000
;      rep movsd
@@copy:
      mov eax,ds:[esi]
      add esi,4
      mov ebx,dS:[esi]
      add esi,4
      mov eS:[edi],eax
      add edi,4
      mov es:[edi],ebx
      add edi,4
      dec ecx
jns   @@copy
      pop ds
      pop es
      ret
przepisz endp