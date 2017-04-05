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
  Mb.HttpImposter;

{ TMbImposterTests }

procedure TMbImposterTests.AddsExpectedJson;
var
  imposter: TMbImposter;
  stub: TMbStub;
  requestBody: ISuperObject;
  expectedJsonString: string;
  actualJsonString: string;
begin
  requestBody := TSuperObject.Create;

  imposter := TMbHttpImposter.Create;

  try
    stub := TMbStub.Create;

    stub.AddResponse
      .WithBody('some plain text here')
      .WithHeaders('content-type', 'application/json');

    imposter.Stubs.Add(stub);

    imposter.PopulateRequestBody(requestBody);

    expectedJsonString := '{"stubs":[{"responses":[{"is":{"statusCode":200,"body":"some plain text here","headers":{"content-type":"application/json"}}}],"predicates":[]}],"port":4545,"protocol":"http","name":""}';

    actualJsonString := requestBody.AsString;

    Assert.AreEqual(expectedJsonString, actualJsonString);
  finally
    imposter.Free;
  end;
end;

initialization
TDunitX.RegisterTestFixture(TMbImposterTests);
end.
