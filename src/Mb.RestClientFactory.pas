unit Mb.RestClientFactory;

interface

uses
  Mb.RestClient;

type
  IMbRestClientFactory = interface
    ['{E59CAD50-181B-496E-93E8-49CDB9443C3B}']

    function CreateRestClient: IMbRestClient;
  end;

  TMbRestClientFactory = class(TInterfacedObject, IMbRestClientFactory)
  public
    function CreateRestClient: IMbRestClient;
  end;

implementation

{ TMbRestClientFactory }

function TMbRestClientFactory.CreateRestClient: IMbRestClient;
begin
    Result := TMbRestClient.Create;
end;

end.
