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
  json: ISuperObject;
  expectedJsonString: string;
  actualJsonString: string;
begin
  json:= TSuperObject.Create;

  imposter := TMbHttpImposter.Create;

  try
    stub := TMbStub.Create;

    stub.AddResponse
      .WithBody('some plain text here')
      .WithHeaders('content-type', 'application/json');

    imposter.Stubs.Add(stub);

    imposter.AddJson(json);

    expectedJsonString := '{"stubs":[{"responses":[{"is":{"statusCode":200,"body":"some plain text here","headers":{"content-type":"application/json"}}}],"predicates":[]}],"port":4545,"protocol":"http","name":""}';

    actualJsonString := json.AsString;

    Assert.AreEqual(expectedJsonString, actualJsonString);
  finally
    imposter.Free;
  end;
end;

initialization
TDunitX.RegisterTestFixture(TMbImposterTests);
end.
