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
    Sleep(1000);

    imposter1 := mbClient.CreateHttpImposter
                  .ListenOnPort(4545)
                  .WithName('imposter1');

    mbClient.SubmitImposter(imposter1);

    imposter2 := mbClient.CreateHttpImposter
                  .ListenOnPort(4545)
                  .WithName('imposter2');

    Assert.WillRaise(
      procedure
      begin
        mbClient.SubmitImposter(imposter2);
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
