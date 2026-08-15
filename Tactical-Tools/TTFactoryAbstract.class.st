Class {
	#name : 'TTFactoryAbstract',
	#superclass : 'Object',
	#instVars : [
		'vault'
	],
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'as yet unclassified' }
TTFactoryAbstract class >> factoryId [

	^ ((self name withoutPrefix: 'TT') withoutSuffix: 'Factory') asLowercase
]

{ #category : 'testing' }
TTFactoryAbstract class >> isAbstract [

	^ self == TTFactoryAbstract
]

{ #category : 'as yet unclassified' }
TTFactoryAbstract class >> makeErrorHandler [

^ [ :err |
		
			(err isKindOf: NameLookupFailure)
				ifTrue: [  err messageText: 'Network problem?', err messageText ].
				
			err pass.
	  ]
]

{ #category : 'as yet unclassified' }
TTFactoryAbstract class >> makeNetworkErrorHandler [

^ [ :err |
		
			(err isKindOf: NameLookupFailure)
				ifTrue: [  err messageText: 'Network problem?', err messageText ].
				
			err pass.
	  ]
]

{ #category : 'as yet unclassified' }
TTFactoryAbstract class >> makeVaultEmpty [

	^ TTVault newEmpty
]

{ #category : 'as yet unclassified' }
TTFactoryAbstract class >> makeVaultFromCurrent [

	^ (TheHub currentVault) copy
]

{ #category : 'instance creation' }
TTFactoryAbstract class >> new [

	^ (self basicNew)
			setVault: self makeVaultFromCurrent;
			initialize
]

{ #category : 'as yet unclassified' }
TTFactoryAbstract class >> pragmasAll_ttClient [

	<ttSpoke>
	
	"All of the clients... in the world"
	
	^ "TheHub sortByComment:  "
	
	 ((Pragma allNamed: #ttClient),(Pragma allNamed: #ttApiClient))
	

]

{ #category : 'as yet unclassified' }
TTFactoryAbstract >> claim: aClassOrName andConfigure: configureBlock [
 
	| supervisingClass winningClass |
	
	supervisingClass := TheHub getClass: aClassOrName ifAbsent: [ ^ nil ].
	
	winningClass := supervisingClass findSuitableFor: self vault.
	
	^ self make: winningClass andConfigure: configureBlock

																		
]

{ #category : 'accessing' }
TTFactoryAbstract >> gtClientsFor: aView [
	<gtView>
	^ aView columnedList
		priority: 10;
		title: 'Clients Live';
		items: [ self class pragmasAll_ttClient ];
		column: 'Env'
			text: #entEnvironmentName
			width: 80;
		column: 'Name'
			text: #name
			width: 130;
		column: 'Alive?'
			stencil: (aView
					gtSoon: [ :ea | ea isAliveMessage ]
					ifPending: '??'
					ifError: nil)
			width: 150;
		column: 'Version'
			stencil: (aView
					gtSoon: [ :ea | ea serverVersion ifNil: '' ]
					ifPending: '??'
					ifError: '-')
			width: 100;
		column: 'Target' text: #gtDisplayTarget;
		contextItemLabel: 'Questions'
			action: [ :anElement :ea | anElement phlow spawnObject: (EntEnvironments with: (Array with: ea)) ];
		send: #value
]

{ #category : 'accessing' }
TTFactoryAbstract >> gtFactoryMethodsFor: aView [  
	<gtView>
	
		^ aView columnedList
		title: 'Factory';
		priority: 15;
		items: [ self class pragmasAll_ttClient] ;
		actionUpdateButtonTooltip: 'Update item list';
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

{ #category : 'accessing' }
TTFactoryAbstract >> make: aClassOrName andConfigure: configureBlock [

	| aNewClass aNewInstance |
	
	aNewClass := TheHub getClass: aClassOrName ifAbsent: [ ^ nil ].
	
	aNewInstance := aNewClass basicNewForVault: self ifFail: [ ^ nil ].

	^ (configureBlock value: aNewInstance) initializeForFactory: self ifFail: [ ^ nil ]
																		
]

{ #category : 'accessing' }
TTFactoryAbstract >> setVault: anObject [
	
	"set implies that it is essential prior to #initialize"
	
	vault := anObject
]

{ #category : 'accessing' }
TTFactoryAbstract >> vault [
	^ vault
]
