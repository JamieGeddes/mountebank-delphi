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
