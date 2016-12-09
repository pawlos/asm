program wyswietl;
uses crt;
var  plik:file of byte;
     nazwa:string;
     paleta:array [0..255,1..3] of byte; {R G B - skˆadowe}
     wartosc:byte;
     liczba,i,j,k,l:integer;

begin
     Write('Podaj nazw© pliku z palet¥: ');
     readln(nazwa);
     Write('podaj liczb© kolor¢w: ');
     readln(liczba);
     assign(plik,nazwa);
     reset(plik);
     for i:=0 to (liczba-1) do
      begin
       read(plik,wartosc);
       paleta[i,3]:=wartosc;
       read(plik,wartosc);
       paleta[i,2]:=wartosc;
       read(plik,wartosc);
       paleta[i,1]:=wartosc;
      end;
       asm;
        mov ax,$0013
        int $10
      end;
      for i:=0 to (liczba-1) do
       begin
        PORT[$3c8]:=i;  {nr koloru}
        PORT[$3c9]:=paleta[i,1]; {skˆadowe R G B}
        PORT[$3c9]:=paleta[i,2];
        PORT[$3c9]:=paleta[i,3];
      end;
      wartosc:=0;
        for j:=0 to (liczba div 16)-1 do
         begin
          for i:=0 to 15 do
           begin
            for l:=0 to 9 do
             begin
              for k:=0 to 19 do
              mem[$a000:320*(10*j+l)+(20*i+k)]:=wartosc;
             end;
           inc(wartosc);
           end;
         end;
      readkey;
      asm;
       mov ax,$0003
       int $10
      end;
end.