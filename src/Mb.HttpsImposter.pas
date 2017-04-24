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

unit Mb.HttpsImposter;

interface

uses
  superobject,

  Mb.Imposter;

type
  TMbHttpsImposter = class(TMbImposter)
  private
    FKey: string;
    FCert: string;
    FMutualAuth: Boolean;

  public
    constructor Create;

    function WithKey(const key: string): TMbHttpsImposter;
    function WithCert(const cert: string): TMbHttpsImposter;
    function WithMutualAuth(const enabled: Boolean = True): TMbHttpsImposter;

    procedure PopulateRequestBody(const requestBody: ISuperObject); override;
  end;

implementation

{ TMbHttpsImposter }

constructor TMbHttpsImposter.Create;
begin
    inherited Create;

    FProtocol := 'https';

    FMutualAuth := False;
end;

function TMbHttpsImposter.WithKey(const key: string): TMbHttpsImposter;
begin
  FKey := key;

  Result := Self;
end;

function TMbHttpsImposter.WithCert(const cert: string): TMbHttpsImposter;
begin
  FCert := cert;

  Result := Self;
end;

function TMbHttpsImposter.WithMutualAuth(const enabled: Boolean = True): TMbHttpsImposter;
begin
  FMutualAuth := enabled;

  Result := Self;
end;


procedure TMbHttpsImposter.PopulateRequestBody(const requestBody: ISuperObject);
begin
  inherited;

  requestBody.S['key'] := FKey;
  requestBody.S['cert'] := FCert;

  if(FMutualAuth) then requestBody.B['mutualAuth'] := True;
end;

end.