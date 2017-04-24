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

unit Mb.IsResponse;

interface

uses
  System.Generics.Collections,
  superobject,

  Mb.Response;


type
  TMbIsResponse = class(TMbResponse)
  private
    FStatusCode: integer;

    FHeaders: TDictionary<string, string>;

    FBody: string; //**JG

  public
    constructor Create;
    destructor Destroy; override;

    function WillReturn(const statusCode: integer): TMbIsResponse;

    function WithHeaders(const headerName: string;
                         const headerValue: string): TMbIsResponse;

    function WithBody(const body: string): TMbIsResponse; overload;
    function WithBody(const bodyJson: ISuperObject): TMbIsResponse; overload;

    procedure PopulateRequestBody(const requestBody: ISuperObject); override;

    property Headers: TDictionary<string, string> read FHeaders;

    property Body: string read FBody write FBody;
  end;

implementation

uses
  Mb.Constants;


{ TMbIsResponse }

constructor TMbIsResponse.Create;
begin
  inherited Create;

  FStatusCode := HttpStatusCode.OK;

  FHeaders := TDictionary<string, string>.Create;
end;

destructor TMbIsResponse.Destroy;
begin
  FHeaders.Free;

  inherited;
end;

function TMbIsResponse.WillReturn(const statusCode: integer): TMbIsResponse;
begin
  FStatusCode := statusCode;

  Result := Self;
end;

function TMbIsResponse.WithHeaders(const headerName: string;
                                   const headerValue: string): TMbIsResponse;
begin
  FHeaders.AddOrSetValue(headerName, headerValue);

  Result := Self;
end;

function TMbIsResponse.WithBody(const body: string): TMbIsResponse;
begin
  FBody := body;

  Result := Self;
end;

function TMbIsResponse.WithBody(const bodyJson: ISuperObject): TMbIsResponse;
begin
  FBody := bodyJson.AsString;

  Result := Self;
end;

procedure TMbIsResponse.PopulateRequestBody(const requestBody: ISuperObject);
var
  isJson: ISuperObject;
  headersJson: ISuperObject;
  headerName: string;
begin
  isJson := TSuperObject.Create;
  requestBody.O['is'] := isJson;

  isJson.I['statusCode'] := FStatusCode;

  headersJson := TSuperObject.Create;
  isJson.O['headers'] := headersJson;

  for headerName in FHeaders.Keys do
  begin
    headersJson.S[headerName] := FHeaders[headerName];
  end;

  isJson.S['body'] := FBody;
end;

end.
