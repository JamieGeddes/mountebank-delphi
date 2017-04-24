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

unit Mb.Response.IntegrationTests;

{$I DUnitX.inc}

interface

uses
  DUnitX.TestFramework,
  IdHTTP,

  Mb.Client;


type
  [TestFixture('TMbResponseIntegrationTests', 'Response Integration Tests')]
  TMbResponseIntegrationTests = class
  private
    FmbClient: IMbClient;

    httpClient: TIdHTTP;

  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    procedure RequestReturnsExpectedResponse;
  end;

implementation

uses
  System.Classes,
  System.SysUtils,
  superobject,

  Mb.Constants,
  Mb.Imposter,
  Mb.HttpImposter;


procedure TMbResponseIntegrationTests.Setup;
begin
  FmbClient := NewMbClient;

  FmbClient.Start;

  httpClient := TIdHTTP.Create(Nil);
end;

procedure TMbResponseIntegrationTests.TearDown;
begin
  FmbClient.Stop;

  httpClient.Free;
end;

procedure TMbResponseIntegrationTests.RequestReturnsExpectedResponse;
var
  imposter: TMbImposter;
  expectedPort: integer;
  expectedStatusCode: integer;
  expectedBody: ISuperObject;
  url: string;
  response: TStringStream;
begin
  Sleep(1000);

  expectedPort := 4545;

  imposter := TMbHttpImposter.Create
                .ListenOnPort(expectedPort)
                .WithName('imposter');

  expectedStatusCode := 201;
  expectedBody := TSuperObject.Create;
  expectedBody.I['value'] := 123;
  expectedBody.S['name'] := 'testobject';

  imposter
    .AddStub
      .AddResponse
      .WillReturn(expectedStatusCode)
      .WithBody(expectedBody);

  FmbClient.SubmitImposter(imposter);

  response := TStringStream.Create;

  try
    url := Format(MbUrls.ImpostersUrl, [ expectedPort]);

    httpClient.Get(url, response);

    Assert.AreEqual(expectedStatusCode, httpClient.ResponseCode);
    Assert.AreEqual(expectedBody.AsString, response.DataString);
  finally
    response.Free;
  end;
end;


initialization
TDunitX.RegisterTestFixture(TMbResponseIntegrationTests);
end.
