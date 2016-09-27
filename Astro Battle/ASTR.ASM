;procedury dla asteroidow
;procuedury rysujace asteroidy i inne elementy na ekranie
rysuj_aster proc
;ustaw sie na odpowiednim levelu
       xor bx,bx
       mov bl,nr_levelu   ;do bl nr_aktualnego levelu
       push cs
       pop  ds
       lea si,def_start
       mov al,byte ptr ds:[si+bx]  ;odczytaj gdzie sie zaczynaja odpowiednie definicje dla
                          ;tego levelu
       mov bl,al
       mov ax,seg DANE    ;\
       mov ds,ax          ; \do ds segment pamieci
       lea si,levels
       add si,bx          ;przesun na dane odpowiednie dla danego levelu
;odczytuj odpowiednie dane
read:
       mov ax,word ptr ds:[si]     ;odczytaj typ asteroidu
       mov type_a,ax
       mov ax,word ptr ds:[si+4]   ;odczytaj xo
       mov xo,ax
       mov ax,word ptr ds:[si+6]   ;odczytaj yo
       mov yo,ax
       push si
       call wybierz_asteroid
       pop si
       add si,14                   ;przesun na kolejne dane
       lodsw                       ;odczytaj
       cmp ax,0ffffh               ;czy znak konca
       je  koniec_danych
       sub si,2                    ;przesun na poprzedni bajt
       jmp read
koniec_danych:
       ret
xo     dw ?
yo     dw ?
type_a dw ?
rysuj_aster endp
;procedura wybiera i rysuje odpowiedni asteroid
wybierz_asteroid proc
         mov ax,seg DANE
         mov ds,ax
         mov ax,type_a
         cmp ax,0
         jne spr_01
         lea si,aster_maly
         jmp paint
spr_01:
         cmp ax,1
         jne spr_02
         lea si,aster_duzy
         jmp paint
spr_02:
         lea si,aster_huge
paint:
         lodsw          ;odczytaj liczbe wierzcholkow
         dec ax         ;zmniejsz o 1
         mov cx,ax
         mov ax,seg DATA
         mov es,ax
         xor di,di
         mov color,168
         lodsw          ;x
         add ax,xo      ;wycentruj x
         mov x1,ax      ;\
         mov xs,ax      ; zapisz na pozniej
         lodsw          ;y
         sub ax,yo      ; wycentruj y
         _abs ax        ;/
         mov y1,ax      ;\
         mov ys,ax      ; zachowaj na pozniej
rys:
         lodsw          ;x2
         add ax,xo
         mov x2,ax
         mov xp,ax      ;zachowaj
         lodsw          ;y2
         sub ax,yo
         _abs ax
         mov y2,ax
         mov yp,ax      ;zachowaj
         push cx
         call Linia_prosta
         pop  cx
         mov  ax,xp
         mov  x1,ax
         mov  ax,yp
         mov  y1,ax
loop     rys
         mov  ax,xs     ;\
         mov  x2,ax     ; >
         mov  ax,ys     ; >na koniec polacz poczatek z koncem
         mov  y2,ax     ;/
         call Linia_prosta
         ret
xp dw ?      ;   pomocnicze zmienne
yp dw ?      ;  /
xs dw ?      ; /
ys dw ?      ;/
wybierz_asteroid endp
;proceura porusza asteroidy umieszczone na ekranie
rusz_asteroidy proc
       xor bx,bx
       mov bl,nr_levelu   ;do bl nr_aktualnego levelu
       push cs
       pop  ds
       lea si,def_start
       mov al,byte ptr ds:[si+bx]  ;odczytaj gdzie sie zaczynaja odpowiednie definicje dla
                          ;tego levelu
       mov bl,al
       mov ax,seg DANE    ;\
       mov ds,ax          ; \do ds segment pamieci
       lea si,levels
       add si,bx          ;przesun na dane odpowiednie dla danego levelu
poruszaj:
       mov ax,dS:[si+8]   ;odczytaj speed_x(predko˜† na osi x)
       mov bx,ds:[si+4]   ;do bx xo
       add ax,bx          ;nowe xo
       push ax            ;zachowaj
       mov ax,dS:[si+10]  ;odczytaj speed_y(predko˜† na osi y)
       mov bx,ds:[si+6]   ;do bx- yo
       add bx,ax          ;w bx nowe yo
       pop ax
       call spr_vertex    ;sprawdza czy wszystkie wierzcholki sa na ekranie
                          ;dla nowych wsp. xo,yo.
       add si,14
       lodsw
       cmp ax,0ffffh
       je  nie_ma_wiecej
       sub si,2
       jmp poruszaj
nie_ma_wiecej:
       ret

spr_vertex:
;w ax-new xo
;w bx-new yo
;w ds:si seg:off tablicy levelu
     mov dx,ds:[si]      ;zaladuj do dx typ asteroidu
     cmp dx,0
     jne next_type_01
     call spr_maly
     jmp  end_spr_vertex
next_type_01:
     cmp dx,1
     jne next_type_02
     call spr_duzy
     jmp end_spr_vertex
next_type_02:
     call spr_huge
end_spr_vertex:
     ret

spr_maly:
     cmp bx,11          ;czy uderzymy w gore
     jnb maly_vertex_01 ;nie nic nie zmieniaj
     call zaneguj_vy    ;tak-zmien kierunek na osi OY
maly_vertex_01:
     cmp bx,187         ;czy uderzymu w dol
     jna maly_vertex_02 ;nie -nic nie zmieniaj
     call zaneguj_vy    ;tak -zmien kierunek na osi OY
maly_vertex_02:
     mov ds:[si+6],bx   ;zachowaj nowe wsp.
     cmp ax,11          ;czy uderzymy w lewy bok
     jnb maly_vertex_03 ;nie nic nie zmieniaj
     call zaneguj_vx    ;tak-zmien kierunek na osi OX
maly_vertex_03:
     cmp ax,307         ;czy uderzymy w prawy bok
     jna end_maly_vertex;nie niec nie zmieniaj
     call zaneguj_vx    ;tak-zmien kierunek na osi OX
end_maly_vertex:
     mov ds:[si+4],ax   ;zachowaj nowe wsp.
     ret
spr_duzy:
     cmp bx,36          ;czy uderzymy w gore
     jnb duzy_vertex_01 ;nie nic nie zmieniaj
     call zaneguj_vy    ;tak-zmien kierunek na osi OY
duzy_vertex_01:
     cmp bx,183         ;czy uderzymu w dol
     jna duzy_vertex_02 ;nie -nic nie zmieniaj
     call zaneguj_vy    ;tak -zmien kierunek na osi OY
duzy_vertex_02:
     mov ds:[si+6],bx   ;zachowaj nowe wsp.
     cmp ax,36          ;czy uderzymy w lewy bok
     jnb duzy_vertex_03 ;nie nic nie zmieniaj
     call zaneguj_vx    ;tak-zmien kierunek na osi OX
duzy_vertex_03:
     cmp ax,288         ;czy uderzymy w prawy bok
     jna end_duzy_vertex;nie niec nie zmieniaj
     call zaneguj_vx    ;tak-zmien kierunek na osi OX
end_duzy_vertex:
     mov ds:[si+4],ax   ;zachowaj nowe wsp.
     ret
spr_huge:
     cmp bx,61          ;czy uderzymy w gore
     jnb huge_vertex_01 ;nie nic nie zmieniaj
     call zaneguj_vy    ;tak-zmien kierunek na osi OY
huge_vertex_01:
     cmp bx,172         ;czy uderzymu w dol
     jna huge_vertex_02 ;nie -nic nie zmieniaj
     call zaneguj_vy    ;tak -zmien kierunek na osi OY
huge_vertex_02:
     mov ds:[si+6],bx   ;zachowaj nowe wsp.
     cmp ax,67          ;czy uderzymy w lewy bok
     jnb huge_vertex_03 ;nie nic nie zmieniaj
     call zaneguj_vx    ;tak-zmien kierunek na osi OX
huge_vertex_03:
     cmp ax,277         ;czy uderzymy w prawy bok
     jna end_huge_vertex;nie niec nie zmieniaj
     call zaneguj_vx    ;tak-zmien kierunek na osi OX
end_huge_vertex:
     mov ds:[si+4],ax   ;zachowaj nowe wsp.
     ret

zaneguj_vy:
     mov cx,ds:[si+10]
     neg cx
     mov ds:[si+10],cx
     ret
zaneguj_vx:
     mov cx,ds:[si+8]
     neg cx
     mov ds:[si+8],cx
     ret
rusz_asteroidy endp