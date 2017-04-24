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
  Mb.StartupOptions in '..\..\src\Mb.StartupOptions.pas',
  Mb.IsResponse in '..\..\src\Mb.IsResponse.pas',
  Mb.EqualsPredicate in '..\..\src\Mb.EqualsPredicate.pas',
  Mb.Predicate in '..\..\src\Mb.Predicate.pas',
  Mb.Stub.Tests in 'Mb.Stub.Tests.pas',
  Mb.HttpsImposter in '..\..\src\Mb.HttpsImposter.pas',
  Mb.HttpsImposter.Tests in 'Mb.HttpsImposter.Tests.pas';

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
