unit Mb.Stub;

interface

uses
  System.Generics.Collections,
  superobject,
  Mb.Response,
  Mb.IsResponse,
  Mb.Predicate,
  Mb.EqualsPredicate;


type
  TMbStub = class
  private
    FResponses: TList<TMbResponse>;
    FPredicates: TList<TMbPredicate>;

  public
    constructor Create;
    destructor Destroy; override;

    function AddResponse: TMbIsResponse;

    function AddEqualsPredicate: TMbEqualsPredicate;

    procedure AddJson(const json: ISuperObject);

    property Responses: TList<TMbResponse> read FResponses;

    property Predicates: TList<TMbPredicate> read FPredicates;
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

function TMbStub.AddResponse: TMbIsResponse;
var
  response: TMbIsResponse;
begin
  response := TMbIsResponse.Create;

  FResponses.Add(response);

  Result := response;
end;

function TMbStub.AddEqualsPredicate: TMbEqualsPredicate;
var
  predicate: TMbEqualsPredicate;
begin
  predicate := TMbEqualsPredicate.Create;

  FPredicates.Add(predicate);

  Result := predicate;
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
