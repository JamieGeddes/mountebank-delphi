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
