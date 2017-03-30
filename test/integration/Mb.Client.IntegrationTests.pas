unit Mb.Client.IntegrationTests;

{$I DUnitX.inc}

interface

uses
  DUnitX.TestFramework,

  Mb.Client;


type
  [TestFixture('TMbClientIntegrationTests', 'TMbClient Integration Tests')]
  TMbClientIntegrationTests = class
  public
    [Test]
    procedure MbRunningOnExpectedPort;

    [Test]
    procedure PostDuplicateImposterThrowsException;
  end;

implementation

uses
  System.Classes,
  System.SysUtils,
  IdHTTP,
  superobject,

  Mb.Constants,
  Mb.Imposter,
  Mb.HttpImposter,
  Mb.Exceptions;


procedure TMbClientIntegrationTests.MbRunningOnExpectedPort;
var
  mbClient: IMbClient;
  httpClient: TIdHTTP;
  url: string;
  response: TStringStream;
begin
  response := TStringStream.Create;
  httpClient := TIdHTTP.Create(Nil);

  mbClient := NewMbClient;

  mbClient.Start;

  // Give mb process a chance to start
  Sleep(1000);

  try
    url := Format(MbUrls.BaseUrl, [ MbDefaultPort]);

    httpClient.Get(url, response);

    Assert.AreEqual(HttpStatusCode.OK, httpClient.ResponseCode);
  finally
    mbClient.Stop;
    httpClient.Free;
    response.Free;
  end;
end;

procedure TMbClientIntegrationtests.PostDuplicateImposterThrowsException;
var
  mbClient: IMbClient;
  imposter1: TMbImposter;
  imposter2: TMbImposter;
begin
  mbClient := NewMbClient;

  mbClient.Start;

  try
    imposter1 := TMbHttpImposter.Create
                  .ListenOnPort(4545)
                  .WithName('imposter1');

    mbClient.AddImposter(imposter1);

    imposter2 := TMbHttpImposter.Create
                  .ListenOnPort(4545)
                  .WithName('imposter2');

    Assert.WillRaise(
      procedure
      begin
        mbClient.AddImposter(imposter2);
      end,
      EMbPortInUseException
    );
  finally
    mbClient.Stop;
    imposter2.Free; // imposter1 is managed by the mbClient instance
  end;
end;


initialization
TDunitX.RegisterTestFixture(TMbClientIntegrationTests);
end.
