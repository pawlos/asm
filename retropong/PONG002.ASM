	mov	al,13h		;zaladuj liczbe 13h do dolnej pol¢wki rej. AX
	mov	ah,00h		;zaladuj liczbe 00h do g¢rnej pol¢wki rej. AX
	int	10h		;wykonaj przerwanie 10h (grafika): ustaw tryb

	mov	ah,08h		;zaladuj liczbe 00h do g¢rnej pol¢wki rej. AX
	int	21h		;wykonaj przerwanie 21h (MS-DOS): czekaj na kl.

	mov	al,03h		;zaladuj liczbe 03h do dolnej pol¢wki rej. AX
	mov	ah,00h		;zaladuj liczbe 00h do g¢rnej pol¢wki rej. AX
	int	10h		;wykonaj przerwanie 10h (grafika): ustaw tryb

	mov	ah,4Ch		;zaladuj liczbe 4Ch do g¢rnej pol¢wki rej. AX
	int	21h		;wykonaj przerwanie 21h (MS-DOS): wyjdz do DOS
