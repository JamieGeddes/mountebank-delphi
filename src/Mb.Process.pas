unit Mb.Process;

interface

uses
  Winapi.Windows;


type
TMbProcess = class(TObject)
  private
    FProcessInfo: TProcessInformation;

  public
    procedure Start;
    procedure Stop;
end;

implementation

uses
  System.SysUtils;



procedure TMbProcess.Start;

var
  startupInfo: TStartupInfo;
  cmdPath: String;
  command: String;

begin
  FillMemory(@startupInfo, SizeOf(startupInfo), 0);

  startupInfo.cb:= sizeof(startupInfo);

  cmdPath:= GetEnvironmentVariable('COMSPEC');

  command:= cmdPath + ' /K mb';

  CreateProcess(
      Nil,
      PWideChar( command),
      Nil,
      Nil,
      False,
      CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS,
      Nil,
      Nil,
      startupInfo,
      FProcessInfo);
end;


procedure TMbProcess.Stop;

var
  exitCode: Cardinal;

begin
  TerminateProcess(FProcessInfo.hProcess, exitCode);

  CloseHandle(FProcessInfo.hProcess );

  CloseHandle(FProcessInfo.hThread );
end;


end.
