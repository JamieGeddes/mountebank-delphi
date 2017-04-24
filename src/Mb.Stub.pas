{
MIT License

Copyright (c) 2017 Jamie Geddes

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
}

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