	call	przygotuj_rejestry
	call	ustaw_tryb_320_na_200

	mov	dx,OFFSET Napis_Powitalny   ;DX = adres napisu w pamieci komp.
	call	napisz_na_ekranie

	call	poczekaj_na_klawisz
	call	ustaw_tryb_tekstowy
	jmp	zakoncz_program


	;ROZNE PROCEDURY

napisz_na_ekranie:		;UWAGA: w rejestrze DX musi byc adres napisu!
	mov	ah,09h		;zaladuj liczbe 09h do g¢rnej pol¢wki rej. AX
	int	21h		;wykonaj przerwanie 21h (MS-DOS): napisz
	ret

poczekaj_na_klawisz:
	mov	ah,08h		;zaladuj liczbe 00h do g¢rnej pol¢wki rej. AX
	int	21h		;wykonaj przerwanie 21h (MS-DOS): czekaj na kl.
	ret

przygotuj_rejestry:
	mov	ax,0000h	;zaladuj liczbe 0000h do rejestru AX
	mov	bx,ax		;niech BX = AX
	mov	cx,ax           ;niech BX = AX
	mov	dx,ax           ;niech BX = AX
	mov	di,ax           ;niech BX = AX
	mov	si,ax           ;niech BX = AX

	mov	ax,cs           ;niech AX = CS (czyli segment kodu)
	mov	ds,ax           ;niech DS = AX (czyli niech DS = CS)
	mov	es,ax		;niech ES = AX (czyli niech ES = CS)
				;  po wykonaniu powyzszych trzech dzialan
				;  CS=DS=ES, czyli wszystkie rejestry
				;  odpowiedzialne za segmenty pamieci maja
				;  ten sam adres
	ret

ustaw_tryb_320_na_200:
	mov	al,13h		;zaladuj liczbe 13h do dolnej pol¢wki rej. AX
	mov	ah,00h		;zaladuj liczbe 00h do g¢rnej pol¢wki rej. AX
	int	10h		;wykonaj przerwanie 10h (grafika): ustaw tryb
	ret

ustaw_tryb_tekstowy:
	mov	al,03h		;zaladuj liczbe 03h do dolnej pol¢wki rej. AX
	mov	ah,00h		;zaladuj liczbe 00h do g¢rnej pol¢wki rej. AX
	int	10h		;wykonaj przerwanie 10h (grafika): ustaw tryb
	ret


zakoncz_program:
	mov	ah,4Ch		;zaladuj liczbe 4Ch do g¢rnej pol¢wki rej. AX
	int	21h		;wykonaj przerwanie 21h (MS-DOS): wyjdz do DOS


;	TUTAJ SIE ZACZYNAJA SIE DANE DLA PROGRAMU (ZMIENNE, ITD.):

Napis_Powitalny:
	db 0Ah,0Dh		;skocz do nastepnej linii;
	db 0Ah,0Dh		;skocz do nastepnej linii;
	db 0Ah,0Dh		;skocz do nastepnej linii;
	db 0Ah,0Dh		;skocz do nastepnej linii;
	db 0Ah,0Dh		;skocz do nastepnej linii;
	db 0Ah,0Dh		;skocz do nastepnej linii;
	db 0Ah,0Dh		;skocz do nastepnej linii;
	db 0Ah,0Dh		;skocz do nastepnej linii;
	db 0Ah,0Dh		;skocz do nastepnej linii;
	db 0Ah,0Dh		;skocz do nastepnej linii;
	db '               '	;15 spacji;
	db 'RETROPONG$'		;'$' na koncu to znak dla MS-DOS, zeby juz
				;  skonczyc pisanie
