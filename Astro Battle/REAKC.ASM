;zawiera procedury obslugujace klawiature
zareaguj_w_menu proc
          cmp [key_tab+48h],01
          jne next_key
          mov [key_tab+48h],0
          dec pozycja_w_menu
          cmp pozycja_w_menu,0
          jnl next_key
          mov al,2
          mov pozycja_w_menu,al
next_key:
          cmp [key_tab+50h],01
          jne next_key_01
          mov [key_tab+50h],0
          inc pozycja_w_menu
          cmp pozycja_w_menu,2
          jna next_key_01
          xor al,al
          mov pozycja_w_menu,al
next_key_01:
         cmp [key_tab+1ch],01
         jne wylacz
         mov al,1
         mov zatwierdz,al
         jmp koniec_reakcji_w_menu
wylacz:
         xor al,al
         mov zatwierdz,al
koniec_reakcji_w_menu:
          ret
zareaguj_w_menu endp