Extension { #name : 'MemoryStore' }

{ #category : '*Tactical-Fixes' }
MemoryStore class >> shutDown [

	<ttPharoFix:'Avoid saving, see #startUp'>
	
	self reset
]
