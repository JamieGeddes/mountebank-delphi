unit Mb.Process;

interface

uses
  Winapi.Windows;


type
TMbProcess = class(TObject)
  private
    FProcessInfo: TProcessInformation;

    FActive: Boolean;

    function GetCommand: string;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;
end;

implementation

uses
  System.SysUtils,

  Mb.Exceptions;


{ TMbProcess }

constructor TMbProcess.Create;
begin
  inherited;

  FActive:= False;
end;

destructor TMbProcess.Destroy;
begin
  if(FActive) then Stop;

  inherited;
end;

procedure TMbProcess.Start;

var
  startupInfo: TStartupInfo;
  command: string;

begin
  if(FActive) then raise EMbProcessAlreadyRunning.Create;

  FillMemory(@startupInfo, SizeOf(startupInfo), 0);

  startupInfo.cb:= sizeof(startupInfo);

  command:= GetCommand;

  FActive:= CreateProcess(
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

function TMbProcess.GetCommand: string;
var
  cmdPath: string;

begin
  cmdPath:= GetEnvironmentVariable('COMSPEC');

  Result:= cmdPath + ' /K mb';
end;


procedure TMbProcess.Stop;

var
  exitCode: Cardinal;

begin
  TerminateProcess(FProcessInfo.hProcess, exitCode);

  CloseHandle(FProcessInfo.hProcess );

  CloseHandle(FProcessInfo.hThread );

  FActive:= False;
end;


end.
