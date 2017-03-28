unit Mb.Response;

interface

uses
  System.Generics.Collections,
  superobject;


type
  TMbResponseType = ( rtIs, rtProxy, rtInject);


  TMbResponse = class
  private
    FResponseType: TMbResponseType;

    FStatusCode: integer;

    FHeaders: TDictionary<string, string>;

    FBody: string; //**JG

  public
    constructor Create;
    destructor Destroy; override;

    procedure AddHeader(const headerName: string;
                        const headerValue: string);

    function WillReturn(const statusCode: integer): TMbResponse;

    function WithBody(const body: string): TMbResponse; overload;
    function WithBody(const bodyJson: ISuperObject): TMbResponse; overload;

    procedure AddJson(const json: ISuperObject);

    property ResponseType: TMbResponseType read FResponseType write FResponseType;

    property Headers: TDictionary<string, string> read FHeaders;

    property Body: string read FBody write FBody;
  end;

implementation

uses
  Mb.Constants;


{ TMbResponse }

constructor TMbResponse.Create;
begin
  inherited Create;

  FResponseType := rtIs;
  FStatusCode := HttpStatusCode.OK;

  FHeaders := TDictionary<string, string>.Create;
end;

destructor TMbResponse.Destroy;
begin
  FHeaders.Free;

  inherited;
end;

procedure TMbResponse.AddHeader(const headerName: string;
                                const headerValue: string);
begin
  FHeaders.AddOrSetValue(headerName, headerValue);
end;

function TMbResponse.WillReturn(const statusCode: integer): TMbResponse;
begin
  FStatusCode := statusCode;

  Result := Self;
end;

function TMbResponse.WithBody(const body: string): TMbResponse;
begin
  FBody := body;

  Result := Self;
end;

function TMbResponse.WithBody(const bodyJson: ISuperObject): TMbResponse;
begin
  FBody := bodyJson.AsString;

  Result := Self;
end;

procedure TMbResponse.AddJson(const json: ISuperObject);
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
