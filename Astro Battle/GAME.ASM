;wlasciwa gra!!!!
game proc
          cmp [key_tab+01],01   ;czy jest ESC nacisniety
          je  quit_game         ;tak koniec gry
          call clear_bufor      ;wyczysc bufor
          call rysuj_gwiazdki   ;narysuj gwiazdki
          call rysuj_aster      ;narysuj asteroidy
          call rusz_asteroidy   ;porusza asteroidami
          synch
          call bufor2screen     ;wypisz wszystko na ekran
          jmp game
quit_game:
          ret
game endp