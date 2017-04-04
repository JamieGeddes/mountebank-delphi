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

    procedure AddJson(const json: ISuperObject); override;

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

procedure TMbIsResponse.AddJson(const json: ISuperObject);
var
  isJson: ISuperObject;
  headersJson: ISuperObject;
  headerName: string;
begin
  isJson := TSuperObject.Create;
  json.O['is'] := isJson;

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
