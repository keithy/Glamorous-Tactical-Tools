Extension { #name : 'PlatformResolver' }

{ #category : '*Tactical-Tools' }
PlatformResolver >> code [
	<origin>
	^  self home / 'code'
]

{ #category : '*Tactical-Tools' }
PlatformResolver >> project [

	<origin>

	^ self directoryFromEnvVariableNamed: 'PROJECT' or: [ self code]
]
