;wczytuje pliki z danymi
wczytaj_pliki proc near
       mov ah,02h       ;\
       xor bh,bh        ; \
       mov dh,3         ;  >ustaw si© na 3 rz©dzie
       mov dl,0         ; /
       int 10h          ;/
       lea dx,engine_ver
       call wypisz_kom
       lea dx,loading_maps      ;wypisz tekst o wczytywaniu pliku z mapami
       call wypisz_kom
;wczytywanie kolejno plik¢w
;plik z mapami
       mov  ax,3d00h       ;otw¢rz plik
       push cs
       pop  ds
       lea  dx,map_file
       int  21h
       jc  @@error_file
       mov bx,ax            ;przepisz uchwyt
       mov ecx,65535        ;ile mo¾na?
       mov ax,seg MAPY
       mov ds,ax
       xor edx,edx
       mov ah,3fh
       int 21h
       mov ah,3eh
       int 21
       lea dx,ok_text
       call wypisz_kom
;kolejny plik -paleta
       lea dx,loading_palette
       call wypisz_kom
       mov ax,3d00h
       lea dx,pal_file
       int 21h
       jc  @@error_file
       mov bx,ax        ;przepisz uchwyt
       mov ax,seg PALETA
       mov ds,ax
       lea dx,pal
       mov cx,768
       mov ah,3fh
       int 21h        ;odczytaj i zapisz do bufora
       mov ah,3eh
       int 21h    ;zamknij
       lea dx,ok_text
       call wypisz_kom
;wczytaj kolejny plik-textury
       lea dx,loading_textures
       call wypisz_kom
       jc  @@error_file
       mov ax,3d00h
       lea dx,texture_file
       int 21h
       jc  @@error_file
       mov bx,ax
       mov ax,seg TEXTURE
       mov ds,ax
       lea edx,pics
       mov cx,256*192
       mov ah,3fh
       int 21h
       mov ah,3eh
       int 21h
       lea  dx,ok_text
       call wypisz_kom
;wczytuje plik z fontem
       lea dx,loading_font
       call wypisz_kom
       mov ax,3d00h
       lea dx,font_file
       int 21h
       jc @@error_file
       mov bx,ax
       mov ax,seg FONT
       mov ds,ax
       lea dx,font_buf
       mov cx,576  ;ile bajt¢w
       mov ah,3fh
       int 21h
       mov ah,3eh
       int 21h
       lea dx,ok_text
       call wypisz_kom
;wszystkie pliki odczytane ok
       ret

@@error_file:
       lea dx,error_text
       call wypisz_kom
       mov ax,4c01h
       int 21h
wczytaj_pliki endp