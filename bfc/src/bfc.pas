{ A Brainfuck compiler }

program bfc;

uses parser, bfcutil, dos;

const
  DATA_SIZE = 30000;
  STACK_SIZE = 4000;

var
  fname : string;

  opt_quiet: boolean;
  opt_fname: string;
  opt_asm : boolean;
  opt_link : boolean;
  opt_sin : boolean;
	bfc_home : string;
	
procedure WriteLnq(s : string);
begin
  if not opt_quiet then WriteLn(s);
end;


procedure compile;
begin
  WriteLnq('Compiling '+opt_fname);

  parser_init(opt_fname);
  parser_run;

end;


procedure assemble;
begin
  WriteLnq('Assembling '+fname);
{  exec('/usr/bin/nasm ', fname+'.asm -f elf');}

  exec(GetEnv('COMSPEC'), '/C nasmw '+fname+'.asm -f win32');
end;


procedure link;
var
	s : string;
begin
  WriteLnq('Linking '+fname);
{  exec('/usr/bin/ld ', fname+'.o /home/bernd/bfc/lib/bflib_linux.o -o '+fname);}
	s := '/C alink -c -oPE -m -subsys con -entry _start '+fname+' '+
					bfc_home+'\lib\bflib_win32.obj '+bfc_home+'\lib\win32.lib';
				
	exec(GetEnv('COMSPEC'), s);
end;


procedure print_usage;
begin
  WriteLn('BFC Brainf*** compiler V[0.0.1] - 2002 by Bernd Boeckmann');
  WriteLn('Send bugreports to <bboeckmann@gmx.de>');
  WriteLn;
  WriteLn('Usage: bfc {options} filename');
  WriteLn;
  WriteLn('Optionlist:');
  WriteLn('   -q     be quiet');
  WriteLn('   -c     compile only');
  WriteLn('   -a     compile and assemble only');
{   WriteLn('   -sin   read from stdin');}
  halt;
end;

procedure print_info;
begin
  WriteLn('BFC Brainf*** compiler V[0.0.1] - 2002 by Bernd Boeckmann');
  WriteLn('Send bugreports to <bboeckmann@gmx.de>');
  WriteLn;
end;


procedure parse_args;
var
  i : integer;
  fname_set : boolean;

begin
  opt_quiet := false;
  opt_sin := false;
  opt_asm := true;
  opt_link := true;

  fname_set := false;

  for i := 1 to ParamCount do
  begin
    if ParamStr(i) = '-q' then opt_quiet := true
    else
      if ParamStr(i) = '-h' then print_usage
      else
        if ParamStr(i) = '-c' then opt_asm := false
        else
          if ParamStr(i) = '-a' then opt_link := false
          else
            if ParamStr(i) = '-sin' then opt_sin := true
            else
            begin
              opt_fname := ParamStr(i);
              fname_set := true;
            end;
  end;

  if not fname_set then print_usage
  else fname := get_filename(opt_fname);
end;

procedure init;
begin
{	emitter_set_syntax(EMITTER_GAS);}
	bfc_home := GetEnv('BFC_HOME');
	if bfc_home = '' then begin
		WriteLn('Environment Variable BFC_HOME not set');
		WriteLn;
		WriteLn('Aborting...');
		halt(1);
	end;
end;


begin
  init;
  parse_args;

  if not opt_quiet then print_info;

  compile;
  if opt_asm then
  begin
    assemble;
    if opt_link then link;
  end;

  WriteLnq('Done.');
end.