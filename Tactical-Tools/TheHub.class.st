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

{ #category : 'instance creation' }
TheHub class >> browse [

^ self newBrowsing: self currentOrSelf
	 
		  
]

{ #category : 'wall' }
TheHub class >> classNamed: aName [

   <ttWall>

   ^ Smalltalk at: aName asSymbol
]

{ #category : 'accessing' }
TheHub class >> classNamed: aName ifAbsent: aBlock [

   <ttWall>

   	^ Smalltalk at: aName asSymbol ifAbsent: aBlock
]

{ #category : 'instance creation' }
TheHub class >> current [
	
	^ CurrentHubClass ifNil: [ CurrentHubClass := self ]
]

{ #category : 'instance creation' }
TheHub class >> currentOrSelf [

	^ self == TheHub
		 ifTrue: [ self current ]
 		ifFalse: [ self ]
	 
		  
]

{ #category : 'testing' }
TheHub class >> during: aBlock use: substituteValue for: methodSelector [
	
	^ aBlock on: self current do: [  :ex | 
	
			ex tag == methodSelector
				ifTrue: [ ex resume: substituteValue ] 
				ifFalse: [ ex pass ]
		]
]

{ #category : 'wall' }
TheHub class >> fileReferenceFrom: aString [

  <ttWall>

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

{ #category : 'testing' }
TheHub class >> for: instanceMethodSelector respondWith: substituteValue during: aBlock [
	
	^ aBlock on: CurrentHubClass do: [  :ex | 
	
			ex tag == instanceMethodSelector
				ifTrue: [ ex resume: substituteValue ] 
				ifFalse: [ ex pass ]
		]
]

{ #category : 'wall' }
TheHub class >> globalAt: aName ifAbsent: aBlock [

	<ttWall>
	
	^ Smalltalk at: aName asSymbol ifAbsent: aBlock
]

{ #category : 'wall' }
TheHub class >> httpClientMaximumEntitySize [

	<ttWall>
	
	^ self signalAuto
		
]

{ #category : 'browsing' }
TheHub class >> hubs [

	^ self browse hubs
	

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
	
	^ self signalAuto
]

{ #category : 'instance creation' }
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

   "Open a file browser"
  
   <ttSpoke>

	^ '.' asFileReference
]

{ #category : 'environment' }
TheHub class >> osEnvironment [
	
	^ self signalAuto
]

{ #category : 'environment' }
TheHub class >> platform [

	<ttWall>
	
	^ GRPlatform current 
	
]

{ #category : 'spokes' }
TheHub class >> pragmasAllExamples [

	"All examples (needs an examples browser)"

		<ttSpoke>
	
	^ Pragma allNamed: #gtExample
	

]

{ #category : 'spokes' }
TheHub class >> pragmasAllFixes [

	"Fixes pending"
	
	<ttSpoke>
	
	^ Pragma allNamed: #ttFix
	

]

{ #category : 'spokes' }
TheHub class >> pragmasAllUtility [

	"Tactical-Tools utility methods"
	
	<ttSpoke>
	
	^ Pragma allNamed: #ttUtility
	

]

{ #category : 'spokes' }
TheHub class >> pragmasAllWall [

	"Tactical-Tools wall methods"
	
	<ttSpoke>
	
	^ Pragma allNamed: #ttWall
	

]

{ #category : 'wall' }
TheHub class >> pragmasClassSideNamed: aSymbol in: aClass [
 
  <ttWall>
 
 ^ Pragma 
		allNamed: aSymbol
		from: aClass class
		toButExcluding: Object class  
]

{ #category : 'wall' }
TheHub class >> pragmasNamed: aSymbol in: aClass [
 
  <ttWall>
 
 ^ Pragma 
		allNamed: aSymbol
		from: aClass
		toButExcluding: Object  
]

{ #category : 'environment' }
TheHub class >> ramdisk [
	
	<ttWall>
	
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

	^ self current signal: thisContext sender selector withTag: thisContext sender selector
	

]

{ #category : 'as yet unclassified' }
TheHub class >> smalltalkImage [
	
 ^ self signalAuto
]

{ #category : 'browsing' }
TheHub class >> spokes [

^  self browse spokes
		 
 
]

{ #category : 'environment' }
TheHub class >> spokesMethods [

^ self spokes collect: [ :ea | ea method ]
		 
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

{ #category : 'as yet unclassified' }
TheHub class >> utils [

	^ self browse utils
	

]

{ #category : 'environment' }
TheHub >> current [

	^ self class current 
	

]

{ #category : 'handling' }
TheHub >> defaultAction [

	^ self perform: tag
]

{ #category : 'browsing' }
TheHub >> getSpokeFromPragma: aPragma [

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
TheHub >> getSpokeFromPragma: p _: button [
	^ p methodClass soleInstance
		
		in: [ :c | 
			(c respondsTo: p selector)
				ifFalse: [ ^ self
						error: 'Methods marked as instance spokes need a class side instanciation method with the same selector' ].

			(c perform: p selector)
    ]
]

{ #category : 'browsing' }
TheHub >> gtHubsFor: aView [  
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
TheHub >> gtInspectorTitleString [ 
    ^ 'Hub Browser (' ,(browsing gtDisplayString) , ')' 
]

{ #category : 'browsing' }
TheHub >> gtMessageTextFor: aView [
	<gtView>
	^ (super gtMessageTextFor: aView) priority: 90
		
]

{ #category : 'browsing' }
TheHub >> gtSpokesFor: aView [
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

{ #category : 'browsing' }
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

{ #category : 'as yet unclassified' }
TheHub >> httpClientMaximumEntitySize [
	
	^ ZnCurrentOptions at: #maximumEntitySize
]

{ #category : 'browsing' }
TheHub >> hubs [

	^ self class pragmasClassSideNamed: #ttHub in: browsing  
	

]

{ #category : 'environment' }
TheHub >> namedFileLocations [
 
   "Named file locations"

   <ttSpoke>
 	
	^ (FileLocator supportedOrigins 
			collect: [ :origin | 
				origin -> (FileLocator origin: origin) ]) asDictionary
	
]

{ #category : 'environment' }
TheHub >> osEnvironment [

	"Host environment"
	
	<ttSpoke>
	
	^ OSEnvironment current
]

{ #category : 'wall' }
TheHub >> platform [

	^ GRPlatform current 
	
]

{ #category : 'environment' }
TheHub >> ramdiskReset [
	
	CurrentHubClass _ramdiskFileSystemClobber
	
]

{ #category : 'initializing' }
TheHub >> readFrom: aHubClass [
 
  browsing := aHubClass.

]

{ #category : 'environment' }
TheHub >> sessionManager [
 
  "Session manager - startUp/shutdown lists"
  
  <ttSpoke>
  
	^ SessionManager default
]

{ #category : 'browsing' }
TheHub >> spokes [

	^ (self class pragmasClassSideNamed: #ttSpoke in: browsing), (self class pragmasNamed: #ttSpoke in: browsing)
	

]

{ #category : 'browsing' }
TheHub >> utils [

	^ self class pragmasClassSideNamed: #ttUtility in: browsing
	
	

]

{ #category : 'browsing' }
TheHub >> wall [

	^ self class pragmasClassSideNamed: #ttWall in: browsing
 
]
