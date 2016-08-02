	call	ustaw_nowe_przerwanie_klawiatury
	call	przygotuj_rejestry
	call	ustaw_tryb_320_na_200

	mov	dx,OFFSET Napis_Powitalny   ;DX = adres napisu w pamieci komp.
	call	napisz_na_ekranie

	call	poczekaj_na_spacje
	call	wyczysc_ekran
	mov	byte ptr:Pozycja_Paletki_Lewej,Wysokosc_Ekranu/2
	mov	byte ptr:Pozycja_Paletki_Prawej,Wysokosc_Ekranu/2
	call	narysuj_paletki_na_ekranie

wlasciwa_gra:
	call	zbadaj_jaki_klawisz_wcisniety
	cmp	byte ptr:Escape_Wcisniety,1  ;czy gracz chce zakonczyc gre?
	jz	koniec_gry		;...jesli tak, to skocz do konca gry
	call	zareaguj_w_zaleznosci_od_klawisza
	call	poczekaj_na_przerwanie_pionowe
	call	wyczysc_ekran_szybko
	call	narysuj_paletki_na_ekranie
	jmp	wlasciwa_gra		;i w k¢leczko

koniec_gry:
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

narysuj_paletki_na_ekranie:

	;najpierw lewa paletka
	mov	al,Pozycja_Paletki_Lewej
	mov	ah,0		;AX = pozycja lewej paletki
	mov	cx,Szerokosc_Ekranu
	mul	cx		;AX = AX * CX
	mov	di,ax		;DI = AX, czyli DI = adres w pamieci wideo
	add	di,Margines	;dodajmy margines, zeby nie bylo calkiem
				;z brzegu
	call	narysuj_paletke	;w DI mamy ustawienia ekranu dla lewej

	;a potem prawa paletka
	mov	al,Pozycja_Paletki_Prawej
	mov	ah,0		;AX = pozycja prawej paletki
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

nowe_przerwanie_klawiatury:
	pushf			;odl¢z na stos znaczniki
	push ax			;...i rejestr AX
	in	al,60h		;pobierz od komputera kod wcisnietego klawisza
	mov	cs:Kod_Klawisza,al ;...i zapisz to w zmiennej Kod_Klawisza
	in	al,61h		;to jest cykl instrukcji, kt¢rego nie trzeba
	mov	ah,al		;  rozumiec (sam go nie rozumiem), ale
	or	al,80h		;  w kazdym razie jest potrzebny, by komputer
	out	61h,al		;  m¢gl wr¢cic do normalnej pracy i
	xchg	ah,al		;  przygotowac sie na nastepny odczyt
	out	61h,al		;  kolejnego klawisza (w przyszlosci)
	nop			;nic nie r¢b przez chwile, zeby komputer
	nop			;  doszedl do siebie po takiej serii rozkaz¢w
	nop			;  korzystajacych z port¢w
	nop
	nop
	nop
	mov	al,20h		;daj komputerowi znak, ze zaraz bedzie koniec
	out	20h,al		;  przerwania
	pop	ax 		;pobierz ze stosu rejestr AX
	popf			;...i znaczniki
	iret			;zakoncz przerwanie

;-----------------------------------------------------------------------------

poczekaj_na_przerwanie_pionowe:
	push	ax
	push	dx
czekaj01:
	mov	dx,03DAh	;Input Status #1 Register
	in	al,dx		;sprawdz, czy moze wlasnie w tej chwili
	test	al,8		;  mamy powr¢t pionowy, a jesli tak, to
	jne	czekaj01	;  poczekaj az sie skonczy.
czekaj02:
	in	al,dx
	test	al,8		;jesli bit 3 (VR = 0), w¢wczas czekaj na
	je	czekaj02	;  powr¢t pionowy (VR = 1)
	pop	dx
	pop	ax
	ret

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

wyczysc_ekran_szybko:
	push	es		;odl¢z ES na stos
	mov	ax,0A000h	;AX = segment pamieci karty wideo
	mov	es,ax		;ES = AX, czyli ES = segment pamieci karty w.

	mov	cx,32000  	;ile sl¢w wyczyscic? (32000x2=64000 bajt¢w)
	mov	ax,00000	;jaka liczba czyscic?
	mov	di,00000	;od jakiego adresu zaczac
	rep	stosw		;polecenie to oznacza: wykonaj CX razy
				;  (czyli 64000) operacje stosw. Stosw oznacza
				;  wpisz AX w slowo o adresie DS:DI. Po kazdym
				;  wpisie DI zwieksza sie o 2 ('w' to skr¢t
				;  od 'word', czyli slowo (2 bajty)).

	pop	es		;pobierz ES ze stosu (czyli przywr¢c wartosc)
	ret


;-----------------------------------------------------------------------------

zakoncz_program:
	mov	ah,4Ch		;zaladuj liczbe 4Ch do g¢rnej pol¢wki rej. AX
	int	21h		;wykonaj przerwanie 21h (MS-DOS): wyjdz do DOS

;-----------------------------------------------------------------------------

zareaguj_w_zaleznosci_od_klawisza:
	cmp	byte ptr:A_wcisniety,1  ;czy 'A' (do g¢ry) jest wcisniety?
	jnz	kolejny01               ;...jak nie, to badaj kolejny klawisz
	mov	al,byte ptr:Pozycja_Paletki_Lewej       ;AL = pozycja paletki
	sub	al,2                    ;odejmij 2 od AL (o tyle przesuwamy)
	jc	koniec_reagowania	;jak AL - 2 < 0, to wyjdz z procedury
	mov	byte ptr:Pozycja_Paletki_Lewej,al	;zapisz nowa pozycje
	jmp	koniec_reagowania
kolejny01:
	cmp	byte ptr:Z_wcisniety,1	;czy 'Z' (na d¢l) jest wcisniety?
	jnz	kolejny02		;...jak nie, to badaj kolejny klawisz
	mov	al,byte ptr:Pozycja_Paletki_Lewej	;AL = pozycja paletki
	add	al,2			;dodaj 2 do AL
	cmp	al,Wysokosc_Ekranu-Wysokosc_Paletki	;czy paletka za nisko?
	jae     koniec_reagowania	;...jesli tak, to wyjdz z procedury
	mov	byte ptr:Pozycja_Paletki_Lewej,al	;zapisz nowa pozycje
	jmp	koniec_reagowania
kolejny02:
	cmp	byte ptr:K_wcisniety,1	;analogicznie jak g¢ra w lewej paletce
	jnz	kolejny03
	mov	al,byte ptr:Pozycja_Paletki_Prawej
	sub	al,2
	jc	koniec_reagowania
	mov	byte ptr:Pozycja_Paletki_Prawej,al
	jmp	koniec_reagowania
kolejny03:
	cmp	byte ptr:M_wcisniety,1	;analogicznie jak d¢l w lewej paletce
	jnz	koniec_reagowania
	mov	al,byte ptr:Pozycja_Paletki_Prawej
	add	al,2
	cmp	al,Wysokosc_Ekranu-Wysokosc_Paletki
	jae     koniec_reagowania
	mov	byte ptr:Pozycja_Paletki_Prawej,al
koniec_reagowania:
	ret

;-----------------------------------------------------------------------------

zbadaj_jaki_klawisz_wcisniety:
	mov	byte ptr:A_Wcisniety,0	;zakladamy, ze zaden klawisz nie
	mov	byte ptr:Z_Wcisniety,0 	;  zostal wcisniety (zmienne maja
	mov	byte ptr:K_Wcisniety,0	; wartosc zero)
	mov	byte ptr:M_Wcisniety,0
	mov	byte ptr:Escape_Wcisniety,0

	;komentarz dodatkowy: dlaczego pisze np. mov byte ptr:M_Wcisniety,0
	;a nie po prostu mov M_Wcisniety,0?... A dlatego, ze kompilator nie
	;wie (do definicja zmiennych jest na koncu programu), czy zmienna
	;M_Wcisniety jest bajtem czy slowem (slowo=2 bajty), i gubi sie,
	;wypisujac blad. Piszac "byte ptr:" dajemy mu znac, ze to jest
	;bajt. Gdybysmy napisali "word ptr:", to byloby slowo.

	mov	al,Kod_Klawisza
	cmp	al,Escape	;czy moze 'Escape'?
	jnz	nastepny01
	mov	byte ptr:Escape_Wcisniety,1
nastepny01:
	cmp	al,A		;czy moze 'A'?
	jnz	nastepny02
	mov	byte ptr:A_Wcisniety,1
nastepny02:
	cmp	al,Z		;czy moze 'Z'?
	jnz	nastepny03
	mov	byte ptr:Z_Wcisniety,1
nastepny03:
	cmp	al,K		;czy moze 'K'?
	jnz	nastepny04
	mov	byte ptr:K_Wcisniety,1
nastepny04:
	cmp	al,M		;czy moze 'M'?
	jnz	koniec_badania
	mov	byte ptr:M_Wcisniety,1
koniec_badania:
	ret


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

Kod_Klawisza 		    	db    ?
Wektor_Do_Starego_Przerwania	dd    ?
Escape				equ   1
Spacja				equ  57
A				equ  30
Z				equ  44
K	      			equ  37
M				equ  50
Escape_Wcisniety		db    ?
A_Wcisniety			db    ?
Z_Wcisniety			db    ?
K_Wcisniety			db    ?
M_Wcisniety			db    ?

Pozycja_Paletki_Lewej		db    ?
Pozycja_Paletki_Prawej		db    ?

