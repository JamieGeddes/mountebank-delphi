unit Mb.Stub;

interface

uses
  System.Generics.Collections,
  superobject,
  Mb.Response;


type
  TMbStub = class
  private
    FResponses: TList<TMbResponse>;

  public
    constructor Create;
    destructor Destroy; override;

    function AddResponse: TMbResponse;

    procedure AddJson(const json: ISuperObject);

    property Responses: TList<TMbResponse> read FResponses;
  end;

implementation

{ TMbStub }

constructor TMbStub.Create;
begin
  inherited Create;

  FResponses := TObjectList<TMbResponse>.Create(True);
end;

destructor TMbStub.Destroy;
begin
  FResponses.Free;

  inherited;
end;

function TMbStub.AddResponse: TMbResponse;
var
  response: TMbResponse;
begin
  response := TMbResponse.Create;

  FResponses.Add(response);

  Result := response;
end;

procedure TMbStub.AddJson(const json: ISuperObject);
var
  response: TMbResponse;
  responsesJson: ISuperObject;
  responseJson: ISuperObject;
begin
  responsesJson := TSuperObject.Create(stArray);
  json.O['responses'] := responsesJson;

  for response in Responses do
  begin
    responseJson:= TSuperObject.Create;

    response.AddJson(responsejson);

    responsesJson.AsArray.Add(responseJson);
  end;
end;

end.
