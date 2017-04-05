unit Mb.HttpsImposter.Tests;

interface

uses
  DUnitX.TestFramework;


type
  [TestFixture('TMbHttpsImposterTests', 'TMbHttpsImposter Tests')]
  TMbHttpsImposterTests = class
  public
    [Test]
    procedure AddsExpectedJson;
  end;

implementation

uses
  superobject,
  Mb.HttpsImposter,
  Mb.Stub;

const
  ExpectedKey: string =
  '-----BEGIN RSA PRIVATE KEY-----\nMIICXAIBAAKBgQCrvse04YkxtVGagyvGJCsvv7LTfLK5uR/ZIJKDYCnuF+BqBzM4'
  + '\nlko8O39vx+Lz9FfF11Xl+CN1aY37YurLYOle3dC/qslSbQDe2TJN7lcVHVssePvc\nO5IExpvNFV5LYtmyCMKJHxpnIprv/trUso5obqzzXhFVPV9SQbFH/snInwIDAQAB\nAoGARywlqLD6YO4qJiULw+4DM6N2oSwBCPRN3XYhIW59kdy1NFtNf7rQgsuJUTJ9'
  + '\nu+lbYnKNd2LwltyqaS4h7Sx5KRhpFNmMpyVsBf5J2q3fbfmrsXt+emY7XhVTc1NV\nizUWYyxCoTTeMWvN/6NYpPV0lSxq7jMTFVZrWQUMqJclxpECQQDTlGwALtAX1Y8u\nGKsEHPkoq9bhHA5N9WAboQ4LQCZVC8eBf/XH//2iosYTXRNgII2JLmHmmxJHo5iN'
  + '\nJPFMbnoHAkEAz81osJf+yHm7PBBJP4zEWZCV25c+iJiPDpj5UoUXEbq47qVfy1mV\nDqy2zoDynAWitU7PeHyZ8ozfyribPoR2qQJAVmvMhXKZmvKnLivzRpXTC9LMzVwZ\nV6x/Wim5w8yrG5fZIMM0kEG2xwR3pZch/+SsCzl/0aLLn6lp+VT6nr6NZwJBAMxs'
  + '\nHrvymoLvNeDtiJFK0nHliXafP7YyljDfDg4+vSYE0R57c1RhSQBJqgBV29TeumSw\nJes6cFuqeBE+MAJ9XxkCQDdUdhnA8HHQRNetqK7lygUep7EcHHCB6u/0FypoLw7o\nEUVo5KSEFq93UeMr3B7DDPIz3LOrFXlm7clCh1HFZhQ=\n-----END RSA PRIVATE KEY-----';

  ExpectedCert: string =
  '-----BEGIN CERTIFICATE-----\nMIIB6TCCAVICCQCZgxbBD0CG4zANBgkqhkiG9w0BAQUFADA5MQswCQYDVQQGEwJV\nUzETMBEGA1UECBMKU29tZS1TdGF0ZTEVMBMGA1UEChMMVGhvdWdodFdvcmtzMB4X'
  + '\nDTEzMTIyOTE2NDAzN1oXDTE0MDEyODE2NDAzN1owOTELMAkGA1UEBhMCVVMxEzAR\nBgNVBAgTClNvbWUtU3RhdGUxFTATBgNVBAoTDFRob3VnaHRXb3JrczCBnzANBgkq\nhkiG9w0BAQEFAAOBjQAwgYkCgYEAq77HtOGJMbVRmoMrxiQrL7+y03yyubkf2SCS'
  + '\ng2Ap7hfgagczOJZKPDt/b8fi8/RXxddV5fgjdWmN+2Lqy2DpXt3Qv6rJUm0A3tky\nTe5XFR1bLHj73DuSBMabzRVeS2LZsgjCiR8aZyKa7/7a1LKOaG6s814RVT1fUkGx\nR/7JyJ8CAwEAATANBgkqhkiG9w0BAQUFAAOBgQCPhixeKxIy+ftrfPikwjYo1uxp'
  + '\ngQ18FdVN1pbI//IIx1o8kJuX8yZzO95PsCOU0GbIRCkFMhBlqHiD9H0/W/GvWzjf\n7WFW15lL61y/kH1J0wqEgoaMrUDjHZvKVr0HrN+vSxHlNQcSNFJ2KdvZ5a9dhpGf\nXOdprCdUUXzSoJWCCg==\n-----END CERTIFICATE-----';


{ TMbHttpsImposterTests }

procedure TMbHttpsImposterTests.AddsExpectedJson;
var
  imposter: TMbHttpsImposter;
  json: ISuperObject;
  expectedResponse: ISuperObject;
  expectedJsonString: string;
  actualJsonString: string;
  expectedPort: integer;
  expectedImposterName: string;

begin
  json:= TSuperObject.Create;

  imposter := TMbHttpsImposter.Create;

  try
    expectedPort := 9876;
    expectedImposterName := 'https imposter 111';

    imposter
      .WithKey(expectedKey)
      .WithCert(expectedCert)
      .WithMutualAuth
      .ListenOnPort(expectedPort)
      .WithName(expectedImposterName);

    imposter.AddJson(json);

    expectedResponse:= TSuperObject.Create;
    expectedResponse.S['key'] := ExpectedKey;
    expectedResponse.S['cert'] := ExpectedCert;
    expectedResponse.B['mutualAuth'] := True;
    expectedResponse.I['port'] := expectedPort;
    expectedResponse.S['name'] := expectedImposterName;
    expectedResponse.O['stubs'] := SA([]);
    expectedResponse.S['protocol'] := 'https';

    actualJsonString := json.AsString;
    expectedJsonString := expectedResponse.AsString;

    Assert.AreEqual(expectedJsonString, actualJsonString);
  finally
    imposter.Free;
  end;
end;

initialization
TDunitX.RegisterTestFixture(TMbHttpsImposterTests);
end.
