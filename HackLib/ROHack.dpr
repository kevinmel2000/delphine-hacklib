library ROHack;

(*
    Gravindo RO Client Main Hack Library
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
  System.SysUtils,
  Winapi.Windows,
  DDetours;

{$R *.res}

var
  // Modul library kernel32.dll dan User32.dll
  ModKernel : HMODULE = 0;
  ModUser   : HMODULE = 0;
  ModMsvcrt : HMODULE = 0;

  // Fungsi yang perlu di hook
  tramp_CreateMutexA : function(lpMutexAttributes: PSecurityAttributes; bInitialOwner: BOOL; lpName: PAnsiChar): THandle; stdcall = nil;
  tramp_OpenMutexA   : function(dwDesiredAccess: DWORD; bInheritHandle: BOOL; lpName: PAnsiChar): THandle; stdcall = nil;
  tramp_OpenProcess  : function(dwDesiredAccess: DWORD; bInheritHandle: BOOL; dwProcessId: DWORD): THandle; stdcall = nil;
  tramp_IsDebuggerPresent : function: BOOL; stdcall = nil;
  tramp_FindWindowA : function(lpClassName, lpWindowName: PAnsiChar): HWND; stdcall = nil;

function hook_CreateMutexA(lpMutexAttributes: PSecurityAttributes; bInitialOwner: BOOL; lpName: PAnsiChar): THandle; stdcall;
var
  NewName: AnsiString;
begin

  // Mengakali program yang nggak bisa multi instance
  // Jika named Mutex dibuka, tambahkan suffix dibelakang untuk membuat mutex yang unik untuk setiap process
  if lpName <> '' then
    begin
    NewName:= lpName + AnsiString(IntToStr(GetCurrentProcessId()));
    Result:= tramp_CreateMutexA(lpMutexAttributes, bInitialOwner, PAnsiChar(NewName));
  end
  else
    Result:= tramp_CreateMutexA(lpMutexAttributes, bInitialOwner, lpName);

end;

function hook_OpenMutexA(dwDesiredAccess: DWORD; bInheritHandle: BOOL; lpName: PAnsiChar): THandle; stdcall;
var
  NewName: AnsiString;
begin

  // Kira-kira sama seperti hook CreateMutexA diatas
  if lpName <> '' then
    begin
    NewName:= lpName + AnsiString(IntToStr(GetCurrentProcessId()));
    Result:= tramp_OpenMutexA(dwDesiredAccess, bInheritHandle, PAnsiChar(NewName));
  end
  else
    Result:= tramp_OpenMutexA(dwDesiredAccess, bInheritHandle, lpName);

end;

function hook_OpenProcess(dwDesiredAccess: DWORD; bInheritHandle: BOOL; dwProcessId: DWORD): THandle; stdcall;
begin

  // OpenProcess dengan process id milik sendiri, sehingga process lain tidak akan dicek :D
  Result:= tramp_OpenProcess(dwDesiredAccess, bInheritHandle, GetCurrentProcessId());

end;

function hook_IsDebuggerPresent: BOOL; stdcall;
begin

  // Paksa return ke false untuk menandakan debugger tidak ada :)
  Result:= False;

end;

function hook_FindWindowA(lpClassName, lpWindowName: PAnsiChar): HWND; stdcall;
begin

  // Nipu hasil bahwa gak ada instance window 'Ragnarok' lain yang berjalan
  if (lpClassName = 'Ragnarok') and (lpWindowName = 'Ragnarok') then
    Result:= 0
  else
    Result:= tramp_FindWindowA(lpClassName, lpWindowName);

end;

procedure InitLibrary;
begin

  // Hook API Kernel32.dll
  ModKernel:= GetModuleHandle('kernel32.dll');
  if ModKernel <> 0 then
    begin
    @tramp_CreateMutexA:= InterceptCreate(GetProcAddress(ModKernel, 'CreateMutexA'), @hook_CreateMutexA);
    @tramp_OpenMutexA:= InterceptCreate(GetProcAddress(ModKernel, 'OpenMutexA'), @hook_OpenMutexA);
    @tramp_OpenProcess:= InterceptCreate(GetProcAddress(ModKernel, 'OpenProcess'), @hook_OpenProcess);
    @tramp_IsDebuggerPresent:= InterceptCreate(GetProcAddress(ModKernel, 'IsDebuggerPresent'), @hook_IsDebuggerPresent);
  end;
  // Hook API User32.dll
  ModUser:= GetModuleHandle('User32.dll');
  if ModUser <> 0 then
    @tramp_FindWindowA:= InterceptCreate(GetProcAddress(ModUser, 'FindWindowA'), @hook_FindWindowA);

end;

procedure UninitLibrary;
begin

  InterceptRemove(@tramp_CreateMutexA);
  InterceptRemove(@tramp_OpenMutexA);
  InterceptRemove(@tramp_OpenProcess);
  InterceptRemove(@tramp_IsDebuggerPresent);
  InterceptRemove(@tramp_FindWindowA);

end;

procedure DllMain(Reason: integer);
begin
  case Reason of
    DLL_PROCESS_ATTACH: InitLibrary;
    DLL_PROCESS_DETACH: UnInitLibrary;
  end;
end;

begin

  DllProc:= @DllMain;
  DllProc(DLL_PROCESS_ATTACH);

end.
