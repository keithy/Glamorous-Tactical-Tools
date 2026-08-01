Extension { #name : 'MemoryStore' }

{ #category : '*Tactical-Tools' }
MemoryStore class >> _currentFileSystem [

	<ttExtension>
	
	^ CurrentFS 
]

{ #category : '*Tactical-Tools' }
MemoryStore class >> shutDown [

	<ttFix>
	
	self reset
]
