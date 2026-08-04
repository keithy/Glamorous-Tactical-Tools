Extension { #name : 'OrderedDictionary' }

{ #category : '*Tactical-Tools' }
OrderedDictionary >> associationsCollect: aBlock [ 
	"Evaluate aBlock with each of my associations as the argument. Collect
	into a new dictionary, only those associations for which aBlock evaluates
	to a new Association."

	| newCollection |
	newCollection := self species new.
	self associationsDo: 
		[:each |    
		 (aBlock value: each) in: [ :new | new isAssociation ifTrue: [newCollection add: new ] ].
	].
	^newCollection
]
