
Start3:
	call	LoadFont
	call	PiszTekst

;***************************************************
;***************************************************
PiszTekst PROC
	mov	dx,0a000h
	mov	es,dx
	push	cs
	pop	ds
	;Policz offset punktu, od kt¢rego ma byç
	;wypisany tekst
	mov	ax,Y
	mov	bx,320
	mul	bx
	add	ax,X
	mov	di,ax
	lea	bx,txt   ;BX - offset wzglëdem TXT
PiszZnak:
	mov	al,cs:[bx]
	inc	bx
	cmp	al,0
	jne	NieKoniec
	jmp	Koniec
NieKoniec:
	xor	ah,ah
	;Policz offset znaku w tablicy FONT
	shl	ax,1
	shl	ax,1
	shl	ax,1
	shl	ax,1
	lea	si,FONT
	add	si,ax
	mov	cx,16
	mov	ah,kolor
	push	di
Linia:	
	push	di
	lodsb
	mov	dl,10000000b
	mov	dh,8
Kropka:
	test	al,dl      ;Jest punkt?
	jz	NieKropka
	mov	es:[di],ah
NieKropka:		
	inc	di
	shr	dl,1
	dec	dh
	jns	Kropka
	pop	di
	add	di,320
	loop	Linia
	pop	di
	add	di,9
	jmp	PiszZnak	
Koniec:
	ret
ENDP			

