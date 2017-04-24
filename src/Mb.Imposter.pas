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

unit Mb.Imposter;

interface

uses
  System.Generics.Collections,
  superobject,
  Mb.Stub,
  Mb.IsResponse;


type
  TMbImposter = class abstract
  private
    FPort: integer;
    FName: string;

    FStubs: TList<TMbStub>;

    FDefaultResponse: TMbIsResponse;

    procedure PopulateRequestStubs(const requestBody: ISuperObject);

  protected
    FProtocol: string;

  public
    constructor Create;
    destructor Destroy; override;

    procedure PopulateRequestBody(const requestBody: ISuperObject); virtual;

    function ListenOnPort(const port: integer): TMbImposter;
    function WithName(const name: string): TMbImposter;

    function AddStub: TMbStub;

    property Port: integer read FPort write FPort;
    property Protocol: string read FProtocol;

    property Stubs: TList<TMbStub> read FStubs;
    property DefaultResponse: TMbIsResponse read FDefaultResponse;
  end;

implementation

uses
  Mb.Constants;


{ TMbImposter }

constructor TMbImposter.Create;
begin
  inherited Create;

  FPort := DefaultPort;
  FProtocol := DefaultProtocol;

  FStubs := TObjectList<TMbStub>.Create(True);

  FDefaultResponse := TMbIsResponse.Create;
end;

destructor TMbImposter.Destroy;
begin
  FDefaultResponse.Free;
  FStubs.Free;

  inherited;
end;

function TMbImposter.ListenOnPort(const port: integer): TMbImposter;
begin
  FPort := port;

  Result := Self;
end;

function TMbImposter.WithName(const name: string): TMbImposter;
begin
  FName := name;

  Result := Self;
end;

function TMbImposter.AddStub: TMbStub;
var
  stub: TMbStub;
begin
  stub := TMbStub.Create;

  FStubs.Add(stub);

  Result := stub;
end;

procedure TMbImposter.PopulateRequestBody(const requestBody: ISuperObject);
begin
  requestBody.I['port'] := FPort;
  requestBody.S['protocol'] := FProtocol;
  requestBody.S['name'] := FName;

  PopulateRequestStubs(requestBody);
end;

procedure TMbImposter.PopulateRequestStubs(const requestBody: ISuperObject);
var
  stub: TMbStub;
  stubsJson: ISuperObject;
  stubJson: ISuperObject;
begin
  stubsJson := TSuperObject.Create(stArray);
  requestBody.O['stubs'] := stubsJson;

  for stub in Stubs do
  begin
    stubJson := TSuperObject.Create;
    stub.PopulateRequestBody(stubJson);

    stubsJson.AsArray.Add(stubJson);
  end;
end;

end.
