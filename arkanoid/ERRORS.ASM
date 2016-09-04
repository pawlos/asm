file_error_01 PROC near
        mov  ax,0003h
        int  10h
        pisz_21h file_error_txt_01
        mov  ax,xmmhandle
        call xmmend
        mov  ah,4ch
        int  21h
ENDP
blad_cegiel PROC near
        mov  ax,0003h
        int  10h
        pisz_21h klocki_error_txt_01
        call stan_poprzedni
        mov  ah,4ch
        int  21h
ENDP