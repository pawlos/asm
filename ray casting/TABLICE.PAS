program tablicownowanie_wartosci_funkcji;
uses crt;
var tan_table:array[0..1920] of longint;
    inv_tan_table:array[0..1920] of longint;
    cos_table:array[0..1920] of longint;
    sin_table:array[0..1920] of longint;
    inv_cos:array[0..1920] of longint;
    inv_sin:array[0..1920] of longint;
    fish_table:array[0..1920] of longint;

    plik1,plik2,plik3:text;
    kat,skala,i:longint;
    alpha2,alpha,tan:real;
    tan_val:longint;
    inv_tan:longint;
function tg(alpha:real):real;
begin
     if cos(alpha)<>0 then
      tg:=sin(alpha)/cos(alpha);
end;

begin
     skala:=$10000; {2^13}
     assign(plik1,'tangens.dat');
     assign(plik2,'sincos.dat');
     rewrite(plik1);
     rewrite(plik2);
     for i:=0 to 1920 do
      begin
       tan_table[i]:=0;
       inv_tan_table[i]:=0;
      end;
     alpha:=0.0019;
     Writeln('Tablicowanie warto˜ci funkcji tangens');
     for i:=0 to 1920 do
      begin
       {alpha:=(3.272e-4)+i*2*Pi/1920;}
       alpha2:=(2*alpha*pi)/360;
       tan:=tg(alpha2);
       tan_val:=trunc(tan*skala); {2^10}
       tan_table[i]:=tan_val;
       inv_tan_table[i]:=trunc((1/tan)*skala);
       inv_cos[i]:=trunc((1/cos(alpha2))*skala);
       inv_sin[i]:=trunc((1/sin(alpha2))*skala);
       cos_table[i]:=trunc(cos(alpha2)*skala);
       sin_table[i]:=trunc(sin(alpha2)*skala);
       alpha:=alpha+0.1875
      end;
      kat:=160;
      for i:=0 to 159 do
       begin
        fish_table[i]:=trunc(sin((480-kat)*2*pi/1920)*skala);
        dec(kat);
       end;
      for i:=160 to 319 do
       begin
        fish_table[i]:=trunc(sin((480-kat)*2*pi/1920)*skala);
        inc(kat);
       end;
      write(plik1,'tangens ');
       for i:=0 to 1920 do
        writeln(plik1,'dd ',tan_table[i]);
      write(plik1,'inv_tan ');
       for i:=0 to 1920 do
        writeln(plik1,'dd ',inv_tan_table[i]);
      write(plik1,'fish_table ');
      for i:=0 to 319 do
        writeln(plik1,'dd ',fish_table[i]);
      close(plik1);
      write(plik2,'inv_sin ');
       for i:=0 to 1920 do
        writeln(plik2,'dd ',inv_sin[i]);
      write(plik2,'inv_cos ');
       for i:=0 to 1920 do
        writeln(plik2,'dd ',inv_cos[i]);
      write(plik2,'cosinus ');
       for i:=0 to 1920 do
        writeln(plik2,'dd ',cos_table[i]);
     write(plik2,'sinus ');
       for i:=0 to 1920 do
        writeln(plik2,'dd ',sin_table[i]);
        close(plik2);
end.