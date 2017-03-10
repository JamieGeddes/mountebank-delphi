unit Mb.Client.Tests;

{$I DUnitX.inc}

interface

uses
  DUnitX.TestFramework,

  Mb.Imposter;

type
  [TestFixture('TMbClientTests', 'TMbClient Tests')]
  TMbClientTests = class
  private
    function CreateAnImposterOnPort(const port: integer): TMbImposter;

  public
    [Test]
    procedure RaisesExceptionWhenImposterExistsForSpecifiedPort;
  end;

implementation

uses
  Mb.Client,
  Mb.Exceptions;


{ TMbClientTests }

procedure TMbClientTests.RaisesExceptionWhenImposterExistsForSpecifiedPort;

var
  client: TMbClient;
  firstImposter: TMbImposter;
  secondImposter: TMbImposter;

begin
  client:= TMbClient.Create;

  firstImposter:= CreateAnImposterOnPort(1234);
  secondImposter:= CreateAnImposterOnPort(firstImposter.Port);

  try
    client.AddImposter(firstImposter);

    Assert.WillRaise(
      procedure
      begin
        client.AddImposter(secondImposter);
      end,
      EMbPortInUseException);
  finally
    secondImposter.Free;
    //firstImposter lifetime is managed by the client
    client.Free;
  end
end;

function TMbClientTests.CreateAnImposterOnPort(const port: integer): TMbImposter;

var
  imposter: TMbImposter;

begin
  imposter:= TMbImposter.Create;

  imposter.Port:= port;

  Result:= imposter;
end;


initialization
TDunitX.RegisterTestFixture(TMbClientTests);

end.
