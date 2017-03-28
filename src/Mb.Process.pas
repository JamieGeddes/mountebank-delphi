unit Mb.Process;

interface

uses
  Winapi.Windows,

  Mb.StartupOptions;


type
  {$M+}
  IMbProcess = interface
    ['{8DB86CD4-A5AC-4DBD-BD32-C388FE7BC448}']

    procedure Start;
    procedure StartWithOptions(const options: TMbStartupOptions);
    procedure Stop;
  end;
  {$M-}

  TMbProcess = class(TInterfacedObject, IMbProcess)
  private
    FProcessInfo: TProcessInformation;

    FActive: Boolean;

    function GetBasicCommand: string;

    function GetCommandWithOptions(const options: TMbStartupOptions): string;

    function StartNewProcess(const command: string): TProcessInformation;

    procedure EndProcess(const processInfo: TProcessInformation);

  public
    constructor Create;
    destructor Destroy; override;

    procedure Start;
    procedure StartWithOptions(const options: TMbStartupOptions);
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
  command: string;
begin
  if(FActive) then raise EMbProcessAlreadyRunning.Create;

  command:= GetBasicCommand;

  FProcessInfo := StartNewProcess(command);
end;

function TMbProcess.GetBasicCommand: string;
var
  cmdPath: string;
begin
  cmdPath:= GetEnvironmentVariable('COMSPEC');

  Result:= cmdPath + ' /K mb';
end;

procedure TMbProcess.StartWithOptions(const options: TMbStartupOptions);
var
  command: string;
begin
  if(FActive) then raise EMbProcessAlreadyRunning.Create;

  command := GetCommandWithOptions(options);

  FProcessInfo := StartNewProcess(command);
end;

function TMbProcess.GetCommandWithOptions(const options: TMbStartupOptions): string;
begin
  Result := getBasicCommand + options.GetCommandString;
end;

function TMbProcess.StartNewProcess(const command: string): TProcessInformation;
var
  processInfo: TProcessInformation;
  startupInfo: TStartupInfo;
begin
  FillMemory(@startupInfo, SizeOf(startupInfo), 0);

  startupInfo.cb:= sizeof(startupInfo);

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
              processInfo);

  Result := processInfo;
end;

procedure TMbProcess.Stop;
var
  requestMbCloseProcessInfo: TProcessInformation;
  command: string;
begin
  command := GetBasicCommand + ' command stop';

  requestMbCloseProcessInfo := StartNewProcess(command);

  EndProcess(FProcessInfo);
  EndProcess(requestMbCloseProcessInfo);

  FActive:= False;
end;

procedure TMbProcess.EndProcess(const processInfo: TProcessInformation);
var
  exitCode: Cardinal;
begin
  exitCode := 0;

  TerminateProcess(processInfo.hProcess, exitCode);

  Sleep(500);

  CloseHandle(processInfo.hProcess);

  Sleep(500);

  CloseHandle(processInfo.hThread);
end;


end.
