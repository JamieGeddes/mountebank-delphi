# mountebank-delphi
A Delphi client library for [mountebank](http://www.mbtest.org). Mountebank provides service virtualization, or "over the wire test doubles", i.e. it offers the ability to mock out external service dependencies.

This client library allows you to easily use mountebank directly within a Delphi application in order to set up service mocks. This is particularly useful in the case of integration tests, where you want to validate a system that makes use of external service calls without requiring to call the actual dependencies. The library offers a simple fluent syntax to allow a mountebank instance to be configured with the various stubs, responses and predicates that will allow you to verify each scenario you need to test.

## Prerequisites
This library currently assumes that mountebank is installed on the machine on which this client will be run. Please refer to the [Getting Started](http://www.mbtest.org/docs/gettingStarted) section of the mountebank website for installation instructions.

## Dependencies
The core mountebank-delphi library uses [SuperObject](https://github.com/hgourvest/superobject) for JSON serialization.
The unit and integration test projects use [Delphi Mocks](https://github.com/VSoftTechnologies/Delphi-Mocks) and the [DUnitX](https://github.com/VSoftTechnologies/DUnitX) unit test framework.

## Style guide
Loosely based on [http://edn.embarcadero.com/article/10280](http://edn.embarcadero.com/article/10280).

## Usage
A new mountebank client instance can be setup as below:

````pascal
uses Mb.Client
...
var mbClient: IMbClient;
...
mbClient := NewMbClient();

mbClient.Start();
````

Typically you might do the above in a test fixture's setup method, or at the start of a given test method. This will launch a new console window and start an instance of mountebank running with the default options. If you want to change the default options, you can alternatively configure the client with different startup options:

````pascal
mbClient.StartupOptions
    .AllowInjection
	.RunOnPort(9999)
	.LogToFile('C:\Temp\mountebank logs')
	.AllowMockVerification;

mbClient.StartWithOptions();
````

The mountebank client can then be configured by adding one or more imposters:

````pascal
uses Mb.HttpImposter;
...
var imposter: TMbHttpImposter;
...
imposter := mbClient.CreateHttpImposter
                .WithName('testImposter1')
				.ListenOnPort(6789);
````

Note this simply creates the imposter in memory, it will not be submitted to mountebank until you request it.

The next step is to configure the expected behaviour. The simplest example is to create a canned response that will be returned whenever a request is made to the port the imposter is set to listen on.

````pascal
uses Mb.Constants;
....
imposter
    .AddStub
        .AddResponse
		.WillReturn(HttpStatusCode.OK)
		.WithBody('{"name": "fred"}');
````

Alternatively, a SuperObject instance can be specified as the body:

````pascal
uses superobject;
...
var body: ISuperObject;
...
body := TSuperObject.Create();
body.S['name'] := 'fred';

imposter
    .AddStub
        .AddResponse
		.WillReturn(HttpStatusCode.OK)
		.WithBody(body);
````

The imposter must then be posted to mountebank once it has been fully configured, using the following command:

````pascal
mbClient.SubmitImposter(imposter);
````

At this point the imposter is fully configured and can be verified by either making a call to the expected endpoint (localhost:6789 in this case) or by opening a browser, navigating to localhost:2525 (assuming mountebank is running on the default port) and examining the responses page.

Finally, the mountebank client can be stopped by calling

````pascal
mbClient.Stop();
````

## Current limitations
Currently only http and https imposters are supported. Additionally, only the equals predicate type is currently implemented.