# Design notes

## MbClient

````pascal
mbClient:= NewMbClient;

mbClient.Start;
````

or specifying startup options:

````pascal
mbClient:= NewMbClient.WithStartupOptions
	.AllowInjection
	.AllowMockVerification
	.Debug
	.LogToFile('C:\MbLogs\mbLog.txt');
````

## Adding imposters

				
````pascal
mbClient := NewMbClient;

mbClient.Start;
				
imposter := mbClient
				.CreateHttpImposter
				.OnPort(4545)
				.WithName("testImposter1")
				.AddStub
					.AddResponse
						.WillReturn(HttpStatusCode.OK)
						.WithHeaders(Headers)
						.WithBody(Body);
					
mbClient.SubmitImposter(imposter);
````
					
					
or:

````pascal
imposter := mbClient
				.CreateHttpImposter
				.ListenOnPort(4545)
				.WithName("testImposter1");
				
stub := imposter
			.AddStub;
			
response := stub
				.AddResponse
					.WillReturn(HttpStatusCode.OK)
					.WithHeaders(Headers)
					.WithBody(Body);
````					
					
					
## With Json body

````pascal
JsonBody:= TSuperObject.Create;
JsonBody.S['someStringProperty'] := 'name';
JsonBody.I['someValue'] := 123;

imposter := mbClient
				.CreateHttpImposter
				.ListenOnPort(4545)
				.WithName("testImposter1")
				.AddStub
					.AddResponse
						.WillReturn(HttpStatusCode.OK)
						.WithHeaders('customHeader', 'customValue')
						.WithBody(JsonBody);
````						
			
