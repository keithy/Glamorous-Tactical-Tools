Class {
	#name : 'TTHubCodeBrowser',
	#superclass : 'Object',
	#traits : 'TNamespaced',
	#classTraits : 'TNamespaced classTrait',
	#instVars : [
		'browsing'
	],
	#category : 'Tactical-Hub-Browser',
	#package : 'Tactical-Hub',
	#tag : 'Browser'
}

{ #category : 'instance creation' }
TTHubCodeBrowser class >> newBrowsing: aClass [ 

^ self basicNew
		readFrom: aClass;
		initialize
		
		
]

{ #category : 'as yet unclassified' }
TTHubCodeBrowser class >> pragmasAll_ttIsHub [

	"Hub Classes"
	
	<ttSpoke>
	
	^ Pragma allNamed: #ttIsHub
	

]

{ #category : 'instance creation' }
TTHubCodeBrowser class >> ttNamespaceDefault [ ^ 'TT'
]

{ #category : 'browsing' }
TTHubCodeBrowser >> getSpokeFromPragma: aPragma [

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
TTHubCodeBrowser >> gtAllHubsFor: aView [  
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
TTHubCodeBrowser >> gtHubsFor: aView [  
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
TTHubCodeBrowser >> gtHubsMajorFor: aView [  
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
TTHubCodeBrowser >> gtInspectorTitleString [ 
    ^ (self class ttPrettyName),' (' ,(browsing gtDisplayString) , ')' 
]

{ #category : 'browsing' }
TTHubCodeBrowser >> gtSpokesFor: aView [
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
TTHubCodeBrowser >> hubs [

	^ Hub sortByComment: 
		((Hub pragmasClassSideNamed: #ttHub in: browsing) 
				select:[ :p | p method numArgs == 0 ])

]

{ #category : 'browsing' }
TTHubCodeBrowser >> hubsAll [
	
	| deDup allHubs |
	
	allHubs := (Hub current pragmasAll_ttHub) select:[ :p | p method numArgs == 0 ].

	deDup := (allHubs collect: [ :p | p method comment -> p ]) asDictionary.
	
	^ Hub sortByComment: (deDup associations collect: [ :a | a value ]).
	
]

{ #category : 'browsing' }
TTHubCodeBrowser >> hubsMajor [
 
	^ Hub sortByComment: (self class pragmasAll_ttIsHub)
	 
]

{ #category : 'initializing' }
TTHubCodeBrowser >> readFrom: aHubClass [
 
  browsing := aHubClass.

]

{ #category : 'browsing' }
TTHubCodeBrowser >> spokes [

	^ Hub sortByComment: (
		(Hub  pragmasClassSideNamed: #ttSpoke in: browsing), 
		(Hub  pragmasNamed: #ttSpoke in: browsing))
	

]

{ #category : 'browsing' }
TTHubCodeBrowser >> utils [

	^ Hub current pragmasClassSideNamed: #ttUtility in: browsing
	
	

]

{ #category : 'browsing' }
TTHubCodeBrowser >> wall [

	^ Hub current pragmasClassSideNamed: #ttWall in: browsing
 
]
