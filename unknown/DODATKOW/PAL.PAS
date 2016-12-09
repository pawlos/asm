program pal;
uses crt;
var
liczba,x,y : integer;
zero,red,green,blue : byte;
src:file of byte;
trg:file of byte;
begin
  if paramcount<>2 then
  begin
   Write('Brak parametr¢w');
   halt(1);
  end;
  assign(src,paramstr(1));
  assign(trg,paramstr(2));
  reset(src);
  rewrite(trg);
  Write('Podaj liczb© kolor¢w; ');
  Readln(liczba);
    for x:=1 to 54 do
      read(src,zero);
    for x:=1 to liczba do
      begin
        read(src,blue);
        read(src,green);
        read(src,red);
        read(src,zero);
        red:=red shr 2;
        green:=green shr 2;
        blue:=blue shr 2;
        write(trg,red,green,blue);
      end;
  close(src);
  close(trg);
end.
