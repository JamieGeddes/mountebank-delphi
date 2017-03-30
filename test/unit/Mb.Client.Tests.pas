unit Mb.Client.Tests;

{$I DUnitX.inc}

interface

uses
  DUnitX.TestFramework,
  Delphi.Mocks,

  Mb.Client,
  Mb.Process,
  Mb.Handler,
  Mb.Imposter;

type
  [TestFixture('TMbClientTests', 'TMbClient Tests')]
  TMbClientTests = class
  private
    FMbClient: TMbClient;

    FMbProcess: TMock<IMbProcess>;
    FMbHandler: TMock<IMbHandler>;

    function CreateAnImposterOnPort(const port: integer): TMbImposter;

  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    procedure RaisesExceptionWhenImposterExistsForSpecifiedPort;
    [Test]
    procedure PostsNewImposterOnAdd;
  end;

implementation

uses
  Mb.Exceptions,
  Mb.HttpImposter;


{ TMbClientTests }

procedure TMbClientTests.Setup;
begin
  FMbProcess := TMock<IMbProcess>.Create;
  FMbHandler := TMock<IMbHandler>.Create;

  FMbClient := TMbClient.Create(FMbProcess,
                             FMbHandler);
end;

procedure TMbClientTests.TearDown;
begin
  FMbClient.Free;
  FMbHandler.Free;
  FMbProcess.Free;
end;

procedure TMbClientTests.RaisesExceptionWhenImposterExistsForSpecifiedPort;
var
  firstImposter: TMbImposter;
  secondImposter: TMbImposter;
begin
  FMbHandler.Setup.WillReturn(True).When.PostImposter(It(0).IsAny<TMbImposter>);

  firstImposter := CreateAnImposterOnPort(1234);
  secondImposter := CreateAnImposterOnPort(firstImposter.Port);

  try
    FMbClient.AddImposter(firstImposter);

    Assert.WillRaise(
      procedure
      begin
        FMbClient.AddImposter(secondImposter);
      end,
      EMbPortInUseException);
  finally
    secondImposter.Free;
    //firstImposter lifetime is managed by the client
  end
end;

procedure TMbClientTests.PostsNewImposterOnAdd;
var
  imposter: TMbImposter;
begin
  imposter := CreateAnImposterOnPort(1234);

  FMbHandler.Setup.Expect.Once.When.PostImposter(imposter);

  FMbHandler.Setup.WillReturn(True).When.PostImposter(imposter);

  FMbClient.AddImposter(imposter);

  FMbHandler.Verify;
end;

function TMbClientTests.CreateAnImposterOnPort(const port: integer): TMbImposter;
var
  imposter: TMbImposter;
begin
  imposter := TMbHttpImposter.Create;

  imposter.Port:= port;

  Result := imposter;
end;


initialization
TDunitX.RegisterTestFixture(TMbClientTests);

end.
