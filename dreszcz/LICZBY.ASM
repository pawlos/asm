
wypisz_liczbe   PROC    ;tylko mniejsze niz 99
       xor   ax,ax
       mov   al,liczba
       mov   bh,10
       div   bh
       push  ax
       add   al,'0'
       wypisz al
       pop    ax
       add    ah,'0'
       wypisz ah
       ret
ENDP