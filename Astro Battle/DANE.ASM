;zawiera dane gry
      aster_def  db 'aster.def',0    ;definicje asteroid¢w
      levels_def db 'levels.dat',0   ;definicje leveli
      stars_def  db 'stars.dat',0    ;definicje gwiazdek
      story_file db 'story.dat',0    ;historyjka
      font_file  db 'computer.fnt',0 ;font
      menu_font  db 'menu.fnt',0     ;font
      wektor_do_starego_przerwania dd ?
      key_tab    db 128 dup (?) ;miejsce na klawisze klawiatury
;bˆ©dy odczytu plikow
      no_aster_file db 'Bˆ¥d odczytu pliku aster.def$'
      no_levels_file db 'Bˆ¥d odczytu pliku levels.dat$'
      no_stars_file db 'Bˆ¥d odczytu pliku stars.dat$'
      no_story_file db 'Bˆ¥d odczytu pliku story.dat$'
      no_font_file db 'Bˆ¥d odczytu pliku computer.fnt$'
      no_menu_font_file db 'Bˆ¥d odczytu pliku menu.fnt$'
;koncowy tekst
      end_info db 'ASTRO BATTLE (c) 2001 by pawlos$'
      wspY dw ? ;\
      wspX dw ? ; wsp. napisu w menu
      color db ? ;poczatkowy kolor
;teksty w menu
      _start  db 'START',0
      _klaw   db 'KLAWISZE',0
      _koniec db 'KONIEC',0
      pozycja_w_menu db 0
      zatwierdz db 0
      tytul db 34,52,53,51,48,1,35,34,53,53,45,38,0 ;ASTRO BATTLE
      klawiatura db 43,44,33,55,41,51,58,37,0         ;KLAWISZE
      menu_txt   db 'MENU:',0
      sterow     db 'STAROWANIE         : KURSORY',0 ;28
      accept     db 'WYBOR              : ENTER',0
      gra_txt    db 'GRA:',0
      fire_txt   db 'STRZAL             : CTRL',0
      panel_txt  db 'PANEL INFORMACYJNY : TAB',0
      PAUSE_txt  db 'PAUSA              : P',0
      nr_levelu  db 2                   ;0-1;1-2;2-3;3-4;4-5
      def_start  db 0,10h,2eh,5ah,94h,00 ;kolejne poczatki definicji leveli
      def_aster  db 0,1ah,40h            ;kolejne poczatki definicji asteroidow