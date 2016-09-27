program skalowanie;
uses crt;
var
skala_tab:array[1..120*120] of longint;
i,skala:longint;
plik:text;

begin
     assign(plik,'skala.dat');
     rewrite(plik);
     for i:=1 to 100*100 do
      begin
        skala_tab[i]:=round((277*64)/i);
      end;
      write(plik,'skala ');
      for i:=1 to 100*100 do
       writeln(plik,'dd ',skala_tab[i]);
     close(plik);
end.



