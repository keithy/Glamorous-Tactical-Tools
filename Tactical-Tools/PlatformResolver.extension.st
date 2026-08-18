Extension { #name : 'PlatformResolver' }

{ #category : '*Tactical-Tools' }
PlatformResolver >> code [
	<origin>
	
		thisContext logMe.
			
	^  self home / 'code'
]
