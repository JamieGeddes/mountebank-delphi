# Design notes

## MbClient

mbClient:= TMbClient.Create;

mbClient.Start;

or specifying startup options:

mbOptions:= TMbOptions.Create();

mbOptions.AllowInjection:= False; // Default

mbOptions.PostOnAdd:= paImmediate;
or
mbOptions.PostOnAdd:= paDeferred;

mbClient.StartWithOptions(mbOptions);


## Adding imposters

Use TMbImposterBuilder:

buildImposter:= TMbImposterBuilder.Create;

imposter:= buildImposter
				.WithName('Some Imposter Name for display')
				.OnPort(4545)
				.WithProtocol('https')
			.Build;
			
Add imposter to client:

mbClient.AddImposter(imposter);

Registers imposter with specific port.

if mbOptions.PostOnAdd = paDeferred then:

mbClient.PostAllImposters;

or

mbClient.PostImposter(4545);


Translate imposter into post to MB:
MbCommandBuilder

Command type: e.g. GET, POST, DELETE