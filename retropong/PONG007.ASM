	call	ustaw_nowe_przerwanie_klawiatury
	call	przygotuj_rejestry
	call	ustaw_tryb_320_na_200

	mov	dx,OFFSET Napis_Powitalny   ;DX = adres napisu w pamieci komp.
	call	napisz_na_ekranie

	call	poczekaj_na_spacje
	call	wyczysc_ekran
	call	narysuj_lewa_paletke
	call	narysuj_prawa_paletke
	call	poczekaj_na_spacje
	call	przywroc_stare_przerwanie_klawiatury
	call	ustaw_tryb_tekstowy
	jmp	zakoncz_program


	;ROZNE PROCEDURY

;-----------------------------------------------------------------------------

napisz_na_ekranie:		;UWAGA: w rejestrze DX musi byc adres napisu!
	mov	ah,09h		;zaladuj liczbe 09h do g¢rnej pol¢wki rej. AX
	int	21h		;wykonaj przerwanie 21h (MS-DOS): napisz
	ret

;-----------------------------------------------------------------------------

narysuj_lewa_paletke:
	mov	ax,Wysokosc_Ekranu/2 ;po to, by paletka byla prawie posrodku
	mov	cx,Szerokosc_Ekranu  ;niech CX = szerokosc ekranu (200)
	mul	cx		;pomn¢z AX * CX i zapisz wynik w AX
	mov	di,ax		;DI = AX, czyli DI = adres w pamieci wideo
	add	di,Margines	;dodajmy margines, zeby nie bylo calkiem
				;z brzegu
	call	narysuj_paletke	;w DI mamy ustawienia ekranu dla lewej
				;  paletki
	ret

;-----------------------------------------------------------------------------

narysuj_prawa_paletke:
	mov	ax,Wysokosc_Ekranu/2 ;po to, by paletka byla prawie posrodku
	mov	cx,Szerokosc_Ekranu  ;niech CX = szerokosc ekranu (200)
	mul	cx		;pomn¢z AX * CX i zapisz wynik w AX
	mov	di,ax		;DI = AX, czyli DI = adres w pamieci wideo
	add	di,Szerokosc_Ekranu  ;przesunmy sie w prawo
	sub	di,Margines	;odejmijmy margines, zeby nie bylo calkiem
				;z brzegu
	sub	di,Szerokosc_Paletki ;odejmijmy jeszcze szerokosc paletki
	call	narysuj_paletke	;w DI mamy ustawienia ekranu dla prawej
				;  paletki
	ret

;-----------------------------------------------------------------------------

narysuj_paletke:		;UWAGA! W DI musi byc adres w pamieci wideo
	push	es		;odl¢z ES na stos
	mov	ax,0A000h	;AX = segment pamieci karty wideo
	mov	es,ax		;ES = AX, czyli ES = segment pamieci karty w.

	mov	cx,Wysokosc_Paletki  ;wiadomo, niech CX = wysokosc paletki
rysuj_paletke:
	push	cx		;zapamietaj CX (odl¢z na stos)
	mov	cx,Szerokosc_Paletki ;a teraz niech CX = szerokosc paletki
rysuj_linie_paletki:
	mov	byte ptr es:[di],Zielony  ;narysuj zielony piksel
	inc	di		;zwieksz DI o 1 (czyli DI = DI + 1)
	loop	rysuj_linie_paletki  ;zmiejsz CX o 1, a jesli wciaz jest
				     ; wiekszy od 0, to skocz do linii
                                     ; rysuj_linie_paletki
	pop	cx		;przywr¢c CX ze stosu (czyli CX = wysokosc p.)

	add	di,Szerokosc_Ekranu  ;dodaj do DI szerokosc ekranu
	sub	di,Szerokosc_Paletki ;...i odejmij szerokosc paletki
	loop	rysuj_paletke   ;CX = CX - 1, i jesli CX > 0, to skocz

	pop	es		;pobierz ES ze stosu (czyli przywr¢c wartosc)
	ret

;-----------------------------------------------------------------------------

nowe_przerwanie_klawiatury:
	pushf			;odl¢z na stos znaczniki
	push ax			;...i rejestr AX
	in   al,60h		;pobierz od komputera kod wcisnietego klawisza
	mov  cs:Kod_Klawisza,al	;...i zapisz to w zmiennej Kod_Klawisza
	in   al,61h		;to jest cykl instrukcji, kt¢rego nie trzeba
	mov  ah,al		;  rozumiec (sam go nie rozumiem), ale
	or   al,80h		;  w kazdym razie jest potrzebny, by komputer
	out  61h,al		;  m¢gl wr¢cic do normalnej pracy i
	xchg ah,al		;  przygotowac sie na nastepny odczyt
	out  61h,al		;  kolejnego klawisza (w przyszlosci)
	nop			;nic nie r¢b przez chwile, zeby komputer
	nop			;  doszedl do siebie po takiej serii rozkaz¢w
	nop			;  korzystajacych z port¢w
	nop
	nop
	nop
	mov  al,20h		;daj komputerowi znak, ze zaraz bedzie koniec
	out  20h,al		;  przerwania
	pop  ax			;pobierz ze stosu rejestr AX
	popf			;...i znaczniki
	iret			;zakoncz przerwanie

;-----------------------------------------------------------------------------

poczekaj_na_spacje:
	mov	al,Kod_Klawisza	;AL = kod jakiegos wcisnietego klawisza
wciaz_ten_sam_klawisz:
	cmp	al,Kod_Klawisza	;czy AL = kod obecnie wciskanego klawisza?
	jz	wciaz_ten_sam_klawisz	;...tak dlugo jak tak, kraz w k¢lko

	cmp	Kod_Klawisza,Spacja	;czy teraz wcisniety klaw. to spacja?
	jnz	poczekaj_na_spacje	;...jesli nie, to zabawa od nowa
	ret

;-----------------------------------------------------------------------------

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

;-----------------------------------------------------------------------------

przywroc_stare_przerwanie_klawiatury:
	push ds			;odl¢z DS (bo zaraz zostanie zmienione)
	mov  dx,word ptr cs:Wektor_Do_Starego_Przerwania
	mov  bx,word ptr cs:Wektor_Do_Starego_Przerwania+2
	mov  ds,bx
	mov  ax,2509h		;...czyli DS:AX to adres starego przerwania
	int  21h		;MS-DOS: ustaw przerwanie
	pop  ds			;odtw¢rzmy DS
	ret

;-----------------------------------------------------------------------------

ustaw_nowe_przerwanie_klawiatury:
	push	es		;odl¢z ES (bo zaraz zostanie zmienione)
	mov	ax,3509h	;wykonaj przerwanie MS-DOS, kt¢re w ES:BX
	int	21h		;  poda wartosc obecnego, starego prz.klaw.
	mov	word ptr cs:Wektor_Do_Starego_Przerwania,bx
	mov	word ptr cs:Wektor_Do_Starego_Przerwania+2,es
	pop	es		;przywr¢c ES (odtwarzamy to stare, z poczatku
				;  procedury (powinno byc r¢wne CS);
	mov	dx,OFFSET nowe_przerwanie_klawiatury
	mov	ax,2509h	;MS-DOS: ustaw nowe przerwanie o adresie DS:DX
	int	21h		;  (jak pamietamy DS=CS);
	ret

;-----------------------------------------------------------------------------

ustaw_tryb_320_na_200:
	mov	al,13h		;zaladuj liczbe 13h do dolnej pol¢wki rej. AX
	mov	ah,00h		;zaladuj liczbe 00h do g¢rnej pol¢wki rej. AX
	int	10h		;wykonaj przerwanie 10h (grafika): ustaw tryb
	ret

;-----------------------------------------------------------------------------

ustaw_tryb_tekstowy:
	mov	al,03h		;zaladuj liczbe 03h do dolnej pol¢wki rej. AX
	mov	ah,00h		;zaladuj liczbe 00h do g¢rnej pol¢wki rej. AX
	int	10h		;wykonaj przerwanie 10h (grafika): ustaw tryb
	ret

;-----------------------------------------------------------------------------

wyczysc_ekran:
	push	es		;odl¢z ES na stos
	mov	ax,0A000h	;AX = segment pamieci karty wideo
	mov	es,ax		;ES = AX, czyli ES = segment pamieci karty w.

	mov	bx,0000h	;wpiszmy zero do BX
wpisuj_zera:
	mov	byte ptr es:[bx],00h  ;dluga instrukcja... Oznacza: wpisz 00h
				      ;w kom¢rke pamieci o adresie ES:BX
	inc	bx		;zwieksz BX o 1
	cmp	bx,64000	;por¢wnaj BX z liczba 64000. Liczba ta to
				;  dlugosc segmentu karty wideo. Inaczej
				;  "sprawdz, czy BX doszedl juz do konca?"
	jnz	wpisuj_zera	;jesli BX < 64000, to ciagle wpisuj

	pop	es		;pobierz ES ze stosu (czyli przywr¢c wartosc)
	ret

;-----------------------------------------------------------------------------

zakoncz_program:
	mov	ah,4Ch		;zaladuj liczbe 4Ch do g¢rnej pol¢wki rej. AX
	int	21h		;wykonaj przerwanie 21h (MS-DOS): wyjdz do DOS


;-----------------------------------------------------------------------------
;	TUTAJ SIE ZACZYNAJA SIE DANE DLA PROGRAMU (ZMIENNE, ITD.):
;-----------------------------------------------------------------------------

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

Zielony				equ 032


Szerokosc_Ekranu		equ 320
Wysokosc_Ekranu			equ 200
Margines			equ  20
Szerokosc_Paletki		equ   6
Wysokosc_Paletki		equ  30

Kod_Klawisza 		    	db 0	;the data byte for key code
Wektor_Do_Starego_Przerwania	dd ?
Escape				equ   1
Spacja				equ  57
