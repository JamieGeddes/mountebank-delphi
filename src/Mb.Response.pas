unit Mb.Response;

interface

uses
  System.Generics.Collections;


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

  FResponseType:= rtIs;
  FStatusCode:= HttpStatusCode.OK;

  FHeaders:= TDictionary<string, string>.Create;
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

end.
