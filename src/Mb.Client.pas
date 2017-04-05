unit Mb.Client;

interface

uses
  System.Generics.Collections,

  Mb.Process,
  Mb.StartupOptions,
  Mb.Handler,
  Mb.Imposter,
  Mb.HttpImposter,
  Mb.HttpsImposter;

type
  IMbClient = interface
    ['{AD706DC5-4616-4F5D-A472-E9E7CD3D773A}']

    function GetStartupOptions: TMbStartupOptions;

    procedure Start;
    procedure StartWithOptions;
    procedure Stop;

    function CreateHttpImposter: TMbHttpImposter;
    function CreateHttpsImposter: TMbHttpsImposter;

    function SubmitImposter(const imposter: TMbImposter): TMbImposter;

    property StartupOptions: TMbStartupOptions read GetStartupOptions;
  end;

  TMbClient = class(TInterfacedObject, IMbClient)
  private
    FMbProcess: IMbProcess;

    FMbHandler: IMbHandler;

    FStartupOptions: TMbStartupOptions;

    FImposters: TDictionary<integer, TMbImposter>;

    function GetStartupOptions: TMbStartupOptions;

  public
    constructor Create(const aMbProcess: IMbProcess;
                       const aMbHandler: IMbHandler);

    destructor Destroy; override;

    function WithStartupOptions: TMbStartupOptions;

    procedure Start;
    procedure StartWithOptions;
    procedure Stop;

    function CreateHttpImposter: TMbHttpImposter;
    function CreateHttpsImposter: TMbHttpsImposter;

    function SubmitImposter(const imposter: TMbImposter): TMbImposter;

    property StartupOptions: TMbStartupOptions read GetStartupOptions;
  end;


function NewMbClient: IMbClient;


implementation

uses
  Mb.Exceptions,
  Mb.RestClientFactory;


function NewMbClient: IMbClient;
var
  mbProcess: IMbProcess;
  mbHandler: IMbHandler;
  restClientFactory: IMbRestClientFactory;
begin
  mbProcess := TMbProcess.Create;

  restClientFactory := TMbRestClientFactory.Create;

  mbHandler := TMbHandler.Create(restClientFactory);

  Result := TMbClient.Create(mbProcess,
                             mbHandler);
end;


{ TMbClient }

constructor TMbClient.Create(const aMbProcess: IMbProcess;
                             const aMbHandler: IMbHandler);
begin
  inherited Create;

  Assert(Assigned(aMbProcess));
  Assert(Assigned(aMbHandler));

  FMbProcess := aMbProcess;
  FMbHandler := aMbHandler;

  FStartupOptions := TMbStartupOptions.Create;

  FImposters := TObjectDictionary<integer, TMbImposter>.Create([doOwnsValues]);
end;

destructor TMbClient.Destroy;
begin
  FImposters.Free;

  FStartupOptions.Free;

  inherited;
end;

function TMbClient.WithStartupOptions: TMbStartupOptions;
begin
  Result := GetStartupOptions;
end;

procedure TMbClient.Start;
begin
  FMbProcess.Start;
end;

procedure TMbClient.StartWithOptions;
begin
  FMbProcess.StartWithOptions(FStartupOptions);
end;

procedure TMbClient.Stop;
begin
  FMbProcess.Stop;
end;

function TMbClient.CreateHttpImposter: TMbHttpImposter;
begin
  Result := TMbHttpImposter.Create;
end;

function TMbClient.CreateHttpsImposter: TMbHttpsImposter;
begin
  Result := TMbHttpsImposter.Create;
end;

function TMbClient.SubmitImposter(const imposter: TMbImposter): TMbImposter;

var existingImposter: TMbImposter;

begin
  if(FImposters.TryGetValue(imposter.Port, existingImposter)) then
  begin
    raise EMbPortInUseException.Create(imposter.Port);
  end;

  FImposters.Add( imposter.Port, imposter);

  FMbHandler.PostImposter(imposter);

  Result := imposter;
end;

function TMbClient.GetStartupOptions: TMbStartupOptions;
begin
  Result := FStartupOptions;
end;

end.
