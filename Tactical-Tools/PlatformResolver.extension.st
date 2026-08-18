Extension { #name : 'PlatformResolver' }

{ #category : '*Tactical-Tools' }
PlatformResolver >> code [
	<origin>
	
		thisContext logMe.
			
	^  self home / 'code'
]

{ #category : '*Tactical-Tools' }
PlatformResolver >> project [

	^ self resolveString: Hub current projectDir
]
