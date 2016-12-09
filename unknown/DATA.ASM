;dane programu (zmienne ,stale)
tytul  db 'UNKNOWN v1.0',0
engine_ver db 'Silnik v0.9',13,10,'$'
loading_maps     db 'þ Wczytuj© plik mapy........$'
loading_palette  db 'þ Wczytuj© plik palety......$'
loading_textures db 'þ Wczytuj© plik textur......$'
loading_sprites  db 'þ Wczytuj© plik sprit¢w.....$'
loading_font     db 'þ Wczytuj© definicj© fontu..$'
init_keyb        db 'þ Inicjalizacja klawiatury..$'
ok_text          db ' gotowe!!!',13,10,'$'
error_text       db ' wyst¥piˆ bˆ¥d!!!',13,10,'$'
end_text         db 'þ UNKNOWN v1.0 2001$'
entering         db 'Entering level...',0
map_file         db 'maps.dat',0
pal_file         db 'paleta.dat',0
texture_file     db 'data.dat',0
font_file        db 'font.dat',0
;definicje k¥t¢w u¾yte w proc. rey cast
ANGLE_0    dd 0
ANGLE_1    dd 5
ANGLE_2    dd 10
ANGLE_4    dd 20
ANGLE_5    dd 25
ANGLE_6    dd 30
ANGLE_15   dd 80
ANGLE_30   dd 160
ANGLE_45   dd 240
ANGLE_60   dd 320
ANGLE_90   dd 480
ANGLE_135  dd 720
ANGLE_180  dd 960
ANGLE_225  dd 1200
ANGLE_270  dd 1440
ANGLE_315  dd 1680
ANGLE_360  dd 1920
;--end--
;view_angle dd ?
CELL_X_SIZE dd 64          ;rozmiary kom¢rek
CELL_Y_SIZE dd 64
level_max_x dd 64       ; narazie staˆe
level_max_y dd 64       ;/
aktualny_level db 0     ;aktualny level
kolor db ?
y1 dw ?
y2 dw ?