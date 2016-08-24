;kompilacja tasm kopro4.asm /m2
;konsolidacja tlink /t /3 kopro4.obj
.386c
ASSUME cs:CODE
include d:\macro.zbr
CODE SEGMENT use16
     org 100h
Start:
       jmp      poczatek
       A      dd 0e0   ;przyrost kata w radianach
       Xsr    dd 160e0 ;X srodka okregu
       Ysr    dd 100e0 ;Y srodka okregu
       R      dd 0e0   ;promien
       del    dd 0.0047 ;przyrost kata (w radianach)
       dR     dd 1e0   ;przyrost promienia
       kolor  db 0     ;numer koloru(0)
poczatek:
       finit                     ;start koprocesora
       call    wypelnij_palete   ;wypelnij palete
       mov     ax,0013h          ;\
       int     10h               ; uruchom tryb 320x200x256c
       mov     ax,0a000h         ;\
       mov     es,ax             ; >es:di wsk. na seg:off ekranu
       xor     di,di             ;/
       call    wypelnij_ekran    ;zmien_kolor ekranu
       call    ustaw_palete      ;ustaw odpowiednie wartosci skladowych dla 50 kolorow
       fstcw status              ;pobierz stan koprocesora i wstaw do status
       or    status,0000110000000000b ;ustaw 11 i 10 bit (zaokraglanie przez obcinanie czesci ulamkowej);
       fldcw status              ;wstaw status do stanu
       mov   cx,2                ;licznik petli
pe2:
       push  cx                  ;odloz go
       mov   cx,50               ;nowy plicznik
petla:
       push  cx                 ;odloz go
       synch
       call  okrag              ;narysuj okrag
       fld   R                  ;zaladuj promien
       fadd dR                  ;zmieksz go o przyrost promienia
       fstp  R                  ;i zaladuj z powrotem do R
       inc   kolor              ;zwieksz nr koloru
       pop   cx                 ;odtworz licznik
loop   petla                    ;wykonaj cx razy
       mov     kolor,1          ;kolor=0
       pop     cx               ;pobierz licznik
loop   pe2                      ;wykonaj cx razy
rotacja:
       synch                    ;synchroznizuj z plamka
       push  cs                 ;\
       pop   ds                 ; >ds:si = seg:off pal
       lea   si,pal             ;/
       call  rotuj              ;rotuj palete
       push  cs                 ;\
       pop   ds                 ; >ds:si=seg off pal
       lea   si,pal             ;/
       call  ustaw_palete       ;ustaw ja
       mov     ah,01h           ;\
       int     16h              ; nacisnieto klawisz
       jz      rotacja          ;nie to skocz do rotacji
       mov     ax,0003h         ;\
       int     10h              ; tryb graficzny
       ret                      ;zakoncz program

wypelnij_palete PROC
       push     cs              ;\
       pop      es              ; >es:di=seg:off pal
       lea      di,pal          ;/
       mov      ch,51           ;mamy 50 kolorow(przed zmianami 51; 1 osobno)
       mov      bl,51           ;ilczba kolek (50)
wyp:
       mov      es:[di],0       ;wstaw 0 do czerwieni
       mov      es:[di+1],bl    ;wstaw bl do zieleni
       mov      es:[di+2],0     ;i znow 0 do niebieskiego
       add      di,3            ;skocz na nastepny kolor
       dec      bl              ;zmniejsz jego intensywnosc
loop   wyp                      ;wykonaj
       ret                      ;powrot
ENDP
wypelnij_ekran PROC
       mov cx,2         ;powtorz 4 razy
wyp_01:
       push cx
       mov cx,50
       mov ax,32h        ;piecdziesiat lini
wyp_02:
       push cx
       mov cx,320
       rep stosb
       dec ax
       pop cx
loop   wyp_02
       pop cx
loop   wyp_01
       mov cx,2
wyp_03:
       push cx
       mov  cx,50
       mov  ax,1
wyp_04:
       push cx
       mov  cx,320
       rep  stosb
       inc  ax
       pop  cx
loop   wyp_04
       pop cx
loop   wyp_03
       ret
ENDP
rotuj  PROC
       push     ds              ;\
       pop      es              ; >ds:si = seg:off+3 palety(drugi kolor w palecia)
       add      si,3            ;/
       mov      di,si           ;di:palete
       cld                      ;wyzeruj zn. kierunku
       lodsw                    ;odczytaj slowo(R,G)
       mov   bx,ax              ;bx:=ax(to slowo(R,G)
       lodsb                    ;odczytaj bajt(B)
       mov   dl,al              ;zapisz go w dl
       mov   cx,49*3            ;ilczba kolorow (49*3)
       rep   movsb              ;przesun palete
       mov   ax,bx              ;ax:=R,G
       stosw                    ;wstaw je na koniec
       mov   al,dl              ;al:=B
       stosb                    ;ostatni bajt
       ret                      ;powrot
ENDP
ustaw_palete PROC
       push  cs                 ;\
       pop   ds                 ; >ds:si=seg:off pal
       lea   si,pal             ;/
       mov   cl,52              ;liczba kolorow (51)
       mov   bl,51              ; licznik petli
ustaw:
       lodsb                    ;odczytaj Red
       mov   _R,al              ;wstaw do _R
       lodsb                    ;odczytaj Green
       mov   _G,al              ;wstaw do _G
       lodsb                    ;odczytaj B
       mov   _B,al              ;wstaw _B
       set_pal bl,_R,_G,_B      ;ustaw dla koloru bl i wartosci _R,_G,_B
       dec     bl               ;zmniejsz nr koloru
loop   ustaw
       ret                      ;powrot
ENDP
okrag PROC
;wzor(TPascal)
;X:=round(Xsr+R*cos(A));
;Y:=round(Ysr+R*sin(A));
       mov   cx,720+720         ;licznik petli(ilosc punktow na okregu)
rysuj:
       fld   A                  ;powiel
       fsincos                  ;oblicz jego sinus
       fstp   cos               ;zaladuj do sin
       fstp   sin               ;i zaladuj do cos
       fld   R                  ;zaladuj promien
       fmul   cos               ;pomnoz razy cosinus
       fadd   Xsr               ;dadaj wspolrzedna X srodka
       frndint                  ;zaokraglij
       fistp  X                 ;pobierz do X
       fld  R                   ;zaladuj R
       fmul  sin                ;pomnoz razy sinus
       fadd  Ysr                ;dodaj Y srodka
       frndint                  ;zaokraglij
       fistp Y                  ;wrzyc do Y
       mov   ax,Y               ;ax rowna sie Y
       mov   bx,Y               ;bx tez rowna sie Y
       shl   ax,8               ;ax:=Y*256
       shl   bx,6               ;bx:=Y*64
       add   ax,bx              ;ax:=ax+bx(ax:=Y*320);
       add   ax,X               ;dodaj takze X
       mov   di,ax              ;wstaw to do di
       mov   al,kolor           ;a do al kolor
       mov   es:[di],al         ;postaw punkt w es:[di] o kolorze zawartym w al
       fld  A                   ;zaladuj kat
       fadd del                 ;dodaj przyrost kata
       fstp A                   ;i pobierz do A
loop   rysuj                    ;wykonaj cx razy
       ret                      ;powrot do glownago programu
ENDP
pal  db 3*60 dup (?)            ;bufor na 50 kolorow
sin    dd ?                     ;na sinus kata
cos    dd ?                     ;i na cosinus
X      dw ?                     ;X punktu na okregu
Y      dw ?                     ;Y punktu na okregu
status dw ?                     ;status stanu koprocesora
_R     db ?                     ;\
_G     db ?                     ; >trzy skladowe R,G,B
_B     db ?                     ;/
CODE ENDS
END Start