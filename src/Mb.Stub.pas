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

    procedure PopulateRequestResponses(const requestBody: ISuperObject);
    procedure PopulateRequestPredicates(const requestBody: ISuperObject);

  public
    constructor Create;
    destructor Destroy; override;

    function AddResponse: TMbIsResponse;

    function AddEqualsPredicate: TMbEqualsPredicate;

    procedure PopulateRequestBody(const requestBody: ISuperObject);
  end;

implementation

{ TMbStub }

constructor TMbStub.Create;
begin
  inherited Create;

  FResponses := TObjectList<TMbResponse>.Create(True);
  FPredicates := TObjectList<TMbPredicate>.Create(True);
end;

destructor TMbStub.Destroy;
begin
  FPredicates.Free;
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

procedure TMbStub.PopulateRequestBody(const requestBody: ISuperObject);
begin
  PopulateRequestResponses(requestBody);
  PopulateRequestPredicates(requestBody);
end;

procedure TMbStub.PopulateRequestResponses(const requestBody: ISuperObject);
var
  response: TMbResponse;
  responsesJson: ISuperObject;
  responseJson: ISuperObject;
begin
  responsesJson := TSuperObject.Create(stArray);
  requestBody.O['responses'] := responsesJson;

  for response in FResponses do
  begin
    responseJson := TSuperObject.Create;

    response.PopulateRequestBody(responsejson);

    responsesJson.AsArray.Add(responseJson);
  end;
end;

procedure TMbStub.PopulateRequestPredicates(const requestBody: ISuperObject);
var
  predicate: TMbPredicate;
  predicatesJson: ISuperObject;
  predicateJson: ISuperObject;
begin
  predicatesJson := TSuperObject.Create(stArray);
  requestBody.O['predicates'] := predicatesJson;

  for predicate in FPredicates do
  begin
    predicateJson := TSuperObject.Create;

    predicate.PopulateRequestBody(predicateJson);

    predicatesJson.AsArray.Add(predicateJson);
  end;
end;


end.