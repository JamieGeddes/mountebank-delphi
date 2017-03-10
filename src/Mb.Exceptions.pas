unit Mb.Exceptions;

interface

uses
  System.SysUtils;


type
  EMbException = class(Exception);

  EMbProcessAlreadyRunning = class(EMbException)
  public
    constructor Create;
  end;

  EMbPortInUseException = class(EMbException)
  public
    constructor Create(const port: integer);
  end;

implementation

{ EMbProcessAlreadyRunning }

constructor EMbProcessAlreadyRunning.Create;
begin
  inherited Create('Mountebank process is already running');
end;

{ EMbPortInUseException }

constructor EMbPortInUseException.Create(const port: integer);
begin
  inherited CreateFmt('An imposter is already present on port %d', [ port]);
end;

end.
