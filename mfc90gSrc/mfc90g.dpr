library mfc90g;

(*
    Gravindo RO Client mfc90g DLL Proxy module
    Copyright (C) Thiekus 2017
    Coded by Thiekus (thekill96[at]gmail[dhot]com)
	
	This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 2
    of the License, or (at your option) any later version.
	
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with this program; if not, write to the Free Software
	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
	
*)

uses
  ScaleMM2,
  Windows;

{$R *.res}

const
  TargetLib = 'ROHack.dll';
  RealLib = 'mfc90h.dll';

var
  ptr_test: Pointer = nil;
  RealModule  : HMODULE = 0;
  TargetModule: HMODULE = 0;

procedure test; assembler;
asm
  jmp dword ptr [ptr_test]
end;

procedure InitLibrary;
begin
  // Load dulu target yang mau diinject
  TargetModule:= LoadLibrary(PChar(TargetLib));
  if TargetModule = 0 then
    MessageBox(0, PChar('Gagal memuat dll target '+TargetLib), PChar('Error'), MB_ICONERROR or MB_APPLMODAL);
  // Load mfc90g.dll yang udah dibelokkan namanya
  RealModule:= LoadLibrary(PChar(RealLib));
  if RealModule = 0 then
    MessageBox(0, PChar('Gagal memuat dll asli '+RealLib), PChar('Error'), MB_ICONERROR or MB_APPLMODAL)
  else
    ptr_test:= GetProcAddress(RealModule, PChar('test'));
end;

procedure UninitLibrary;
begin
  // Bersih2 library...
  if RealModule <> 0 then
    FreeLibrary(RealModule);
  if TargetModule <> 0 then
    FreeLibrary(TargetModule);
end;

procedure DllMain(Reason: integer);
begin
  case Reason of
    DLL_PROCESS_ATTACH: InitLibrary;
    DLL_PROCESS_DETACH: UnInitLibrary;
  end;
end;

exports
  test;

begin

  DllProc:= @DllMain;
  DllProc(DLL_PROCESS_ATTACH);

end.
