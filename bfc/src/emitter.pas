unit emitter;

interface

const
  EMITTER_NASM = 1;
  EMITTER_GAS = 2;

procedure emitter_init(fname : string);
procedure emitter_done;

procedure emitter_start;
procedure emitter_end;
procedure emitter_set_syntax(n : integer);
procedure emitter_inc(n : integer);
procedure emitter_dec(n : integer);
procedure emitter_add(n : integer);
procedure emitter_sub(n : integer);
procedure emitter_print;
procedure emitter_call(s : string);
procedure emitter_while_begin(n : integer);
procedure emitter_while_end(n : integer);

implementation

uses bfcutil;

var
  fout : text;
  asm_style : integer;
  bf_data_size : integer;
  bf_stack_size : integer;
  while_num : integer;

procedure emitter_start;
begin
  WriteLn(fout, '; Generated by BFC (Brainfuck 32-Bit Compiler)');
  WriteLn(fout);
{   emit_program;}
  WriteLn(fout, 'EXTERN bf_init');
  WriteLn(fout, 'EXTERN bf_print');
  WriteLn(fout, 'EXTERN bf_exit');
  WriteLn(fout, 'EXTERN bf_read');
  WriteLn(fout, 'EXTERN _end');
  WriteLn(fout);
  WriteLn(fout, 'SEGMENT .text USE32');
  WriteLn(fout, '   GLOBAL _start');
  WriteLn(fout, '_start:');
{  WriteLn(fout, '   mov   eax, stack_end');
  WriteLn(fout, '   mov   esp, eax');}
{  WriteLn(fout, '   sub   eax, ', bf_data_size+bf_stack_size);}
  WriteLn(fout, '   mov   ebp, data_start');
  WriteLn(fout, '   call  bf_init');
  WriteLn(fout);
  WriteLn(fout, 'clear:');
  WriteLn(fout, '   mov   edi, ebp');
  WriteLn(fout, '   add   edi, ', bf_data_size);
  WriteLn(fout, '   mov   ecx, ', bf_data_size div 4);
  WriteLn(fout, '   xor   eax, eax');
  WriteLn(fout, '   std');
  WriteLn(fout, '   rep stosd');
  WriteLn(fout);
  WriteLn(fout, 'main:');
end;

procedure emitter_end;
begin
  WriteLn(fout);
  WriteLn(fout, '   call  bf_exit');
  WriteLn(fout);
  WriteLn(fout, 'SEGMENT .bss USE32');
	WriteLn(fout, 'GLOBAL data_start');
	WriteLn(fout, 'data_start:');
  WriteLn(fout, '   resd  ', bf_data_size div 4);
  WriteLn(fout, 'stack:');
  WriteLn(fout, '   resb  ', bf_stack_size);
  WriteLn(fout, 'stack_end:');
  Writeln(fout);
  WriteLn(fout, '; *** End Of File ***');
end;

procedure emitter_set_syntax(n : integer);
begin
	asm_style := n;
end;

procedure emitter_inc(n : integer);
begin
  if n = 1 then WriteLn(fout, '   inc   ebp')
  else WriteLn(fout, '   add   ebp, ', n);
end;

procedure emitter_dec(n : integer);
begin
  if n = 1 then WriteLn(fout, '   dec   ebp')
  else WriteLn(fout, '   sub   ebp, ', n);
end;

procedure emitter_add(n : integer);
begin
  if n = 1 then WriteLn(fout, '   inc   byte [ebp]')
  else WriteLn(fout, '   add   byte [ebp], ', n);
end;

procedure emitter_sub(n : integer);
begin
  if n = 1 then WriteLn(fout, '   dec   byte [ebp]')
  else WriteLn(fout, '   sub   byte [ebp], ', n);
end;

procedure emitter_call(s : string);
begin
  WriteLn(fout, '   call ', s);
end;

procedure emitter_while_begin(n : integer);
begin
  WriteLn(fout, '.L', n, ':');
  WriteLn(fout, '   cmp   byte [ebp], 0');
  WriteLn(fout, '   jnz   .LC', n);
  WriteLn(fout, '   jmp   .LE', n);
  WriteLn(fout, '.LC', n, ':');
end;

procedure emitter_while_end(n : integer);
begin
  WriteLn(fout, '   jmp   .L', n);
  WriteLn(fout, '.LE', n, ':');
  WriteLn(fout);
end;

procedure emitter_print;
begin
	WriteLn(fout, '   mov   eax, [ebp]');
	WriteLn(fout, '   push  eax');
	emitter_call('bf_print');
end;

procedure emitter_init(fname : string);
begin
  asm_style := EMITTER_NASM;
  bf_data_size := 30000;
  bf_stack_size := 16000;

  bf_data_size := bf_data_size div 4;
  bf_data_size := bf_data_size * 4;

  while_num := 0;

  assign(fout, get_filename(fname)+'.asm');
  rewrite(fout);
end;

procedure emitter_done;
begin
  close(fout);
end;

begin
end.