Extension { #name : 'GtHomeSection' }

{ #category : '*Tactical-Tools' }
GtHomeSection class >> showSpaceWithIcon: anIcon title: aString with: aStencil from: anotherElement [

	anotherElement ifNotNil: [ :elem | elem enqueueTask: [ elem fireEvent: BrDropdownHideWish new] asBlTask ].
	
	^ BlSpace new
		icon: anIcon;
		title: aString;
		addChild: aStencil asElement;
		withSceneDriller;
		showFrom: anotherElement
]
