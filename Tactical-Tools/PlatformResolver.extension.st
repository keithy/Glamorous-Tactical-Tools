Extension { #name : 'PlatformResolver' }

{ #category : '*Tactical-Tools' }
PlatformResolver >> code [
	<origin>
	
		Transcript crShow: (thisContext method printString).
	
	^  self home / 'code'
]

{ #category : '*Tactical-Tools' }
PlatformResolver >> project [

	^ Hub current projectDir
]
