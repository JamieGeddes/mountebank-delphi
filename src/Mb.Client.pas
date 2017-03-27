unit Mb.Client;

interface

uses
  System.Generics.Collections,

  Mb.Process,
  Mb.Handler,
  Mb.Imposter;

type
  IMbClient = interface
    ['{AD706DC5-4616-4F5D-A472-E9E7CD3D773A}']

    procedure Start;
    procedure Stop;

    function AddImposter(const imposter: TMbImposter): TMbImposter;
  end;

  TMbClient = class(TInterfacedObject, IMbClient)
  private
    FMbProcess: IMbProcess;

    FMbHandler: IMbHandler;

    FImposters: TDictionary<integer, TMbImposter>;

  public
    constructor Create(const aMbProcess: IMbProcess;
                       const aMbHandler: IMbHandler);

    destructor Destroy; override;

    procedure Start;
    procedure Stop;

    function AddImposter(const imposter: TMbImposter): TMbImposter;
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

  FImposters := TObjectDictionary<integer, TMbImposter>.Create([doOwnsValues]);
end;

destructor TMbClient.Destroy;
begin
  FImposters.Free;

  inherited;
end;

procedure TMbClient.Start;
begin
  FMbProcess.Start;
end;

procedure TMbClient.Stop;
begin
  FMbProcess.Stop;
end;

function TMbClient.AddImposter(const imposter: TMbImposter): TMbImposter;

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

end.
