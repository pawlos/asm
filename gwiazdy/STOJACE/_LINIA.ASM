
_linia	PROC
	mov	dx,0a000h
	mov	es,dx
	xor	di,di
	mov	al,14
	mov	cx,321
p1:
	mov	es:[di],al
	mov	bx,di
	mov	di,64000
	sub	di,bx
	mov	es:[di],al
	mov	di,bx
	add	di,1
	push	cx
	mov	ah,86h
	mov	cx,0
	mov	dx,1535
	int	15h
	pop	cx
loop	p1
	mov	di,63360
	mov	al,14
	mov	cx,198
p2:
	mov	es:[di],al
	mov	bx,di
	mov	di,64000
	sub	di,bx
	sub	di,1
	mov	es:[di],al
	mov	di,bx
	sub	di,320
	push	cx
	mov	ah,86h
	mov	cx,0
	mov	dx,1535
	int	15h
	pop	cx
loop	p2
	ret
ENDP

