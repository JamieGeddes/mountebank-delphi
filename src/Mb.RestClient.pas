unit Mb.RestClient;

interface

uses
  IdHttp;

type
  IMbRestClient = interface
  ['{4E031738-A436-45CD-BDF2-E6AE05601E3F}']

    procedure AddHeader(const headerName: string;
                        const headerValue: string);

    function Post(const url: string;
                  const body: string): integer;

    function Delete(const url: string): integer;
  end;


  TMbRestClient = class( TInterfacedObject, IMbRestClient)
  private
    FClient: TIdHttp;
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddHeader(const headerName: string;
                        const headerValue: string);

    function Post(const url: string;
                  const body: string): integer;

    function Delete(const url: string): integer;
  end;

implementation

uses
  System.Classes,
  System.SysUtils;


{ TMbRestClient }

constructor TMbRestClient.Create;
begin
  inherited Create;

  FClient := TIdHTTP.Create(Nil);
end;

destructor TMbRestClient.Destroy;
begin
  FClient.Free;

  inherited;
end;

procedure TMbRestClient.AddHeader(const headerName: string;
                                  const headerValue: string);
begin
  FClient.Request.RawHeaders.AddValue(headerName, headerValue);
end;

function TMbRestClient.Post(const url: string;
                            const body: string): integer;
var
  source: TStringStream;
  response: TStringStream;
begin
  source := TStringStream.create(body, TEncoding.UTF8);

  response := TStringStream.Create;

  FClient.Post(url, source, response);

  Result := FClient.ResponseCode;
end;

function TMbRestClient.Delete(const url: string): integer;
begin
  FClient.Delete(url);

  Result := FClient.ResponseCode;
end;

end.
