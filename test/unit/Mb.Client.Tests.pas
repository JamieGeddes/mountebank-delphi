{
MIT License

Copyright (c) 2017 Jamie Geddes

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
}

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
    FMbClient.SubmitImposter(firstImposter);

    Assert.WillRaise(
      procedure
      begin
        FMbClient.SubmitImposter(secondImposter);
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

  FMbClient.SubmitImposter(imposter);

  FMbHandler.Verify;
end;

function TMbClientTests.CreateAnImposterOnPort(const port: integer): TMbImposter;
var
  imposter: TMbImposter;
begin
  imposter := FMbClient.CreateHttpImposter;

  imposter.Port:= port;

  Result := imposter;
end;


initialization
TDunitX.RegisterTestFixture(TMbClientTests);

end.
