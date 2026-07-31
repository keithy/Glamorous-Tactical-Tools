"
I am an interface to Pharo image/environment provided singletons. 

Projects may subclass me to have a customised presentation of that interface. 

If code is to be portable to other smalltalk environments I am that replacable interface.

Values are obtained from the surrounding image context via a resumable notification. This provides a mechanism for these singletons to be overriden within a block context, and customized via subclassing.
"
Class {
	#name : 'TheHub',
	#superclass : 'Notification',
	#instVars : [
		'spokes',
		'hubs',
		'utils',
		'browsing'
	],
	#classVars : [
		'CurrentHubClass'
	],
	#classInstVars : [
		'ramdiskFileSystem'
	],
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'environment' }
TheHub class >> _ramdiskFileSystem [
	
	"class instance variable provides inherant image persistence, but use public method"
	^ ramdiskFileSystem ifNil: [  ramdiskFileSystem := FileSystem memory ]
]

{ #category : 'environment' }
TheHub class >> _ramdiskFileSystemClobber [
	
	ramdiskFileSystem := nil
]

{ #category : 'environment' }
TheHub class >> browse [

^ self newBrowsing: self current
	 
		  
]

{ #category : 'accessing' }
TheHub class >> classNamed: aName [

	^ Smalltalk at: aName asSymbol
]

{ #category : 'accessing' }
TheHub class >> classNamed: aName ifAbsent: aBlock [

	^ Smalltalk at: aName asSymbol ifAbsent: aBlock
]

{ #category : 'environment' }
TheHub class >> classPragmas: aTag in: aClass [

^ Pragma
		allNamed: aTag
		from: aClass class
		to: Object class
		
		 
		
" ^ self class allMethods select: [ :ea | ea hasPragmaNamed: #ttSpoke ]
"
]

{ #category : 'environment' }
TheHub class >> current [
	
	^ CurrentHubClass ifNil: [ CurrentHubClass := self ]
]

{ #category : 'environment' }
TheHub class >> during: aBlock use: substituteValue for: methodSelector [
	
	^ aBlock on: self current do: [  :ex | 
	
			ex tag == methodSelector
				ifTrue: [ ex resume: substituteValue ] 
				ifFalse: [ ex pass ]
		]
]

{ #category : 'environment' }
TheHub class >> fileReferenceFrom: aString [

	"Answer a FileReference or FileLocator from the supplied string.
	FileLocator origins are available as formatted strings, e.g.
		{home}/lepiter
	is the equivalent of
		FileLocator home / 'lepiter'"

	| namedDirectories regex dirName path |

	namedDirectories := self namedFileLocations. 
	
	regex := '\{([a-zA-Z]+)\}(.*)' asRegex.
	
	^ (regex matches: aString) 
			ifFalse: [ aString asFileReference ]
			ifTrue: [ 
				dirName := regex subexpression: 2.
				path := regex subexpression: 3.
				namedDirectories at: dirName
					ifPresent: [ :locator | path ifEmpty: [ locator resolve ] ifNotEmpty: [ locator resolve resolve: path allButFirst ] ]
					ifAbsent: [ self error: 'Unknown directory: ', dirName printString ] ]
	
]

{ #category : 'environment' }
TheHub class >> for: instanceMethodSelector respondWith: substituteValue during: aBlock [
	
	^ aBlock on: CurrentHubClass do: [  :ex | 
	
			ex tag == instanceMethodSelector
				ifTrue: [ ex resume: substituteValue ] 
				ifFalse: [ ex pass ]
		]
]

{ #category : 'accessing' }
TheHub class >> globalAt: aName ifAbsent: aBlock [

	^ Smalltalk at: aName asSymbol ifAbsent: aBlock
]

{ #category : 'environment' }
TheHub class >> httpClientMaximumEntitySize [

	^ CurrentHubClass _httpClientMaximumEntitySize
		
]

{ #category : 'environment' }
TheHub class >> initialize [
	
	self sessionManager
		registerSystemClassNamed: self name
		atPriority: 50.
	
	self startUp: true.
]

{ #category : 'accessing' }
TheHub class >> lookupClass: aName [

	"testable equivalent of #MyClass asClass"
	
	
]

{ #category : 'environment' }
TheHub class >> namedFileLocations [
	<ttSpoke>
	
	^ self signalAuto
]

{ #category : 'environment' }
TheHub class >> newBrowsing: aClass [ 

^ self basicNew
		readFrom: aClass;
		initialize
		
		
]

{ #category : 'environment' }
TheHub class >> onStartUpBidToBeCurrentHubClass [

	^ 1
]

{ #category : 'accessing' }
TheHub class >> openFileBrowser [

  "open a file browser, but a more discoverable option would be to list the locations"
  
	^ '.' asFileReference
]

{ #category : 'environment' }
TheHub class >> osEnvironment [
	<ttSpoke>
	
	^ self signalAuto
]

{ #category : 'environment' }
TheHub class >> platform [

	^ GRPlatform current 
	
]

{ #category : 'environment' }
TheHub class >> ramdisk [
	
	^ self signalAuto
]

{ #category : 'environment' }
TheHub class >> ramdiskFileSystem [
	
	^ CurrentHubClass _ramdiskFileSystem 
]

{ #category : 'environment' }
TheHub class >> ramdiskReset [
	
	self current _ramdiskReset
	
]

{ #category : 'environment' }
TheHub class >> ramdiskTmpUseDuring: aBlock [
	
	^ self for: #ramdisk respondWith: FileSystem memory during: aBlock
]

{ #category : 'environment' }
TheHub class >> sessionManager [
	
	^ self signalAuto
]

{ #category : 'environment' }
TheHub class >> signalAuto [	

	^ self signal: thisContext sender selector withTag: thisContext sender selector
	

]

{ #category : 'environment' }
TheHub class >> spokesCM [

^ self spokesPragmas collect: [ :ea | ea method ]
		 
]

{ #category : 'environment' }
TheHub class >> spokesPragmas [

^  self current classPragmasNamed: #ttSpoke
		 
		
" ^ self class allMethods select: [ :ea | ea hasPragmaNamed: #ttSpoke ]
"
]

{ #category : 'environment' }
TheHub class >> spokesRawAll [

^ Pragma all select: [ :ea | ea method isClassSide and: [ ea method numArgs == 0 ] ]
]

{ #category : 'environment' }
TheHub class >> startUp [
	
	| max bid |
	
	CurrentHubClass := self. 
	
	max := 0.
	self allSubclassesDo: [ :hubClass | 
	
		bid := hubClass onStartUpBidToBeCurrentHubClass.
		
		bid > max ifTrue: [
				
				CurrentHubClass := hubClass. 
				max := bid.
				
		]
	].
]

{ #category : 'environment' }
TheHub class >> unixMillisToDate: millisSinceUnixEpoch [

	<ttUtility>

	^ (DateAndTime unixEpoch + ((millisSinceUnixEpoch ifNil: [ ^ nil ]) / 1000)) asDate
]

{ #category : 'environment' }
TheHub >> current [

	^ self class current 
	

]

{ #category : 'environment' }
TheHub >> cypher [

	^ self class cypher 
	

]

{ #category : 'environment' }
TheHub >> defaultAction [

	^ self perform: tag
]

{ #category : 'environment' }
TheHub >> gtHubsFor: aView [  
	<gtView>
	
	self hubs ifEmpty: [ ^ aView empty ].
		
		^ aView columnedList
		title: 'Hubs';
		priority: 10;
		items: [ self hubs] ;
		"actionUpdateButtonTooltip: 'Update item list';"
		column: '#' 
			text: [ :eachItem :eachIndex | 
				eachIndex asRopedText foreground: Color gray ]
			width: 45;
		column: 'Item'
			text: [ :eachItem | eachItem gtDisplayText ];
		column: 'Comment'
			text: [ :eachItem | eachItem method comment ifNil: '' ];
			
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

{ #category : 'environment' }
TheHub >> gtInspectorTitleString [ 
    ^ 'Hub Browser (' ,(browsing gtDisplayString) , ')' 
]

{ #category : 'environment' }
TheHub >> gtInspectorTitleStringOn: stream [ 
  stream << 'Hub Browser (' << (browsing gtDisplayString) << ')' 
]

{ #category : 'environment' }
TheHub >> gtMessageTextFor: aView [
	<gtView>
	^ (super gtMessageTextFor: aView) priority: 90
		
]

{ #category : 'environment' }
TheHub >> gtSpokesFor: aView [  
	<gtView>
		self spokes ifEmpty: [ ^ aView empty ].
		
		^ aView columnedList
		title: 'Spokes';
		priority: 5;
		items: [ self spokes   ] ;
		"actionUpdateButtonTooltip: 'Update item list';"
		column: '#' 
			text: [ :eachItem :eachIndex | 
				eachIndex asRopedText foreground: Color gray ]
			width: 45;
		column: 'Item'
			text: [ :eachItem | eachItem gtDisplayText ];
		column: 'Comment'
			text: [ :eachItem | eachItem method comment ifNil: '' ];
			
		column: 'Open' translated
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
			
		 
"
		dynamicContextItems: [ :anElement :aCollection | 
			aCollection size = 1
				ifTrue: [ GtPhlowObjectContextMenuTarget
						menuItemsForObject: aCollection first
						hostElement: anElement ]
				ifFalse: [ GtPhlowObjectContextMenuTarget
						menuItemsForObject: aCollection
						hostElement: anElement ] ]
	"
	yourself

]

{ #category : 'environment' }
TheHub >> gtUtilsFor: aView [  

	<gtView>
	
	self utils ifEmpty: [ ^ aView empty ].
		
		^ aView columnedList
		title: 'Utils';
		priority: 15;
		items: [ self utils  ] ;
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

{ #category : 'environment' }
TheHub >> gtWallsFor: aView [  
	<gtView>
	self wall ifEmpty: [ ^ aView empty ].
		
		^ aView columnedList
		title: 'Wall';
		priority: 15;
		items: [ self wall  ] ;
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

{ #category : 'environment' }
TheHub >> hubs [

	^ browsing classPragmasNamed: #ttHub
	

]

{ #category : 'environment' }
TheHub >> namedFileLocations [

	^ (FileLocator supportedOrigins collect: [ :origin | origin -> (FileLocator origin: origin) ]) asDictionary
	
]

{ #category : 'environment' }
TheHub >> osEnvironment [

	^ OSEnvironment current
]

{ #category : 'environment' }
TheHub >> platform [

	^ GRPlatform current 
	
]

{ #category : 'environment' }
TheHub >> ramdisk [
	
	^ self current _ramdiskFileSystem
]

{ #category : 'environment' }
TheHub >> ramdiskReset [
	
	CurrentHubClass _ramdiskFileSystemClobber
	
]

{ #category : 'environment' }
TheHub >> readFrom: aHubClass [
 
  browsing := aHubClass.
	spokes := aHubClass classPragmasNamed: #ttSpoke.
	hubs := aHubClass classPragmasNamed: #ttHub.
	utils := aHubClass classPragmasNamed: #ttUtility.

]

{ #category : 'environment' }
TheHub >> sessionManager [

 <ttSpoke>
 
	^ SessionManager default
]

{ #category : 'environment' }
TheHub >> spokes [

	^ browsing classPragmasNamed: #ttSpoke.
	

]

{ #category : 'environment' }
TheHub >> utils [

	^ browsing classPragmasNamed: #ttUtility
	

]

{ #category : 'environment' }
TheHub >> wall [

	^ browsing classPragmasNamed: #ttWall
	

]
