Extension { #name : 'FAMIXNamespace' }

{ #category : '*Tactical-Fixes' }
FAMIXNamespace >> gtChildrenFor: aView [
	<gtView>
	^ aView tree
		title: 'Children';
		priority: 2;
		items: [{self}];
		stencil: [ :each | 
			BlElement new
				constraintsDo: [ :c | 
					c horizontal fitContent. 
					c vertical fitContent ];
				layout: BlLinearLayout horizontal;
				addChild: (each gtIcon ifNil: [ BrGlamorousVectorIcons empty ]) asElement;
				addChild: (BrLabel new
					aptitude: BrGlamorousListLabelAptitude;
					text: each name asRopedText) ];
		children: [ :each | 
			each structuralChildren sorted: [:entity1 :entity2 | 
				entity1 name < entity2 name] ]
]
