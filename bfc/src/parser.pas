unit parser;

interface
procedure parser_init(fname : string);
procedure parser_run;

implementation

uses lexer, emitter;

var
  loops : integer;

procedure parser_error(s : string);
begin
  WriteLn('Error: ', s);
  halt;
end;

procedure stmt_inc;
var
  n : integer;
begin
  lexer_skip;

  n := 1;
  while lexer_look = TOK_INC do
  begin
    inc(n);
    lexer_skip;
  end;

  emitter_inc(n);
end;

procedure stmt_dec;
var
  n : integer;
begin
  lexer_skip;

  n := 1;
  while lexer_look = TOK_DEC do
  begin
    inc(n);
    lexer_skip;
  end;

  emitter_dec(n);
end;

procedure stmt_plus;
var
  n : integer;
begin
  lexer_skip;

  n := 1;
  while lexer_look = TOK_PLUS do
  begin
    inc(n);
    lexer_skip;
  end;

  emitter_add(n);

end;

procedure stmt_minus;
var
  n : integer;
begin
  lexer_skip;

  n := 1;
  while lexer_look = TOK_MINUS do
  begin
    inc(n);
    lexer_skip;
  end;

  emitter_sub(n);

end;


procedure stmt_print;
begin
  lexer_skip;

  emitter_print;
end;

procedure stmt_read;
begin
  lexer_skip;

  emitter_call('bf_read');
end;

procedure statements;

  procedure stmt_loop;
  var
    loop_num : integer;
  begin
    lexer_skip;

    loop_num := loops;
    inc(loops);

    emitter_while_begin(loop_num);

    statements;

    if lexer_look <> TOK_LOOPC then parser_error('] expected');
    lexer_skip;

    emitter_while_end(loop_num);


  end;

  procedure statement;
  begin
    case lexer_look of
      TOK_INC : stmt_inc;
      TOK_DEC : stmt_dec;
      TOK_PLUS : stmt_plus;
      TOK_MINUS : stmt_minus;
      TOK_PRINT : stmt_print;
      TOK_READ : stmt_read;
      TOK_LOOPO : stmt_loop;
    end;
  end;

begin
  while lexer_look in [TOK_INC .. TOK_LOOPO] do statement;
end;

procedure prog;
begin
  statements;
  if lexer_look <> TOK_END then parser_error('eof expected');
end;

procedure parser_init(fname : string);
begin
  loops := 0;

  lexer_init(fname);
  emitter_init(fname);
end;

procedure parser_run;
begin

  emitter_start;

  prog;

  emitter_end;
  emitter_done;
end;

begin
end.