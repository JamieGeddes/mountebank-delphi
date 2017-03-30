program Mb.UnitTests;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DUnitX.ConsoleWriter.Base,
  DUnitX.Generics,
  DUnitX.InternalInterfaces,
  DUnitX.IoC,
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Text,
  DUnitX.Loggers.XML.NUnit,
  DUnitX.Loggers.XML.xUnit,
  DUnitX.Test,
  DUnitX.TestFixture,
  DUnitX.TestFramework,
  DUnitX.TestResult,
  DUnitX.RunResults,
  DUnitX.TestRunner,
  DUnitX.Utils,
  DUnitX.Utils.XML,
  DUnitX.WeakReference,
  DUnitX.Windows.Console,
  DUnitX.StackTrace.EurekaLog7,
  DUnitX.FixtureResult,
  DUnitX.Loggers.Null,
  DUnitX.MemoryLeakMonitor.Default,
  DUnitX.Extensibility,
  DUnitX.CommandLine.OptionDef,
  DUnitX.CommandLine.Options,
  DUnitX.CommandLine.Parser,
  DUnitX.FixtureProviderPlugin,
  DUnitX.Timeout,
  DUnitX.Attributes,
  Mb.Client in '..\..\src\Mb.Client.pas',
  Mb.Process in '..\..\src\Mb.Process.pas',
  Mb.Imposter in '..\..\src\Mb.Imposter.pas',
  Mb.Constants in '..\..\src\Mb.Constants.pas',
  Mb.Stub in '..\..\src\Mb.Stub.pas',
  Mb.Response in '..\..\src\Mb.Response.pas',
  Mb.Exceptions in '..\..\src\Mb.Exceptions.pas',
  Mb.Client.Tests in 'Mb.Client.Tests.pas',
  Mb.ImposterTests in 'Mb.ImposterTests.pas',
  Mb.Handler in '..\..\src\Mb.Handler.pas',
  Mb.RestClient in '..\..\src\Mb.RestClient.pas',
  Mb.RestClientFactory in '..\..\src\Mb.RestClientFactory.pas',
  Mb.HttpImposter in '..\..\src\Mb.HttpImposter.pas',
  Mb.StartupOptions in '..\..\src\Mb.StartupOptions.pas';

var
  runner : ITestRunner;
  results : IRunResults;
  logger : ITestLogger;
  nunitLogger : ITestLogger;

begin
  try
//    //Create the runner
    runner := TDUnitX.CreateRunner;
    runner.UseRTTI := True;
    //tell the runner how we will log things
    logger := TDUnitXConsoleLogger.Create(true);
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create;
    runner.AddLogger(logger);
    runner.AddLogger(nunitLogger);

    //Run tests
    results := runner.Execute;

    System.Write('Done.. press <Enter> key to quit.');
    System.Readln;
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
end.
