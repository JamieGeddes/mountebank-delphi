unit Mb.Imposter;

interface

uses
  System.Generics.Collections,
  superobject,
  Mb.Stub,
  Mb.Response;


type
  TMbImposter = class abstract
  private
    FPort: integer;
    FName: string;

    FStubs: TList<TMbStub>;

    FDefaultResponse: TMbResponse;

    procedure AddJsonForStubs(const json: ISuperObject);

  protected
    FProtocol: string;

  public
    constructor Create;
    destructor Destroy; override;

    procedure AddJson(const json: ISuperObject);

    function OnPort(const port: integer): TMbImposter;
    function WithName(const name: string): TMbImposter;

    property Port: integer read FPort write FPort;
    property Protocol: string read FProtocol;

    property Stubs: TList<TMbStub> read FStubs;
    property DefaultResponse: TMbResponse read FDefaultResponse;
  end;

implementation

uses
  Mb.Constants;


{ TMbImposter }

constructor TMbImposter.Create;
begin
  inherited Create;

  FPort := DefaultPort;
  FProtocol := DefaultProtocol;

  FStubs := TObjectList<TMbStub>.Create(True);

  FDefaultResponse := TMbResponse.Create;
end;

destructor TMbImposter.Destroy;
begin
  FDefaultResponse.Free;
  FStubs.Free;

  inherited;
end;

function TMbImposter.OnPort(const port: integer): TMbImposter;
begin
  FPort := port;

  Result := Self;
end;

function TMbImposter.WithName(const name: string): TMbImposter;
begin
  FName := name;

  Result := Self;
end;

procedure TMbImposter.AddJson(const json: ISuperObject);
begin
  json.I['port'] := FPort;
  json.S['protocol'] := FProtocol;
  json.S['name'] := FName;

  AddJsonForStubs(json);
end;

procedure TMbImposter.AddJsonForStubs(const json: ISuperObject);
var
  stub: TMbStub;
  stubsJson: ISuperObject;
  stubJson: ISuperObject;
begin
  stubsJson := TSuperObject.Create(stArray);
  json.O['stubs'] := stubsJson;

  for stub in Stubs do
  begin
    stubJson := TSuperObject.Create;
    stub.AddJson(stubJson);

    stubsJson.AsArray.Add(stubJson);
  end;
end;

end.
