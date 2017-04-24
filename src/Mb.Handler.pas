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

unit Mb.Handler;

interface

uses
  Mb.Imposter,
  Mb.RestClientFactory;

type
  {$M+}
  IMbHandler = interface
    ['{E6D14037-83DE-4D5D-94F2-98B2910C4001}']

    function PostImposter(const imposter: TMbImposter): Boolean;

    function DeleteImposter(const imposter: TMbImposter): Boolean;

    function DeleteAllImposters: Boolean;
  end;
  {$M-}

  TMbHandler = class(TInterfacedObject, IMbHandler)
  private
    FRestClientFactory: IMbRestClientFactory;

    function GetRequestBody(const imposter: TMbImposter): string;

    function Delete(const url: string): Boolean;

  public
    constructor Create(const aRestClientFactory: IMbRestClientFactory);

    function PostImposter(const imposter: TMbImposter): Boolean;

    function DeleteImposter(const imposter: TMbImposter): Boolean;

    function DeleteAllImposters: Boolean;
  end;

implementation

uses
  System.SysUtils,
  superobject,
  Mb.Constants,
  Mb.RestClient;

{ TMbHandler }

constructor TMbHandler.Create(const aRestClientFactory: IMbRestClientFactory);
begin
  inherited Create;

  Assert(Assigned(aRestClientFactory));

  FRestClientFactory := aRestClientFactory;
end;

function TMbHandler.PostImposter(const imposter: TMbImposter): Boolean;
var
  restClient: IMbRestClient;
  bodyJson: string;
  url: string;
  statusCode: integer;
begin
  restClient := FRestClientFactory.CreateRestClient;

  restClient.AddHeader('content-type', 'application/json');

  bodyJson := GetRequestBody(imposter);

  url := Format(MbUrls.ImpostersUrl, [MbDefaultPort]);

  statusCode := restClient.Post(url, bodyJson);

  Result := statusCode = HttpStatusCode.Created;
end;

function TMbHandler.GetRequestBody(const imposter: TMbImposter): string;
var
  imposterJson : ISuperObject;
begin
  Assert(Assigned(imposter));

  imposterJson := TSuperObject.Create;

  imposter.PopulateRequestBody(imposterJson);

  Result := imposterJson.AsString;
end;

function TMbHandler.DeleteImposter(const imposter: TMbImposter): Boolean;
var
  url: string;
begin
  url := Format(MbUrls.DeleteSingleImposterUrl, [MbDefaultPort, imposter.Port]);

  Result := Delete(url);
end;

function TMbHandler.DeleteAllImposters: Boolean;
var
  url: string;
begin
  url := Format(MbUrls.ImpostersUrl, [MbDefaultPort]);

  Result := Delete(url);
end;

function TMbHandler.Delete(const url: string): Boolean;
var
  restClient: IMbRestClient;
  statusCode: integer;
begin
  restClient := FRestClientFactory.CreateRestClient;

  statusCode := restClient.Delete(url);

  Result := statusCode = HttpStatusCode.OK;
end;

end.
