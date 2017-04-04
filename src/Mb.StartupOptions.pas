unit Mb.StartupOptions;

interface

type
  TMbStartupOptions = class
  private
    FAllowInjection: Boolean;
    FDebug: Boolean;
    FMbPort: Integer;
    FLogFile: string;
    FLogLevel: string;
    FNoLogFile: Boolean;
    FAllowMockVerification: Boolean;

  public
    constructor Create;

    function GetCommandString: string;

    function AllowInjection(const value: Boolean = True): TMbStartupOptions;
    function AllowMockVerification(const allow: Boolean = True): TMbStartupOptions;
    function Debug(const value: Boolean = True): TMbStartupOptions;
    function LogToFile(const logFilename: string): TMbStartupOptions;
    function NoLogFile: TMbStartupOptions;
    function RunOnPort(const port: integer): TMbStartupOptions;
    function WithLogLevel(const logLevel: string): TMbStartupOptions;
  end;

implementation

uses
  System.SysUtils,

  Mb.Constants;


{ TMbStartupOptions }

constructor TMbStartupOptions.Create;
begin
  inherited Create;

  FAllowInjection := False;
  FDebug := False;

  FMbPort := MbDefaultPort;

  FNoLogFile := False;

  FAllowMockVerification := False;
end;

function TMbStartupOptions.GetCommandString: string;
var
  sb: TStringBuilder;
begin
  sb := TStringBuilder.Create;

  try
    if(FAllowInjection) then sb.Append(' --allowInjection');

    if(FMbPort <> MbDefaultPort) then sb.Append(' --port ' + FMbPort.ToString);

    if(not FLogFile.IsEmpty) then sb.Append(' --logfile ' + FLogFile);

    if(FLogLevel <> LogLevels.Info) then sb.Append(' --logLevel ' + FLogLevel);

    if(FNoLogFile) then sb.Append(' --nologfile');

    if(FAllowMockVerification) then sb.Append(' --mock');

    Result := sb.ToString;
  finally
    sb.Free;
  end;
end;

function TMbStartupOptions.AllowInjection(const value: Boolean = True): TMbStartupOptions;
begin
  FAllowInjection := True;

  Result := Self;
end;

function TMbStartupOptions.AllowMockVerification(const allow: Boolean = True): TMbStartupOptions;
begin
  FAllowMockVerification := True;

  Result := Self;
end;

function TMbStartupOptions.Debug(const value: Boolean = True): TMbStartupOptions;
begin
  FDebug := value;

  Result := Self;
end;

function TMbStartupOptions.LogToFile(const LogFilename: string): TMbStartupOptions;
begin
  FLogFile := logFilename;

  Result := Self;
end;

function TMbStartupOptions.NoLogFile: TMbStartupOptions;
begin
  FNoLogFile := True;

  Result := Self;
end;

function TMbStartupOptions.RunOnPort(const port: integer): TMbStartupOptions;
begin
  FMbPort := port;

  Result := Self;
end;

function TMbStartupOptions.WithLogLevel(const logLevel: string): TMbStartupOptions;
begin
  FLogLevel := logLevel;

  Result := Self;
end;

end.
