Extension { #name : 'PlatformResolver' }

{ #category : '*Tactical-Tools' }
PlatformResolver >> code [
	<origin>
	
		thisContext logMe.
			
	^  self home / 'code'
]

{ #category : '*Tactical-Tools' }
PlatformResolver >> project [

	^ Hub current projectDir
]
