Extension { #name : 'Dictionary' }

{ #category : '*Tactical-Tools' }
Dictionary class >> // anSRL [

	^ self newFromSRL: anSRL
]

{ #category : '*Tactical-Tools' }
Dictionary class >> <@ anSRL [

	^ self newFromSRL: anSRL
]

{ #category : '*Tactical-Tools' }
Dictionary >> asTier [

	 ^ TTDictionaryTiered new
	 		setDictionary: self;
	 		yourself
]

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

{ #category : '*Tactical-Tools' }
Dictionary class >> makeAsTierWithKey: aKey [  

	<gtExample>

	^  (TTDictionaryTiered newWithKey: aKey) 
			setDictionary: self new  ;
			yourself
]

{ #category : '*Tactical-Tools' }
Dictionary class >> newFromSRL: anSRL [
  "convenience - replace with better"
	^ STONJSON fromString: anSRL contents
]
