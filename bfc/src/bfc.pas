{ A Brainfuck compiler }

program bfc;

uses parser, bfcutil, emitter, dos;

const
  BFC_VERSION_STR = '0.0.9';
  
  DATA_SIZE = 30000;
  STACK_SIZE = 4000;

var
  fname : string;

  opt_quiet: boolean;
  opt_fname: string;
  opt_asm : boolean;
  opt_link : boolean;
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
  {$IFDEF LINUX}
{    exec(GetEnv('SHELL'), '-c "as '+fname+'.s -o '+fname+'.o"');}
    exec('/usr/bin/as', fname+'.s -o '+fname+'.o');
  {$ELSE}
    exec(GetEnv('COMSPEC'), '/C nasmw '+fname+'.asm -f win32');
  {$ENDIF}
end;


procedure link;
begin
  WriteLnq('Linking '+fname);
  {$IFDEF LINUX}
    exec('/usr/bin/ld ', fname+'.o /home/bernd/bfc/lib/bflib_linux.o -o '+fname);
  {$ELSE}
    s := '/C alink -c -oPE -m -subsys con -entry _start '+fname+' '+
					bfc_home+'\lib\bflib_win32.obj '+bfc_home+'\lib\win32.lib';
    exec(GetEnv('COMSPEC'), s);
  {$ENDIF}
end;


procedure print_usage;
begin
  WriteLn('BFC Brainf*** compiler V[',BFC_VERSION_STR,'] - 2002 by Bernd Boeckmann');
  WriteLn('Send bugreports etc. to <bfc-devel@lists.berlios.de>');
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
  WriteLn('Send bugreports etc. to <bfc-devel@lists.berlios.de>');
  WriteLn;
end;


procedure parse_args;
var
  i : integer;
  fname_set : boolean;

begin
  opt_quiet := false;
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
	bfc_home := GetEnv('BFC_HOME');
	if bfc_home = '' then begin
		WriteLn('Environment Variable BFC_HOME not set');
		WriteLn;
		WriteLn('Aborting...');
		halt(1);
	end;
	{$IFDEF LINUX}
		emitter_set_target(EMITTER_LINUX);
	{$ELSE}
		emitter_set_target(EMITTER_WIN32);
	{$ENDIF}
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
