unit Mb.ImposterTests;

interface

uses
  DUnitX.TestFramework,

  Mb.Imposter;

type
  [TestFixture('TMbImposterTests', 'TMbImposter Tests')]
  TMbImposterTests = class
    public
      [Test]
      procedure AddsExpectedJson;
  end;

implementation

uses
  superobject,
  Mb.Stub,
  Mb.Response;

{ TMbImposterTests }

procedure TMbImposterTests.AddsExpectedJson;
var
  imposter: TMbImposter;
  stub: TMbStub;
  response: TMbResponse;
  json: ISuperObject;
  expectedJsonString: string;
  actualJsonString: string;
begin
  json:= TSuperObject.Create;

  imposter := TMbImposter.Create;

  try
    stub := TMbStub.Create;

    response := TMbResponse.Create;
    response.Body := 'some plain text here';
    response.Headers.Add('content-type', 'application/json');
    stub.Responses.Add(response);
    imposter.Stubs.Add(stub);

    imposter.AddJson(json);

    expectedJsonString := '{"stubs":[{"responses":[{"is":{"statusCode":200,"body":"some plain text here","headers":{"content-type":"application/json"}}}]}],"port":4545,"protocol":"http"}';

    actualJsonString := json.AsString;

    Assert.AreEqual(expectedJsonString, actualJsonString);
  finally
    imposter.Free;
  end;
end;

initialization
TDunitX.RegisterTestFixture(TMbImposterTests);
end.
