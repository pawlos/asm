program redukuj_liczbe_kolorow;
{redukuj© liczb© kolor¢w w palecie}
uses crt;
var liczb_kol:integer;
    paleta:array[0..255,1..3] of byte;
    zrodlo:file of byte;
    bajt:byte;

begin
     clrcsr;
     Write('Podaj nazw© pliku z palet¥: ');
