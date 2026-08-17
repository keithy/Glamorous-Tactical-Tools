Extension { #name : 'UnixResolver' }

{ #category : '*Tactical-Tools' }
UnixResolver >> config [

	"Unified origin for all OSes"
	
	<origin>
	
	^ self preferences
]
