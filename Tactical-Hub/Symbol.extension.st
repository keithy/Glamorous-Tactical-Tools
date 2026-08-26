Extension { #name : 'Symbol' }

{ #category : '*Tactical-Hub' }
Symbol >> / anObject [
	"unresolved"
	(SRLRouter fromSymbol: self) ifNotNil: [ :srl | ^ srl / anObject ].
	
	self error: 'Unknown scheme', self 
]

{ #category : '*Tactical-Hub' }
Symbol >> // anObject [
	"resolve"
	
	(SRLRouter fromSymbol: self) ifNotNil: [ :srl | ^ srl // anObject ].
	
	(self last == $:) ifFalse: [ self error: 'Scheme missing : (',   ('scheme:', self ,')' ) ].
	
	self error: 'Unknown scheme', self.
]
