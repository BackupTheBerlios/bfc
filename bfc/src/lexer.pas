unit lexer;

interface

const
  TOK_END = 0;
  TOK_INC = 1;
  TOK_DEC = 2;
  TOK_PLUS = 3;
  TOK_MINUS = 4;
  TOK_PRINT = 5;
  TOK_READ = 6;
  TOK_LOOPO = 7;
  TOK_LOOPC = 8;
  TOK_NONE = 99;

procedure lexer_init(fname : string);
function lexer_next : integer;
function lexer_look : integer;
procedure lexer_skip;

implementation

const
  MAX_BUFFER = 64000;

type
  buffer = array[1..MAX_BUFFER] of char;

var
  buf : buffer;
  len : integer;
  pos : integer;

procedure read_file(fname : string);
var
  f : text;
  i : integer;
begin
  i := 1;

   {$I-}
  assign(f, fname);
  reset(f);

  if IOResult <> 0 then
  begin
    WriteLn('ABORT: File ', fname, ' not found!');
    halt(1);
  end;

  while not eof(f) do
  begin
    read(f, buf[i]);
    inc(i);
  end;

   {$I+}

  len := i-1;
  pos := 1;
end;

procedure sin_read_file;
var
  i : integer;
begin
  i := 1;

  while not eof do
  begin
    read(buf[i]);
    inc(i);
  end;
  len := i-1;
  pos := 1;

end;

procedure lexer_init(fname : string);
begin
  read_file(fname);
end;

function lexer_next : integer;
var
  tok : integer;
begin
  tok := TOK_NONE;

  repeat
    if pos > len then
    begin
      tok := TOK_END;
      inc(pos);
      break;
    end;

    case buf[pos] of
      '>' : tok := TOK_INC;
      '<' : tok := TOK_DEC;
      '+' : tok := TOK_PLUS;
      '-' : tok := TOK_MINUS;
      '.' : tok := TOK_PRINT;
      ',' : tok := TOK_READ;
      '[' : tok := TOK_LOOPO;
      ']' : tok := TOK_LOOPC;
    end;
    inc(pos);
  until tok <> TOK_NONE;
  lexer_next := tok;
end;

function lexer_look : integer;
begin
  lexer_look := lexer_next;
  dec(pos);
end;

procedure lexer_skip;
begin
  inc(pos);
end;


begin
end.
