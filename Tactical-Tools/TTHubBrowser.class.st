Class {
	#name : 'TTHubBrowser',
	#superclass : 'Object',
	#instVars : [
		'browsing'
	],
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'instance creation' }
TTHubBrowser class >> newBrowsing: aClass [ 

^ self basicNew
		readFrom: aClass;
		initialize
		
		
]

{ #category : 'as yet unclassified' }
TTHubBrowser class >> pragmasAll_ttIsHub [

	"Hub Classes"
	
	<ttSpoke>
	
	^ Pragma allNamed: #ttIsHub
	

]

{ #category : 'browsing' }
TTHubBrowser >> getSpokeFromPragma: aPragma [

	| aMethod aClass | 
	
	aMethod := aPragma method.
	aClass := aMethod methodClass.
	
	aMethod isClassSide ifTrue: [ aClass := aClass  soleInstance ].
	
	(aClass respondsTo: aMethod selector)
		ifFalse: [ 
			^ self error: 'Instance methods marked as spokes need a class side instanciation method with the same selector' ].

	^ aClass perform: aMethod selector
  
]

{ #category : 'browsing' }
TTHubBrowser >> gtAllHubsFor: aView [  
	<gtView>
	
		^ aView columnedList
		title: 'All';
		priority: 15;
		items: [ self hubsAll] ;
		"actionUpdateButtonTooltip: 'Update item list';"
		"column: '#' 
			text: [ :eachItem :eachIndex | 
				eachIndex asRopedText foreground: Color gray ]
			width: 45;"
		column: 'More'
			text: [ :eachItem | eachItem method comment ifNil: '' ];
		column: 'Pragma'
			text: [ :eachItem | eachItem gtDisplayText ];
		column: 'Open' translated
			stencil: [ :each | 
		 	
		 	 each method in: [ :m |
		 	 
			  	(m isClassSide and: [ m numArgs == 0 ]) 
			  		ifFalse: [ BlElement newEmpty ] 
			  		ifTrue: [
								BrButton new
									aptitude: BrGlamorousButtonWithLabelTooltipAptitude2 + 
															BrGlamorousButtonWithIconAptitude;
									icon: BrGlamorousVectorIcons run ;
									label: m selector asString;
									beTinySize;
											
											action: [ :button | 
									
									 (m valueWithReceiver: m methodClass soleInstance arguments:#()) 
									 in: [:hub |
											  hub ifNotNil: [ :result | button phlow spawnObject: (self class newBrowsing: hub) ] 
									]
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

{ #category : 'browsing' }
TTHubBrowser >> gtHubsFor: aView [  
	<gtView>
	
	self hubs ifEmpty: [ ^ aView empty ].
		
		^ aView columnedList
		title: 'Hubs';
		priority: 10;
		items: [ self hubs] ;
		"actionUpdateButtonTooltip: 'Update item list';"
		"column: '#' 
			text: [ :eachItem :eachIndex | 
				eachIndex asRopedText foreground: Color gray ]
			width: 45;"
		column: 'More'
			text: [ :eachItem | eachItem method comment ifNil: '' ];
		column: 'Pragma'
			text: [ :eachItem | eachItem gtDisplayText ];
		column: 'edit' translated
			stencil: [ :pragma | 
		 	
		 	 pragma method in: [ :m |
		 	 
								BrButton new
									aptitude: BrGlamorousButtonWithLabelTooltipAptitude2 + 
															BrGlamorousButtonWithIconAptitude;
									icon: BrGlamorousVectorIcons edit ;
									label: m selector asString;
									beTinySize;
											
											action: [ :button | 
									
									 (m valueWithReceiver: m methodClass soleInstance arguments:#()) 
									 in: [:hub |
									 
											  hub ifNotNil: [ :result | button phlow spawnObject: pragma ] 
									 ]
							]
     ] ]
			width: 50;
			
		send: [ :each | 
		
		  each method in: [ :m |
		 	 
			  	(m isClassSide and: [ m numArgs == 0 ]) 
			  		ifFalse: [ nil ] 
			  		ifTrue: [
								 
									 (m valueWithReceiver: m methodClass soleInstance arguments:#()) 
									 in: [:hub |
									 
											  hub ifNotNil: [ :result | (self class newBrowsing: hub) ]]]].];
											  

		dynamicContextItems: [ :anElement :aCollection | 
			aCollection size = 1
				ifTrue: [ GtPhlowObjectContextMenuTarget
						menuItemsForObject: aCollection first
						hostElement: anElement ]
				ifFalse: [ GtPhlowObjectContextMenuTarget
						menuItemsForObject: aCollection
						hostElement: anElement ] ]
	

]

{ #category : 'browsing' }
TTHubBrowser >> gtHubsMajorFor: aView [  
	<gtView>
	
	self hubs ifEmpty: [ ^ aView empty ].
		
		^ aView columnedList
		title: 'Big';
		priority: 10;
		items: [ self hubsMajor] ;
		"actionUpdateButtonTooltip: 'Update item list';"
		"column: '#' 
			text: [ :eachItem :eachIndex | 
				eachIndex asRopedText foreground: Color gray ]
			width: 45;"
		column: 'More'
			text: [ :eachItem | eachItem method comment ifNil: '' ];
		column: 'Pragma'
			text: [ :eachItem | eachItem gtDisplayText ];
		column: 'edit' translated
			stencil: [ :pragma | 
		 	
		 	 pragma method in: [ :m |
		 	 
								BrButton new
									aptitude: BrGlamorousButtonWithLabelTooltipAptitude2 + 
															BrGlamorousButtonWithIconAptitude;
									icon: BrGlamorousVectorIcons edit ;
									label: m selector asString;
									beTinySize;
											
											action: [ :button | 
									
									 (m valueWithReceiver: m methodClass soleInstance arguments:#()) 
									 in: [:hub |
									 
											  hub ifNotNil: [ :result | button phlow spawnObject: pragma ] 
									 ]
							]
     ] ]
			width: 50;
			
		send: [ :each | 
		
		  each method in: [ :m |
		 	 
			  	(m isClassSide and: [ m numArgs == 0 ]) 
			  		ifFalse: [ nil ] 
			  		ifTrue: [
								   (self class newBrowsing: m methodClass soleInstance) ]]];
											  

		dynamicContextItems: [ :anElement :aCollection | 
			aCollection size = 1
				ifTrue: [ GtPhlowObjectContextMenuTarget
						menuItemsForObject: aCollection first
						hostElement: anElement ]
				ifFalse: [ GtPhlowObjectContextMenuTarget
						menuItemsForObject: aCollection
						hostElement: anElement ] ]
	

]

{ #category : 'browsing' }
TTHubBrowser >> gtInspectorTitleString [ 
    ^ self class name,' Browser (' ,(browsing gtDisplayString) , ')' 
]

{ #category : 'browsing' }
TTHubBrowser >> gtMessageTextFor: aView [
	<gtView>
	^ (super gtMessageTextFor: aView) priority: 90
		
]

{ #category : 'browsing' }
TTHubBrowser >> gtSpokesFor: aView [
	<gtView>
	self spokes ifEmpty: [ ^ aView empty ].

	^ aView columnedList
		title: 'Spokes';
		priority: 5;
		items: [ self spokes ];
		"column: '#'
			text: [ :eachItem :eachIndex | eachIndex asRopedText foreground: Color gray ]
			width: 45;"
		column: 'Use' text: [ :eachItem | eachItem method comment ifNil: '' ];
		column: 'Pragma' text: [ :eachItem | eachItem gtDisplayText ];
		column: 'Open' translated
			stencil: [ :each | 
				
						each method numArgs == 0
							ifFalse: [ BlElement newEmpty ]
							ifTrue: [ BrButton new
									aptitude: BrGlamorousButtonWithLabelTooltipAptitude2 + BrGlamorousButtonWithIconAptitude;
									icon: BrGlamorousVectorIcons playinspect;
									label: each selector asString;
									beTinySize;
									action: [ :button | 
									
										(self getSpokeFromPragma: each ) 
											ifNotNil: [ :result | 
													button phlow spawnObject: result ] ] 
									
									] 
			]
			width: 50;
		yourself	"actionUpdateButtonTooltip: 'Update item list';"	"
		dynamicContextItems: [ :anElement :aCollection | 
			aCollection size = 1
				ifTrue: [ GtPhlowObjectContextMenuTarget
						menuItemsForObject: aCollection first
						hostElement: anElement ]
				ifFalse: [ GtPhlowObjectContextMenuTarget
						menuItemsForObject: aCollection
						hostElement: anElement ] ]
	"
]

{ #category : 'browsing' }
TTHubBrowser >> hubs [

	^ TheHub sortByComment: 
		((TheHub pragmasClassSideNamed: #ttHub in: browsing) 
				select:[ :p | p method numArgs == 0 ])

]

{ #category : 'browsing' }
TTHubBrowser >> hubsAll [
	
	| deDup allHubs |
	
	allHubs := (TheHub current pragmasAll_ttHub) select:[ :p | p method numArgs == 0 ].

	deDup := (allHubs collect: [ :p | p method comment -> p ]) asDictionary.
	
	^ TheHub sortByComment: (deDup associations collect: [ :a | a value ]).
	
]

{ #category : 'browsing' }
TTHubBrowser >> hubsMajor [
 
	^ TheHub sortByComment: (self class pragmasAll_ttIsHub)
	 
]

{ #category : 'initializing' }
TTHubBrowser >> readFrom: aHubClass [
 
  browsing := aHubClass.

]

{ #category : 'browsing' }
TTHubBrowser >> spokes [

	^ TheHub sortByComment: (
		(TheHub  pragmasClassSideNamed: #ttSpoke in: browsing), 
		(TheHub  pragmasNamed: #ttSpoke in: browsing))
	

]

{ #category : 'browsing' }
TTHubBrowser >> utils [

	^ TheHub current pragmasClassSideNamed: #ttUtility in: browsing
	
	

]

{ #category : 'browsing' }
TTHubBrowser >> wall [

	^ TheHub current pragmasClassSideNamed: #ttWall in: browsing
 
]
