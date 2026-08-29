Extension { #name : 'Behavior' }

{ #category : '*Tactical-Raw' }
Behavior >> rawInstanceIconName [

	^self isAbstract
				ifTrue: [ #iconClassAbstract ]
				ifFalse: [ super rawInstanceIconName ]
]

{ #category : '*Tactical-Raw' }
Behavior >> ttType [

	^self isAbstract
				ifTrue: [ #classAbstract ]
				ifFalse: [ #class ]
]
