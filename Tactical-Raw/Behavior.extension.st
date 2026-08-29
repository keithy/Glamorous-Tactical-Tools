Extension { #name : 'Behavior' }

{ #category : '*Tactical-Raw' }
Behavior >> systemIconNameTM [

	^self isAbstract
				ifTrue: [ #iconClassAbstract ]
				ifFalse: [ super systemIconNameTM ]
]
