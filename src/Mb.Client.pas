unit Mb.Client;

interface

uses
  System.Generics.Collections,

  Mb.Process,
  Mb.Imposter;

type
  TMbClient = class
  private
    FMbProcess: TMbProcess;

    FImposters: TDictionary<integer, TMbImposter>;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;

    function AddImposter(const imposter: TMbImposter): TMbImposter;
  end;

implementation


{ TMbClient }

constructor TMbClient.Create;
begin
  inherited Create;

  FMbProcess:= TMbProcess.Create;

  FImposters:= TObjectDictionary<integer, TMbImposter>.Create([doOwnsValues]);
end;

destructor TMbClient.Destroy;
begin
  FImposters.Free;
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
begin
  FImposters.AddOrSetValue( imposter.Port, imposter);

  Result:= imposter;
end;

end.
