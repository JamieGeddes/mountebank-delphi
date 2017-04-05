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

    procedure AddJson(const json: ISuperObject); override;
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


procedure TMbHttpsImposter.AddJson(const json: ISuperObject);
begin
  inherited;

  json.S['key'] := FKey;
  json.S['cert'] := FCert;

  if(FMutualAuth) then json.B['mutualAuth'] := True;
end;

end.