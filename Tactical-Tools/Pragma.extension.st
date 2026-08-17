Extension { #name : 'Pragma' }

{ #category : '*Tactical-Tools' }
Pragma class >> // aClassNameOrClass [

	"experimental"

	^ Hub startDoubleDispatchfromPragmaClass: self with: aClassNameOrClass
]

{ #category : '*Tactical-Tools' }
Pragma >> // aClassNameOrClass [

	"experimental"

	^ Hub startDoubleDispatchfromPragma: self with: aClassNameOrClass
]

{ #category : '*Tactical-Tools' }
Pragma >> = aPragma [

	self == aPragma ifTrue: [^true].
	self species == aPragma species ifFalse: [^false].

	self method = aPragma method ifFalse: [^false].
	self method selector = aPragma method selector ifFalse: [ ^false ].
	self selector = aPragma selector ifFalse: [^false].
	self arguments = aPragma arguments ifFalse: [^false].

	^true
]

{ #category : '*Tactical-Tools' }
Pragma class >> ttItemsWithActionFor: aView context: theContext [

	<ttViewInCollection>
	
		^ aView columnedList
		title: '[each]';
		priority: 5;
		items: [ theContext optionAt: #theCollection ifAbsent: #() ] ;
		actionUpdateButtonTooltip: 'Update item list';
		column: '#' 
			text: [ :eachItem :eachIndex | 
				eachIndex asRopedText foreground: Color gray ]
			width: 45;
		column: 'Item'
			text: [ :eachItem | eachItem gtDisplayText ];
		column: 'Comment'
			text: [ :eachItem | eachItem method comment ifNil: '' ];
			
		column: 'Execute' translated
			stencil: [ :each | 
		 	
		 	 each method in: [ :m |
		 	 
			  	(m isClassSide and: [ m numArgs == 0 ]) 
			  		ifFalse: [ BlElement newEmpty ] 
			  		ifTrue: [
								BrButton new
									aptitude: BrGlamorousButtonWithLabelTooltipAptitude2 + 
															BrGlamorousButtonWithIconAptitude;
									icon: BrGlamorousVectorIcons playinspect;
									label: m selector asString;
									beTinySize;
											
											action: [ :button | 
										
										(m valueWithReceiver: m methodClass soleInstance arguments:#())
											   ifNotNil: [ :result | button phlow spawnObject: result ]
								  
     ] ]]]
			width: 50;
			
		 

		dynamicContextItems: [ :anElement :aCollection | 
			aCollection size = 1
				ifTrue: [ GtPhlowObjectContextMenuTarget
						menuItemsForObject: aCollection first
						hostElement: anElement ]
				ifFalse: [ GtPhlowObjectContextMenuTarget
						menuItemsForObject: aCollection
						hostElement: anElement ] ]
	

]
