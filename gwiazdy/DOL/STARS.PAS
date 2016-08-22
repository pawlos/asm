uses crt;


var plik:text;
    i:integer;
    offset:word;

begin;
      clrScr;
      assign(plik,'stars.dat');
      rewrite(plik);
      for i:= 1 to 1200 do
        begin
        offset:=320*random(200)+random(320);
        Write(plik,chr(lo(offset)),chr(hi(offset)));
        end;
      close(plik);
      Writeln('GOTOWE!');
      readkey;
end.