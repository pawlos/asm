	call	przygotuj_rejestry
	call	ustaw_tryb_320_na_200

	mov	dx,OFFSET Napis_Powitalny   ;DX = adres napisu w pamieci komp.
	call	napisz_na_ekranie

	call	poczekaj_na_dowolny_klawisz

	call	ustaw_nowe_przerwanie_klawiatury
	call	wyczysc_ekran
	mov	byte ptr:Pozycja_Paletki_Lewej,Wysokosc_Ekranu/2
	mov	byte ptr:Pozycja_Paletki_Prawej,Wysokosc_Ekranu/2
	mov	word ptr:Pozycja_Pileczki_X,Szerokosc_Ekranu/2
	mov	word ptr:Pozycja_Pileczki_Y,Wysokosc_Ekranu/2
	call	wylosuj_przesuniecia

wlasciwa_gra:
	cmp	byte ptr:Escape_Wciskany,1  ;czy gracz chce zakonczyc gre?
	jz	koniec_gry		;...jesli tak, to skocz do konca gry
	call	zareaguj_w_zaleznosci_od_klawisza
	call	porusz_pilka
	call	wyczysc_bufor_szybko
	call	narysuj_linie
	call	narysuj_paletki_w_buforze
	call	narysuj_pileczke
	call	poczekaj_na_przerwanie_pionowe
	call	narysuj_bufor_na_ekranie
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

narysuj_bufor_na_ekranie:
	push	es		;odstaw ES na stos
	mov	ax,0A000h	;AX = adres segmentu wideo
	mov	es,ax		;ES = adres segmentu wideo

	mov	cx,32000  	;ile sl¢w skopiowac? (32000x2=64000 bajt¢w)

	mov	di,0		;w jaki adres wpisywac?
	mov	si,OFFSET Bufor	;od jakiego adresu zaczac?
	rep	movsw		;polecenie to oznacza: wykonaj CX razy
				;  (czyli 64000) operacje movsw. Movsw oznacza
				;  wpisz slowo spod adresu DS:[SI] do adresu
				;  ES:[DI] (czyli kopiuj z jednego adresu
				;  do drugiego. Po kazdym wpisie DI i SI
				;  zwiekszaja sie o 2 ('w' to skr¢t od 'word',
				;  czyli slowo (2 bajty)).
	pop	es		;przywr¢c ES ze stosu
	ret

;-----------------------------------------------------------------------------

narysuj_linie:
	;rysujemy g¢rna linie
	mov	al,Szary	;rysujemy szarym kolorem
	mov	bx,OFFSET Bufor	;BX pokazuje na poczatek bufor
	mov	cx,Szerokosc_Ekranu	;CX = szerokosc ekranu
rysuj1:	mov	byte ptr:[bx],al;wpiszmy do bufora piksel o kolorze szarym
	inc	bx		;ustawmy BX na nastepna kom¢rke pamieci
	loop	rysuj1		;i wykonujmy petle

	;rysujemy dolna linie
	mov	bx,OFFSET Bufor	;BX pokazuje na poczatek bufor
	add	bx,64000	;powedrujmy na koniec bufora
	mov	cx,Szerokosc_Ekranu	;CX = szerokosc ekranu
rysuj2:	dec	bx		;zmiejszmy BX (rysujemy do tylu)
	mov	byte ptr:[bx],al;wpiszmy do bufora piksel o kolorze szarym
	loop	rysuj2		;i wykonujmy petle

	;rysujemy naraz trzy linie pionowe
	mov	bx,OFFSET Bufor	;BX pokazuje na poczatek bufor
	mov	cx,Wysokosc_Ekranu	;CX = wysokosc ekranu
rysuj3:	mov	byte ptr:[bx],al;wpiszmy do bufora piksel o kolorze szarym
	add	bx,Szerokosc_Ekranu/2	;skok na srodek "ekranu"
	mov	byte ptr:[bx],al;narysuj piksel srodkowej linii
	add	bx,Szerokosc_Ekranu/2-1	;skok na koniec ekranu
	mov	byte ptr:[bx],al;narysuj piksel prawej linii
	inc	bx		;ustawmy BX na nastepna kom¢rke pamieci
	loop	rysuj3		;i wykonujmy petle
	ret

;-----------------------------------------------------------------------------

narysuj_paletke:		;UWAGA! W DI musi byc adres, w jaki wpisywac
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
	ret

;-----------------------------------------------------------------------------

narysuj_paletki_w_buforze:

	;najpierw lewa paletka
	mov	al,Pozycja_Paletki_Lewej
	mov	ah,0		;AX = pozycja lewej paletki
	mov	cx,Szerokosc_Ekranu
	mul	cx		;AX = AX * CX
	mov	di,ax		;DI = AX, czyli DI = adres w pamieci wideo
	mov	ax,OFFSET Bufor	;AX = (wzgledny) adres bufora w pamieci
	add	di,ax		;o tyle zwiekszmy DI
	call	narysuj_paletke	;w DI mamy ustawienia ekranu dla lewej

	;a potem prawa paletka
	mov	al,Pozycja_Paletki_Prawej
	mov	ah,0		;AX = pozycja prawej paletki
	mov	cx,Szerokosc_Ekranu  ;niech CX = szerokosc ekranu (200)
	mul	cx		;pomn¢z AX * CX i zapisz wynik w AX
	mov	di,ax		;DI = AX, czyli DI = adres w pamieci wideo
	add	di,Szerokosc_Ekranu  ;przesunmy sie w prawo
	sub	di,Szerokosc_Paletki ;odejmijmy szerokosc paletki
	mov	ax,OFFSET Bufor	;AX = (wzgledny) adres bufora w pamieci
	add	di,ax		;o tyle zwiekszmy DI
	call	narysuj_paletke	;w DI mamy ustawienia ekranu dla prawej
				;  paletki
	ret

;-----------------------------------------------------------------------------

narysuj_pileczke:
	mov	ax,Pozycja_Pileczki_Y ;AX = Y pileczki (z X,Y)
	mov	cx,Szerokosc_Ekranu
	mul	cx		;AX = AX * CX
	mov	cx,Pozycja_Pileczki_X ;CX = X pileczki (z X,Y)
	add	ax,cx		;AX = obliczona poz. pileczki w pamieci ekranu
	mov	di,ax		;DI = AX, czyli DI = adres w pamieci wideo
	mov	ax,OFFSET Bufor	;AX = (wzgledny) adres bufora w pamieci
	add	di,ax		;o tyle zwiekszmy DI
	mov	cx,Wysokosc_Pileczki  ;wiadomo, niech CX = wysokosc pileczki
rysuj_pileczke:
	push	cx		;zapamietaj CX (odl¢z na stos)
	mov	cx,Szerokosc_Pileczki ;a teraz niech CX = szerokosc pileczki
rysuj_linie_pileczki:
	mov	byte ptr es:[di],Rozowy  ;narysuj r¢zowy piksel
	inc	di		;zwieksz DI o 1 (czyli DI = DI + 1)
	loop	rysuj_linie_pileczki ;zmiejsz CX o 1, a jesli wciaz jest
				     ; wiekszy od 0, to skocz do linii
                                     ; rysuj_linie_pileczki
	pop	cx		;przywr¢c CX ze stosu (czyli CX = wysokosc p.)
	add	di,Szerokosc_Ekranu  ;dodaj do DI szerokosc ekranu
	sub	di,Szerokosc_Pileczki;...i odejmij szerokosc paletki
	loop	rysuj_pileczke  ;CX = CX - 1, i jesli CX > 0, to skocz
	ret

;-----------------------------------------------------------------------------

nowe_przerwanie_klawiatury:
	pushf			;odl¢z na stos znaczniki
	push	ax			;...i rejestr AX
	in	al,60h		;pobierz od komputera kod wcisnietego klawisza
	test    al,80h		;czy AL ma ¢smy, najwyzszy bit = 1?
	jnz	klawisz_zostal_puszczony	;jesli tak, to skocz
	cmp	al,A		;wcisniety 'A'?
	jnz	inny01
	mov	byte ptr:A_Wciskany,1
	jmp	koniec_przerwania
inny01:	cmp	al,Z		;wcisniety 'Z'?
	jnz	inny02
	mov	byte ptr:Z_Wciskany,1
	jmp	koniec_przerwania
inny02:	cmp	al,K		;wcisniety 'K'?
	jnz	inny03
	mov	byte ptr:K_Wciskany,1
	jmp	koniec_przerwania
inny03:	cmp	al,M		;wcisniety 'M'?
	jnz	inny04
	mov	byte ptr:M_Wciskany,1
	jmp	koniec_przerwania
inny04:	cmp	al,Escape	;wcisniety 'Escape'?
	jnz	koniec_przerwania
	mov	byte ptr:Escape_Wciskany,1
koniec_przerwania:
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
	pop	ax		;pobierz ze stosu rejestr AX
	popf			;...i znaczniki
	iret			;zakoncz przerwanie

klawisz_zostal_puszczony:
	and	al,01111111b	;wyczyscmy najwyzszy, ¢smy bit
	cmp	al,A		;puszczony 'A'?
	jnz	inny05
	mov	byte ptr:A_Wciskany,0
	jmp	koniec_przerwania
inny05:	cmp	al,Z		;puszczony 'Z'?
	jnz	inny06
	mov	byte ptr:Z_Wciskany,0
	jmp	koniec_przerwania
inny06:	cmp	al,K		;puszczony 'K'?
	jnz	inny07
	mov	byte ptr:K_Wciskany,0
	jmp	koniec_przerwania
inny07:	cmp	al,M		;puszczony 'M'?
	jnz	inny08
	mov	byte ptr:M_Wciskany,0
	jmp	koniec_przerwania
inny08:	cmp	al,Escape	;puszczony 'Escape'?
	jnz	koniec_przerwania
	mov	byte ptr:Escape_Wciskany,0
	jmp	koniec_przerwania


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

poczekaj_na_dowolny_klawisz:
	mov	ah,08h		;AH = 8
	int	21h		;wykonaj przerwanie MS DOS (czekaj na klawisz)
	ret

;-----------------------------------------------------------------------------

zmien_kierunek_Y:
	neg	cx		;zmien znak w liczby w CX (przesuniecie pilki)
	mov	word ptr:Przesuniecie_Y,cx
	jmp	porusz_pilka	;wlasciwie te linie moznaby wykasowac...

porusz_pilka:
	;najpierw czy ma sie odbic od g¢rnego lub dolnegu brzegu ekranu
	mov	ax,byte ptr:Pozycja_Pileczki_Y
	mov	cx,word ptr:Przesuniecie_Y
	add	ax,cx
	jle	zmien_kierunek_Y;jak pilka za bardzo do g¢ry, to skocz
	cmp	ax,Wysokosc_Ekranu-Wysokosc_Pileczki  ;moze za bardzo w d¢l?
	jae	zmien_kierunek_Y
	mov	word ptr:Pozycja_Pileczki_Y,ax

	;czy odbic sie od paletki?
	mov	ax,word ptr:Pozycja_Pileczki_X
	mov	cx,word ptr:Przesuniecie_X
	add	ax,cx
	;...sprawdzmy lewa paletke
	mov	dx,Szerokosc_Paletki-1 ;jest to jednoczesnie X-1 lewej paletki
	cmp	ax,dx		;czy X pileczki jest > X paletki
	ja	badaj_prawa	;jesli tak, to pilka poza zasiegiem
	mov	dl,Pozycja_Paletki_Lewej;Y paletki (teraz g¢rny brzeg paletki)
	mov	dh,0
	mov	bx,word ptr:Pozycja_Pileczki_Y
	add	bx,Wysokosc_Pileczki   ;BX = dolny brzeg pileczki
	cmp	bx,dx		;czy pileczka powyzej paletki?
	jb	prawy_zdobywa_punkt    ;..jesli tak, to lewy traci punkt
	add	dx,Wysokosc_Paletki    ;teraz mamy Y dolnego brzegu paletki
	sub	bx,Wysokosc_Pileczki   ;BX = g¢rny brzeg pileczki
	cmp	bx,dx		;czy pileczka ponizej paletki?
	ja 	prawy_zdobywa_punkt	;..jesli tak, to lewy traci punkt
	jmp	zmien_kierunek_w_zaleznosci_od_odbicia
badaj_prawa:	;...a teraz prawa
	mov	dx,Szerokosc_Ekranu-Szerokosc_Paletki+1; X+1 prawej paletki
	add	ax,Szerokosc_Pileczki	;AX = prawy brzeg pileczki
	cmp	ax,dx		;czy X pileczki jest < X paletki
	pushf			;na chwile odl¢zmy znaczniki na stos
	sub	ax,Szerokosc_Pileczki	;przywr¢cmy AX=nowa pozycja
	popf			;przywracamy znaczniki (wynik por¢wnania)
	jb	koniec_badania  ;jesli tak, to pilka poza zasiegiem
	mov	dl,Pozycja_Paletki_Prawej;Y paletki (teraz g¢rny brzeg palet.)
	mov	dh,0
	mov	bx,word ptr:Pozycja_Pileczki_Y
	add	bx,Wysokosc_Pileczki	;BX = dolny brzeg pileczki
	cmp	bx,dx		;czy pileczka powyzej paletki?
	jb	lewy_zdobywa_punkt	;..jesli tak, to prawy traci punkt
	add	dx,Wysokosc_Paletki	;teraz mamy Y dolnego brzegu paletki
	sub	bx,Wysokosc_Pileczki	;BX = g¢rny brzeg pileczki
	cmp	bx,dx		;czy pileczka ponizej paletki?
	ja	lewy_zdobywa_punkt	;..jesli tak, to prawy traci punkt
	jmp	zmien_kierunek_w_zaleznosci_od_odbicia
koniec_badania:
	mov	word ptr:Pozycja_Pileczki_X,ax
	ret

prawy_zdobywa_punkt:
	jmp	koniec_gry

lewy_zdobywa_punkt:
	jmp	koniec_gry

zmien_kierunek_w_zaleznosci_od_odbicia:
	;pamietajmy, ze w momencie wskoku do procedury
	;DX = Y dolnego brzegu paletki, BX = Y g¢rnego brzegu pileczki
	mov	di,0    	;wyzerujmy DI (za chwile sie przyda)
	sub	dx,Wysokosc_Paletki/2	;DX = Y srodka paletki
	add	bx,Wysokosc_Pileczki/2	;BX = Y srodka pileczki
	sub	dx,bx		;odejmijmy Y pileczki od Y paletki
	jnc	okay		;jak nie bylo klopot¢w, to skocz
	neg	dx		;...a jesli wynik byl ujemny, to zmien znak
	mov	di,1		;  oraz zaznacz jakos (np.DI = 1) ten fakt
okay:	mov	bx,OFFSET Strefy_Odbicia
szukaj:	mov	al,byte ptr[bx]	;AL = zakres strefy odbicia
	cmp	dl,al		;por¢wnajmy DL z AL
	jbe	strefa_okay	;jesli DL <= AL, to znalezlismy rodzaj odbicia
	add	bx,3		;przesunmy wskaznik na nastepna strefe
	jmp	szukaj		;...i szukamy dalej
strefa_okay:
	mov	ah,0		;wyzerujmy AH
	mov	al,byte ptr[bx+1]	;AL = nowe przesuniecie X
	mov	cx,word ptr:Przesuniecie_X	;CX = stare przesuniecie
	test	cx,8000h	;czy bylo dodatnie?
	jnz	znakok1		;...jesli nie, to omin zmiane znaku
	neg	ax		;...jesli tak, to zmien znak
znakok1:mov	word ptr:Przesuniecie_X,ax	;zapiszmy nowe przesuniecie
	;a teraz niezly numer: wiemy juz, czy odbic w lewo czy w prawo,
	;ale musimy jeszcze odbic pileczke w g¢re lub w d¢l. Zal¢zmy, ze jak
	;palatka uderza g¢rna pol¢wka, to w g¢re, a jak dolna, to w d¢l.
	;Kilkanascie linijek wyzej ustawilismy wartosc DI: w niej kryje sie
	;odpowiedz, kt¢ra pol¢wka uderzylismy...
	mov	ah,0		;wyzerujmy AH
	mov	al,byte ptr[bx+2]	;AL = nowe przesuniecie Y
	or  	di,di 		;DI = 0? (uderzenie g¢rna pol¢wka)?
	jnz     znakok2		;...jesli nie, to nie zmieniaj znaku w AX
	neg	ax		;...a jesli tak, to zmien znak nowego prz.Y
znakok2:mov	word ptr:Przesuniecie_Y,ax	;zapiszmy nowe przesuniecie
	jmp	porusz_pilka


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

wyczysc_bufor_szybko:
	mov	cx,32000  	;ile sl¢w wyczyscic? (32000x2=64000 bajt¢w)
	mov	ax,0000		;jaka liczba czyscic?
	mov	di,OFFSET Bufor	;od jakiego adresu zaczac
	rep	stosw		;polecenie to oznacza: wykonaj CX razy
				;  (czyli 64000) operacje stosw. Stosw oznacza
				;  wpisz AX w slowo o adresie DS:DI. Po kazdym
				;  wpisie DI zwieksza sie o 2 ('w' to skr¢t
				;  od 'word', czyli slowo (2 bajty)).
	ret


;-----------------------------------------------------------------------------

wylosuj_przesuniecia:
	mov	word ptr:Przesuniecie_X,1 ;zal¢zmy sobie
	mov	word ptr:Przesuniecie_Y,1 ;zal¢zmy sobie
        mov	ah,2Ch		;przerwanie MS-DOS: pobierz obecny czas
        int	21h		;(CH=godzina,CL=minuta,DH=sekunda,DL=1/100 s.)
				; ...praktycznie DH i DL to wartosci losowe...
	test    dl,1		;50% szans
	jz	nie_zmieniaj01
	mov	Przesuniecie_X,-1  ;wylosowalismy ujemne przesuniecie
nie_zmieniaj01:
	test    dh,1		;50% szans
	jz	nie_zmieniaj02
	mov	Przesuniecie_Y,-1  ;wylosowalismy ujemne przesuniecie
nie_zmieniaj02:			;w rezultacie mamy wylosowane przesuniecie
	ret

;-----------------------------------------------------------------------------

zakoncz_program:
	mov	ah,4Ch		;zaladuj liczbe 4Ch do g¢rnej pol¢wki rej. AX
	int	21h		;wykonaj przerwanie 21h (MS-DOS): wyjdz do DOS

;-----------------------------------------------------------------------------

zareaguj_w_zaleznosci_od_klawisza:
	cmp	byte ptr:A_Wciskany,1	;czy 'A' (do g¢ry) jest wcisniety?
	jnz	kolejny01               ;...jak nie, to badaj kolejny klawisz
	mov	al,byte ptr:Pozycja_Paletki_Lewej       ;AL = pozycja paletki
	sub	al,2                    ;odejmij 2 od AL (o tyle przesuwamy)
	jc	kolejny01		;jak AL - 2 < 0, to wyjdz z procedury
	mov	byte ptr:Pozycja_Paletki_Lewej,al	;zapisz nowa pozycje
kolejny01:
	cmp	byte ptr:Z_Wciskany,1	;czy 'Z' (na d¢l) jest wcisniety?
	jnz	kolejny02		;...jak nie, to badaj kolejny klawisz
	mov	al,byte ptr:Pozycja_Paletki_Lewej	;AL = pozycja paletki
	add	al,2			;dodaj 2 do AL
	cmp	al,Wysokosc_Ekranu-Wysokosc_Paletki	;czy paletka za nisko?
	jae     kolejny02		;...jesli tak, to wyjdz z procedury
	mov	byte ptr:Pozycja_Paletki_Lewej,al	;zapisz nowa pozycje
kolejny02:
	cmp	byte ptr:K_Wciskany,1	;analogicznie jak g¢ra w lewej paletce
	jnz	kolejny03
	mov	al,byte ptr:Pozycja_Paletki_Prawej
	sub	al,2
	jc	kolejny03
	mov	byte ptr:Pozycja_Paletki_Prawej,al
kolejny03:
	cmp	byte ptr:M_Wciskany,1	;analogicznie jak d¢l w lewej paletce
	jnz	koniec_reagowania
	mov	al,byte ptr:Pozycja_Paletki_Prawej
	add	al,2
	cmp	al,Wysokosc_Ekranu-Wysokosc_Paletki
	jae     koniec_reagowania
	mov	byte ptr:Pozycja_Paletki_Prawej,al
koniec_reagowania:
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
Rozowy				equ 058
Szary				equ 25


Szerokosc_Ekranu		equ 320
Wysokosc_Ekranu			equ 200
Szerokosc_Paletki		equ   6
Wysokosc_Paletki		equ  30
;oto strefy odbicia: zakres strefy, nowe przesuniecie X, nowe przesuniecie Y
Strefy_Odbicia			db    3,3,1	;strefa 3,1
				db    7,2,1	;strefa 2,1
				db   11,1,1	;strefa 1,1
				db   15,1,2	;strefa 1,2
				db   19,1,3	;strefa 1,3

Wektor_Do_Starego_Przerwania	dd    ?
Escape				equ   1
Spacja				equ  57
A				equ  30
Z				equ  44
K	      			equ  37
M				equ  50
Escape_Wciskany			db    ?
A_Wciskany			db    ?
Z_Wciskany			db    ?
K_Wciskany			db    ?
M_Wciskany			db    ?

Pozycja_Paletki_Lewej		db    ?
Pozycja_Paletki_Prawej		db    ?

Szerokosc_Pileczki      	equ   6
Wysokosc_Pileczki       	equ   6
Pozycja_Pileczki_X		dw    ?
Pozycja_Pileczki_Y		dw    ?
Przesuniecie_X			dw    ?
Przesuniecie_Y			dw    ?

Bufor				db 64000 dup(0)

