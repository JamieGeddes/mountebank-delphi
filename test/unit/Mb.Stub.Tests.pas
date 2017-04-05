unit Mb.Stub.Tests;

interface

uses
  DUnitX.TestFramework;


type
  [TestFixture('TMbStubTests', 'TMbStub Tests')]
  TMbStubTests = class
  public
    [Test]
    procedure AddsExpectedJson;
  end;

implementation

uses
  superobject,
  Mb.Stub;


{ TMbStubTests }

procedure TMbStubTests.AddsExpectedJson;
var
  stub: TMbStub;
  requestBody: ISuperObject;
  expectedJsonString: string;
  actualJsonString: string;
begin
  requestBody := TSuperObject.Create;

  stub := TMbStub.Create;

  try
    stub.AddResponse
      .WithBody('some plain text here')
      .WithHeaders('content-type', 'application/json');

    stub.AddEqualsPredicate
      .WithPath('predicatePath')
      .WithBody('predicateBody');

    stub.PopulateRequestBody(requestBody);

    expectedJsonString := '{"responses":[{"is":{"statusCode":200,"body":"some plain text here","headers":{"content-type":"application/json"}}}],"predicates":[{"equals":{"path":"predicatePath","body":"predicateBody"}}]}';

    actualJsonString := requestBody.AsString;

    Assert.AreEqual(expectedJsonString, actualJsonString);
  finally
    stub.Free;
  end;
end;

initialization
TDunitX.RegisterTestFixture(TMbStubTests);
end.
