unit bfcutil;

interface
function get_filename(fname : string) : string;

implementation

function get_filename(fname : string) : string;
var
  i : integer;
  s : string;
begin
  i := 1;
  while (fname[i] <> '.') and (i <= length(fname)) do
  begin
    s[i] := fname[i];
    inc(i);
  end;

  SetLength(s, i-1); {s[0] := Chr(i-1);}
  get_filename := s;
end;

begin
end.
