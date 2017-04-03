unit Mb.StartupOptions.IntegrationTests;

{$I DUnitX.inc}

interface

uses
  DUnitX.TestFramework;


type
  [TestFixture('TMbStartupOptionsIntegrationTests', 'TMbStartupOptionsIntegrationTests Integration Tests')]
  TMbStartupOptionsIntegrationTests = class
  public
    [Test]
    procedure CheckAllowsInjection;
  end;

implementation

uses
  System.Classes,
  System.SysUtils,
  IdHTTP,
  superobject,

  Mb.Client,
  Mb.StartupOptions,
  Mb.Constants;


procedure TMbStartupOptionsIntegrationTests.CheckAllowsInjection;
var
  mbClient: IMbClient;
  httpClient: TIdHTTP;
  url: string;
  response: TStringStream;
  responseJson: ISuperObject;
  options: ISuperObject;
begin
  response := TStringStream.Create;
  httpClient := TIdHTTP.Create(Nil);

  mbClient := NewMbClient;

  mbClient.StartupOptions.AllowInjection;

  mbClient.StartWithOptions;

  // Give mb process a chance to start
  Sleep(1000);

  try
    url := Format(MbUrls.BaseUrl, [ MbDefaultPort]) + '/config';

    httpClient.Request.Accept:= 'application/json';
    httpClient.Get(url, response);

    responseJson := SO(response.DataString);

    options := responseJson.O['options'];

    Assert.IsTrue(options.B['allowInjection']);
  finally
    mbClient.Stop;
    httpClient.Free;
    response.Free;
  end;
end;


initialization
TDunitX.RegisterTestFixture(TMbStartupOptionsIntegrationTests);
end.
