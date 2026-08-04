Extension { #name : 'WindowsResolver' }

{ #category : '*Tactical-Fixes' }
WindowsResolver >> preferences [

<origin>

	^ self directoryFromEnvVariableNamed: 'APPDATA' or: [ self home ]
]

{ #category : '*Tactical-Fixes' }
WindowsResolver >> temp [

	<origin>
	
	^ self resolveString: Smalltalk os getTempPath
]
