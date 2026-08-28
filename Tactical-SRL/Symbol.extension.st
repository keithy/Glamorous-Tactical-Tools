Extension { #name : 'Symbol' }

{ #category : '*Tactical-SRL' }
Symbol >> / anObject [
	"unresolved"
  ^ (SRLRouter fromSymbol: self) / anObject
]

{ #category : '*Tactical-SRL' }
Symbol >> // anObject [

 ^	(SRLRouter fromSymbol: self) // anObject 
]
