unit Mb.EqualsPredicate.IntegrationTests;

{$I DUnitX.inc}

interface

uses
  DUnitX.TestFramework,

  Mb.Client;


type
  [TestFixture('TMbEqualsPredicateIntegrationTests', 'TMbEqualsPredicate Integration Tests')]
  TMbEqualsPredicateIntegrationTests = class
  public
    [Test]
    procedure MatchesExactPredicate;
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
  Mb.Stub,
  Mb.Exceptions;


procedure TMbEqualsPredicateIntegrationTests.MatchesExactPredicate;
var
  mbClient: IMbClient;
  httpClient: TIdHTTP;
  url: string;
  path: string;
  response: TStringStream;
  imposter: TMbHttpImposter;
  expectedMatchingStub: TMbStub;
  expectedStatusCode: integer;
  expectedBody: string;
  otherStub: TMbStub;
begin
  response := TStringStream.Create;
  httpClient := TIdHTTP.Create(Nil);

  mbClient := NewMbClient;

  mbClient.Start;

  // Give mb process a chance to start
  Sleep(1000);

  try
    imposter := TMbHttpImposter.Create;

    expectedStatusCode := HttpStatusCode.Created;
    expectedBody := 'expected body text';
    path := '/test';

    otherStub := imposter.AddStub;

    otherStub
      .AddResponse
      .WillReturn(HttpStatusCode.OK)
      .WithBody('some other body');

    otherStub
      .AddEqualsPredicate
        .WithMethod('GET')
        .WithPath('/diffpath')
        .AddQuery('nonmatchingfield', 'nonmatchingvalue');

    expectedMatchingStub := imposter.AddStub;

    expectedMatchingStub
      .AddResponse
      .WillReturn(expectedStatusCode)
      .WithBody(expectedBody);

    expectedMatchingStub
      .AddEqualsPredicate
        .WithMethod('GET')
        .WithPath(path)
        .AddQuery('first', '10')
        .AddHeader('customheader', 'customheadervalue');

    mbClient.SubmitImposter(imposter);

    url := Format(MbUrls.BaseUrl, [ DefaultPort]) + path + '?first=10';

    httpClient.Request.CustomHeaders.AddValue('customheader', 'customheadervalue');

    httpClient.Get(url, response);

    Assert.AreEqual(expectedStatusCode, httpClient.ResponseCode);
    Assert.AreEqual(expectedBody, response.DataString);
  finally
    mbClient.Stop;
    httpClient.Free;
    response.Free;
  end;
end;


initialization
TDunitX.RegisterTestFixture(TMbEqualsPredicateIntegrationTests);
end.
