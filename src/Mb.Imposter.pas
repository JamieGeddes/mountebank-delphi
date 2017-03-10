unit Mb.Imposter;

interface

uses
  System.Generics.Collections,
  superobject,
  Mb.Stub,
  Mb.Response;


type
  TMbImposter = class
  private
    FPort: integer;
    FProtocol: string;

    FStubs: TList<TMbStub>;

    FDefaultResponse: TMbResponse;

    procedure AddJsonForStubs(const json: ISuperObject);

  public
    constructor Create;
    destructor Destroy; override;

    procedure AddJson(const json: ISuperObject);

    property Port: integer read FPort write FPort;
    property Protocol: string read FProtocol write FProtocol;

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

procedure TMbImposter.AddJson(const json: ISuperObject);
begin
  json.I['port'] := FPort;
  json.S['protocol'] := FProtocol;

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
