unit Mb.Imposter;

interface

uses
  System.Generics.Collections,
  superobject,
  Mb.Stub,
  Mb.IsResponse;


type
  TMbImposter = class abstract
  private
    FPort: integer;
    FName: string;

    FStubs: TList<TMbStub>;

    FDefaultResponse: TMbIsResponse;

    procedure PopulateRequestStubs(const requestBody: ISuperObject);

  protected
    FProtocol: string;

  public
    constructor Create;
    destructor Destroy; override;

    procedure PopulateRequestBody(const requestBody: ISuperObject); virtual;

    function ListenOnPort(const port: integer): TMbImposter;
    function WithName(const name: string): TMbImposter;

    function AddStub: TMbStub;

    property Port: integer read FPort write FPort;
    property Protocol: string read FProtocol;

    property Stubs: TList<TMbStub> read FStubs;
    property DefaultResponse: TMbIsResponse read FDefaultResponse;
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

  FDefaultResponse := TMbIsResponse.Create;
end;

destructor TMbImposter.Destroy;
begin
  FDefaultResponse.Free;
  FStubs.Free;

  inherited;
end;

function TMbImposter.ListenOnPort(const port: integer): TMbImposter;
begin
  FPort := port;

  Result := Self;
end;

function TMbImposter.WithName(const name: string): TMbImposter;
begin
  FName := name;

  Result := Self;
end;

function TMbImposter.AddStub: TMbStub;
var
  stub: TMbStub;
begin
  stub := TMbStub.Create;

  FStubs.Add(stub);

  Result := stub;
end;

procedure TMbImposter.PopulateRequestBody(const requestBody: ISuperObject);
begin
  requestBody.I['port'] := FPort;
  requestBody.S['protocol'] := FProtocol;
  requestBody.S['name'] := FName;

  PopulateRequestStubs(requestBody);
end;

procedure TMbImposter.PopulateRequestStubs(const requestBody: ISuperObject);
var
  stub: TMbStub;
  stubsJson: ISuperObject;
  stubJson: ISuperObject;
begin
  stubsJson := TSuperObject.Create(stArray);
  requestBody.O['stubs'] := stubsJson;

  for stub in Stubs do
  begin
    stubJson := TSuperObject.Create;
    stub.PopulateRequestBody(stubJson);

    stubsJson.AsArray.Add(stubJson);
  end;
end;

end.
