load_map proc near
         mov ah,3dh
         push cs
         pop  ds
         lea  dx,map_file
         int 21h
         jc  @@open_error
         mov bx,ax
         mov ax,seg MAPA
         mov ds,ax
         lea dx,map_bufor
         mov ah,3fh
         mov cx,file_size
         int 21h
         mov ah,3eh
         int 21h
;         push ds
;         pop  es
         lea  di,map
         lea  si,map_bufor
         mov  cx,286
@@zamien:
         mov  al,ds:[si]
         cmp  al,0dh
         je  @@enter
         cmp  al,0ah
         je  @@enter
         sub  al,30h
         mov  ds:[di],al
         inc  si
         inc  di
@@od_nowa:
         dec cx
         jns @@zamien
         ret
@@enter:
         inc si
         jmp @@od_nowa
@@open_error:
         push cs
         pop  ds
         lea  dx,open_error_txt
         mov  ah,09h
         int  21h
         mov  ax,4c01h
         int  21h
open_error_txt db 'þ Brak pliku mapa.dat!$'
load_map endp
