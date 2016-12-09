program pic;
uses crt;
var
  src,trg : file of byte;
  n : word;
  ch : byte;
  x,y:integer;
begin
  if paramcount<>2 then
  begin
   Writeln('Brak parametr¢w!!');
   halt(1);
  end;
  Writeln('Program do ripowania danych z bmp-ka');
  assign(src,paramstr(1));
  reset(src);
  assign(trg,paramstr(2));
  rewrite(trg);
  Write('Podaj rozdzielczo˜† x: ');
  Readln(x);
  Write('Podaj rozdzielczo˜† y: ');
  Readln(y);
  for n:=1 to 1078 do
    read(src,ch);
  for n:=1 to x*y do
    begin
      read(src,ch);
      write(trg,ch);
    end;
  close(src);
  close(trg);
end.

