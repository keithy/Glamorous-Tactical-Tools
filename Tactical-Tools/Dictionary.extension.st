Extension { #name : 'Dictionary' }

{ #category : '*Tactical-Tools' }
Dictionary >> associationsSortedByKey [

	<ttExtension>
	
	^ self associations asSortedCollection sortBlock: [ :a :b | a key  <= b key ] 
]

{ #category : '*Tactical-Tools' }
Dictionary >> associationsSortedByKeyInsensitively [

	<ttExtension>
	
	^ self associations asSortedCollection sortBlock: [ :a :b | a key asLowercase <= b key asLowercase ] 
]
