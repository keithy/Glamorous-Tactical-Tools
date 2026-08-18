Extension { #name : 'UnixResolver' }

{ #category : '*Tactical-Tools' }
UnixResolver >> config [

	"Unified origin for all OSes"
	<ttFix:'useful origin for all platforms'>
	<origin>
	
	^ self preferences
]
