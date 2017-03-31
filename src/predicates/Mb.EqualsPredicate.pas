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

    procedure AddJson(const json: ISuperObject); override;

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

procedure TMbEqualsPredicate.AddJson(const json: ISuperObject);
var
  equalsJson: ISuperObject;
begin
  equalsJson := TSuperObject.Create;
  json.O['equals'] := equalsJson;

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
