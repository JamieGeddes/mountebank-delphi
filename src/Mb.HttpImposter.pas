unit Mb.HttpImposter;

interface

uses
  Mb.Imposter;

type
  TMbHttpImposter = class(TMbImposter)
  public
    constructor Create;
  end;

implementation

{ TMbHttpImposter }

constructor TMbHttpImposter.Create;
begin
    inherited Create;

    FProtocol := 'http';
end;

end.
