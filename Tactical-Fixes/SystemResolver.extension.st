Extension { #name : 'SystemResolver' }

{ #category : '*Tactical-Fixes' }
SystemResolver >> config [

	"Unified origin for all OSes"
		
	<origin>
 
	^  self home / '.config' 
]
