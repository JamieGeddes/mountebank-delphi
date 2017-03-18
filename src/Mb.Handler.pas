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

    function GetBodyJson(const imposter: TMbImposter): string;

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

  bodyJson := GetBodyJson(imposter);

  url := Format(MbUrls.ImpostersUrl, [MbDefaultPort]);

  statusCode := restClient.Post(url, bodyJson);

  Result := statusCode = HttpStatusCode.Created;
end;

function TMbHandler.GetBodyJson(const imposter: TMbImposter): string;
var
  imposterJson : ISuperObject;
begin
  Assert(Assigned(imposter));

  imposterJson := TSuperObject.Create;

  imposter.AddJson(imposterJson);

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
