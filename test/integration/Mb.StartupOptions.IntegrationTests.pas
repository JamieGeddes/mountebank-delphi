unit Mb.StartupOptions.IntegrationTests;

{$I DUnitX.inc}

interface

uses
  System.Classes,
  DUnitX.TestFramework,
  superobject,
  IdHTTP,

  Mb.Client;


type
  [TestFixture('TMbStartupOptionsIntegrationTests', 'TMbStartupOptionsIntegrationTests Integration Tests')]
  TMbStartupOptionsIntegrationTests = class
  private
    mbClient: IMbClient;
    httpClient: TIdHTTP;
    response: TStringStream;

    procedure StartWithOptions;

    function GetConfigFromMb: ISuperObject;

    procedure VerifyBooleanOption(const config: ISuperObject;
                                  const optionName: string;
                                  const expectedValue: Boolean);
  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    procedure CheckDefaultState;
    [Test]
    procedure CheckAllowsInjection;
    [Test]
    procedure CheckAllowsMockVerification;
  end;

implementation

uses
  System.SysUtils,

  Mb.StartupOptions,
  Mb.Constants;


procedure TMbStartupOptionsIntegrationTests.Setup;
begin
  mbClient := NewMbClient;

  response := TStringStream.Create;
  httpClient := TIdHTTP.Create(Nil);
end;

procedure TMbStartupOptionsIntegrationTests.TearDown;
begin
  mbClient.Stop;

  httpClient.Free;
  response.Free;
end;

procedure TMbStartupOptionsIntegrationTests.StartWithOptions;
begin
  mbClient.StartWithOptions;

  // Give mb process a chance to start before doing anything else
  Sleep(1000);
end;

function TMbStartupOptionsIntegrationTests.GetConfigFromMb: ISuperObject;
var
  url: string;
begin
  url := Format(MbUrls.BaseUrl, [ MbDefaultPort]) + '/config';

  httpClient.Request.Accept:= 'application/json';
  httpClient.Get(url, response);

  Result := SO(response.DataString);
end;

procedure TMbStartupOptionsIntegrationTests.VerifyBooleanOption(const config: ISuperObject;
                                                                const optionName: string;
                                                                const expectedValue: Boolean);
var
  options: ISuperObject;
begin
  options := config.O['options'];

  Assert.AreEqual(expectedValue, options.B[optionName]);
end;

procedure TMbStartupOptionsIntegrationTests.CheckDefaultState;
var
  config: ISuperObject;
begin
  mbClient.Start;
  Sleep(1000);

  config := GetConfigFromMb;

  VerifyBooleanOption(config, 'allowInjection', false);
  VerifyBooleanOption(config, 'debug', false);
  VerifyBooleanOption(config, 'help', false);
  VerifyBooleanOption(config, 'localOnly', false);
  VerifyBooleanOption(config, 'mock', false);
  VerifyBooleanOption(config, 'nologfile', false);
  VerifyBooleanOption(config, 'noParse', false);
  VerifyBooleanOption(config, 'removeProxies', false);
end;

procedure TMbStartupOptionsIntegrationTests.CheckAllowsInjection;
var
  config: ISuperObject;
begin
  mbClient.StartupOptions.AllowInjection;

  StartWithOptions;

  config := GetConfigFromMb;

  VerifyBooleanOption(config, 'allowInjection', true);
end;

procedure TMbStartupOptionsIntegrationTests.CheckAllowsMockVerification;
var
  config: ISuperObject;
begin
  mbClient.StartupOptions.AllowMockVerification;

  StartWithOptions;

  config := GetConfigFromMb;

  VerifyBooleanOption(config, 'mock', true);
end;

initialization
TDunitX.RegisterTestFixture(TMbStartupOptionsIntegrationTests);
end.
