program sklej_palety;
{skleja dwie palety aby uzyska† wszystkie kolory ;)}
uses crt;
var paleta1:array[0..255,1..3] of byte; {docelowa}
    paleta2:array[0..255,1..3] of byte; {«r¢dˆowa}
    dodac:boolean;
    data:array[0..79*60] of byte; {data}
    dot_kolor,i,blad,roz1,roz2,roz3,ile_kolorow,LiczKol:integer;
    bajt:byte;
    source_file:file of byte;
    dest_file:file of byte;
    data_file:file of byte;
    wynik:text;
    data_name:string;
    source_name:string;
    dest_name:string;

procedure ZnajdzIZamien(jaki_zamienic:integer;kolor:integer);
var i:integer;
begin
    for i:=0 to (79*60-1) do
     begin
      if data[i]=jaki_zamienic then
         data[i]:=kolor;
     end;
end;


begin
     clrscr;
     Write('Podaj plik z palet¥ «r¢dˆow¥: ');
     readln(source_name);
     Write('Podaj plik z palet¥ docelow¥: ');
     readln(dest_name);
     Write('Podaj plik z danymi: ');
     readln(data_name);
     Write('Ile kolor¢w w palecie deocelowej: ');
     readln(ile_kolorow);
     Write('Podaj ile kolor¢w ju¾ jest zachowanych: ');
     readln(dot_kolor);
     Write('podaj blad: ');
     Readln(blad);
     assign(data_file,data_name);
     reset(data_file);
     assign(source_file,source_name);
     reset(source_file);
     assign(dest_file,dest_name);
     reset(dest_file);
     assign(wynik,'wynik.dat');
     rewrite(wynik);
     for LiczKol:=0 to (dot_kolor-1) do
      begin
        read(source_file,bajt);
        paleta1[LiczKol][1]:=bajt; {Red}
        read(source_file,bajt);
        paleta1[LiczKol][2]:=bajt; {green}
        read(source_file,bajt);
        paleta1[LiczKol][3]:=bajt; {Blue}
     end;
     for LiczKol:=0 to (ile_kolorow-1) do
      begin
        read(dest_file,bajt);
        paleta2[LiczKol][1]:=bajt;
        read(dest_file,bajt);
        paleta2[Liczkol][2]:=bajt;
        read(dest_file,bajt);
        paleta2[LiczKol][3]:=bajt;
     end;
     for i:=0 to (79*60-1) do
     begin
       read(data_file,bajt);
       data[i]:=bajt;
     end;
     for LiczKol:=0 to (ile_kolorow-1) do
      begin
       for i:=0 to dot_kolor do
        begin
        dodac:=false;
        roz1:=abs(paleta1[i][1]-paleta2[LiczKol][1]);
        roz2:=abs(paleta1[i][2]-paleta2[LiczKol][2]);
        roz3:=abs(paleta1[i][3]-paleta2[LiczKol][3]);
        if ((roz1<=blad) and (roz2<=blad) and (roz3<=blad)) then
        begin
        {mo¾na wstawi† nowy kolor}
        {zapisz ustawienie}
         Writeln(wynik,'Kolor nr. ',LiczKol,' jest r¢wny kolorowi ',i);
         ZnajdzIZamien(LiczKol,i); {znajduje i zamienia}
         end;
        end;
        if dodac then
        begin
         paleta1[dot_kolor][1]:=paleta2[LiczKol][1];
         paleta1[dot_kolor][2]:=paleta2[LiczKol][2];
         paleta1[dot_kolor][3]:=paleta2[LiczKoL][3];
         inc(dot_kolor);
        end;
     end;
     close(wynik);
     close(source_file);
     close(dest_file);
     close(data_file);
     assign(source_file,source_name);
     reset(source_file);
     for i:=0 to 255 do
      write(source_file,paleta1[i][1],paleta1[i][2],paleta1[i][3]);
     close(source_file);
     assign(data_file,data_name);
     reset(data_file);
     for i:=0 to (79*60-1) do
       write(data_file,data[i]);
     close(data_file);
end.