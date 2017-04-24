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
