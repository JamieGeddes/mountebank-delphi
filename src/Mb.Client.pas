unit Mb.Client;

interface

uses
  System.Generics.Collections,

  Mb.Process,
  Mb.Handler,
  Mb.Imposter;

type
  TMbClient = class
  private
    FMbProcess: TMbProcess;

    FMbHandler: TMbHandler;

    FImposters: TDictionary<integer, TMbImposter>;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;

    function AddImposter(const imposter: TMbImposter): TMbImposter;
  end;

implementation

uses
  Mb.Exceptions,
  Mb.RestClientFactory;


{ TMbClient }

constructor TMbClient.Create;
begin
  inherited Create;

  FMbProcess := TMbProcess.Create;

  FMbHandler := TMbHandler.Create(TMbRestClientFactory.Create);

  FImposters := TObjectDictionary<integer, TMbImposter>.Create([doOwnsValues]);
end;

destructor TMbClient.Destroy;
begin
  FImposters.Free;
  FMbHandler.Free;
  FMbProcess.Free;

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
