unit Mb.Imposter;

interface

uses
  System.Generics.Collections,

  Mb.Stub,
  Mb.Response;


type
  TMbImposter = class
  private
    FPort: integer;
    FProtocol: string;

    FStubs: TList<TMbStub>;

    FDefaultResponse: TMbResponse;

  public
    constructor Create;
    destructor Destroy; override;

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

  FPort:= DefaultPort;
  FProtocol:= DefaultProtocol;

  FStubs:= TObjectList<TMbStub>.Create(True);

  FDefaultResponse:= TMbResponse.Create;
end;


destructor TMbImposter.Destroy;
begin
  FDefaultResponse.Free;
  FStubs.Free;

  inherited;
end;

end.
