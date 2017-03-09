unit Mb.Stub;

interface

uses
  System.Generics.Collections,

  Mb.Response;


type
  TMbStub = class
  private
    FResponses: TList<TMbResponse>;

  public
    constructor Create;
    destructor Destroy; override;

    property Responses: TList<TMbResponse> read FResponses;
  end;

implementation

{ TMbStub }

constructor TMbStub.Create;
begin
  inherited Create;

  FResponses:= TObjectList<TMbResponse>.Create(True);
end;

destructor TMbStub.Destroy;
begin
  FResponses.Free;

  inherited;
end;

end.
