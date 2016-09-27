;procedura rozszyfrowuje historyjke i zapisuje ja do bufora
unconvert_story proc
         mov ax,seg DANE        ;\
         mov ds,ax              ; >skad pobiera dane
         lea si,story           ;/
         mov cx,403             ;ile
unconvert:
         mov al,ds:[si]         ;odczytaj znak
         inc al                 ;zwieksz numer znaku ASCII
         mov ds:[si],al         ;zapisz
         inc si                 ;nastepny znak
loop     unconvert
         xor al,al              ;wyzeruj
         mov dS:[si],al         ;wstaw na koniec
         ret                    ;powrot
unconvert_story endp