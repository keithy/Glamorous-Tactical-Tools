Extension { #name : 'GtExternalProcessBuilder' }

{ #category : '*Tactical-Fixes' }
GtExternalProcessBuilder >> gtCommandLineFor: aView [
	<gtView>

	^ aView text
		title: 'Command Line';
		priority: 10;
		text: [ self commandLine ]
]
