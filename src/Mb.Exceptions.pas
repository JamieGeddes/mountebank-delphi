unit Mb.Exceptions;

interface

uses
  System.SysUtils;


type
  TMbException = class(Exception);

  TMbPortInUseException = class(TMbException)
  public
    constructor Create(const port: integer);
  end;

implementation

{ TMbPortInUseException }

constructor TMbPortInUseException.Create(const port: integer);
begin
  inherited CreateFmt('An imposter is already present on port %d', [ port]);
end;

end.
