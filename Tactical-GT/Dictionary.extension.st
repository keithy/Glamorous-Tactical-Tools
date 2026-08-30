Extension { #name : 'Dictionary' }

{ #category : '*Tactical-GT' }
Dictionary >> addAll: aKeyedCollection [

	"Add all of the keys and values from aKeyedCollection to the dictionary.
	If the key already exists then the value is overwritten.

	```
	d1 := Dictionary new at: 1 put: 2; at: 2 put: 5; yourself.
	d2 := Dictionary new at: 1 put: 4; at: 100 put 6; yourself.
	d1 addAll: d2.  ""d1 now a Dictionary(1->4,2->5,100->6)""
	```
	"

	aKeyedCollection == self ifFalse: [
		aKeyedCollection keysAndValuesDo: [ :key :value |
			self at: key put: value ] ].
	^ aKeyedCollection
]

{ #category : '*Tactical-GT' }
Dictionary >> ttType [

^ #dictionary
]
