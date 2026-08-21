Extension { #name : 'Symbol' }

{ #category : '*Tactical-Hub' }
Symbol >> / anObject [
	"unresolved"
	^ (SRLRouter fromSymbol: self) / anObject
]

{ #category : '*Tactical-Hub' }
Symbol >> // anObject [
	"resolve"
	^ (SRLRouter fromSymbol: self) // anObject
]
