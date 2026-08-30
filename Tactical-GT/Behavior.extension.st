Extension { #name : 'Behavior' }

{ #category : '*Tactical-GT' }
Behavior >> ttType [

	^self isAbstract
				ifTrue: [ #classAbstract ]
				ifFalse: [ #class ]
]
