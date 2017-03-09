unit Mb.ImposterBuilder;

interface

uses
  Mb.Imposter;

type
  TMbImposterBuilder = class
  private
    FImposter: TMbImposter;

    FPort: integer;
    FProtocol: string;
    FName: string;

  public
    constructor Create;

    function OnPort(const port: integer): TMbImposterBuilder;
    function WithProtocol(const protocol: string): TMbImposterBuilder;
    function WithName(const name: string): TMbImposterBuilder;

    function Build: TMbImposter;
  end;

implementation

{ TMbImposterBuilder }

constructor TMbImposterBuilder.Create;
begin
  inherited Create;

  FImposter:= TMbImposter.Create;
end;

function TMbImposterBuilder.OnPort(const port: integer): TMbImposterBuilder;
begin
  FPort:= port;

  Result:= Self;
end;

function TMbImposterBuilder.WithProtocol(const protocol: string): TMbImposterBuilder;
begin
  FProtocol:= Protocol;

  Result:= Self;
end;

function TMbImposterBuilder.WithName(const name: string): TMbImposterBuilder;
begin
  FName:= name;

  Result:= Self;
end;

function TMbImposterBuilder.Build: TMbImposter;
begin
  FImposter.Port:= FPort;
  FImposter.Protocol:= FProtocol;

  Result:= FImposter;
end;

end.
