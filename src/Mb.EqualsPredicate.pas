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

unit Mb.EqualsPredicate;

interface

uses
  System.Generics.Collections,
  superobject,

  Mb.Predicate;


type
  TMbEqualsPredicate = class(TMbPredicate)
  private
    FMethod: string;
    FPath: string;
    FQuery: TDictionary<string,string>;
    FHeaders: TDictionary<string,string>;
    FBody: string;

    procedure AddParamsFromDictionary(const dict: TDictionary<string,string>;
                                      const sectionName: string;
                                      const equalsJson: ISuperObject);
  public
    constructor Create;
    destructor Destroy; override;

    function WithMethod(const method: string): TMbEqualsPredicate;
    function WithPath(const path: string): TMbEqualsPredicate;

    function AddQuery(const name: string;
                      const value: string): TMbEqualsPredicate;

    function AddHeader(const name: string;
                       const value: string): TMbEqualsPredicate;

    function WithBody(const body: string): TMbEqualsPredicate; overload;
    function WithBody(const body: ISuperObject): TMbEqualsPredicate; overload;

    procedure PopulateRequestBody(const requestBody: ISuperObject); override;

    property Method: string read FMethod write FMethod;
    property Path: string read FPath write FPath;
  end;

implementation

uses
  System.SysUtils;


{ TMbEqualsPredicate }

constructor TMbEqualsPredicate.Create;
begin
  inherited Create;

  FQuery := TDictionary<string,string>.Create;
  FHeaders := TDictionary<string,string>.Create;
end;

destructor TMbEqualsPredicate.Destroy;
begin
  FHeaders.Free;
  FQuery.Free;

  inherited;
end;

function TMbEqualsPredicate.WithMethod(const method: string): TMbEqualsPredicate;
begin
  FMethod := method;

  Result := Self;
end;

function TMbEqualsPredicate.WithPath(const path: string): TMbEqualsPredicate;
begin
  FPath := path;

  Result := Self;
end;

function TMbEqualsPredicate.AddQuery(const name: string;
                                     const value: string): TMbEqualsPredicate;
begin
  FQuery.Add(name, value);

  Result := Self;
end;

function TMbEqualsPredicate.AddHeader(const name: string;
                                      const value: string): TMbEqualsPredicate;
begin
  FHeaders.Add(name, value);

  Result := Self;
end;

function TMbEqualsPredicate.WithBody(const body: string): TMbEqualsPredicate;
begin
  FBody := body;

  Result := Self;
end;

function TMbEqualsPredicate.WithBody(const body: ISuperObject): TMbEqualsPredicate;
begin
  Result := WithBody(body.AsString);
end;

procedure TMbEqualsPredicate.PopulateRequestBody(const requestBody: ISuperObject);
var
  equalsJson: ISuperObject;
begin
  equalsJson := TSuperObject.Create;
  requestBody.O['equals'] := equalsJson;

  if(not FMethod.IsEmpty) then equalsJson.S['method'] := FMethod;

  if(not FPath.IsEmpty) then equalsJson.S['path'] := FPath;

  AddParamsFromDictionary(FQuery, 'query', equalsJson);
  AddParamsFromDictionary(FHeaders, 'headers', equalsJson);

  if(not FBody.IsEmpty) then equalsJson.S['body'] := FBody;
end;

procedure TMbEqualsPredicate.AddParamsFromDictionary(const dict: TDictionary<string,string>;
                                                     const sectionName: string;
                                                     const equalsJson: ISuperObject);
var
  sectionJson: ISuperObject;
  key: string;
begin
  if(dict.Count > 0) then
  begin
    sectionJson := TSuperObject.Create;
    equalsJson.O[sectionName] := sectionJson;

    for key in dict.Keys do
    begin
      sectionJson.S[key] := dict[key];
    end;
  end;
end;

end.
