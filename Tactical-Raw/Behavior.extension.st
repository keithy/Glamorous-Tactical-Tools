Extension { #name : 'Behavior' }

{ #category : '*Tactical-Raw' }
Behavior >> ttType [

	^self isAbstract
				ifTrue: [ #classAbstract ]
				ifFalse: [ #class ]
]
