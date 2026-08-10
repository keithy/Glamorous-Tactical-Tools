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
		'WinningBrowserHubClass'
	],
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'instance creation' }
TheHub class >> browse [

^ self winningBrowserHubClass newBrowsing: self
	 
		  
]

{ #category : 'instance creation' }
TheHub class >> browser [
	
	^ self winningBrowserHubClass 
]

{ #category : 'environment' }
TheHub class >> bundleId [
	
	^ self signalAuto
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

{ #category : 'wall' }
TheHub class >> collectNotificationsOfClass: aNotificationClass during: aBlock [

	"Debugging pattern"

  <ttWall>
 
	| list |
	
	list := OrderedCollection new.
	
	aBlock on: aNotificationClass do: [ :ex | list add: ex. ex pass ].

	^ list asArray
]

{ #category : 'instance creation' }
TheHub class >> current [
	
	^ self winningBrowserHubClass
]

{ #category : 'instance creation' }
TheHub class >> currentOrSubclass [

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

{ #category : 'environment' }
TheHub class >> execBash: script [
 
	^ (GtExternalProcessBuilder new)
			command: 'bash';
			arguments: {'-c'. script};
			yourself
]

{ #category : 'environment' }
TheHub class >> execMiseEnvironmentIn: source [

	"Mise environment"
	
	| cd |
	
	cd := source ifNil: '' ifNotNil: [ cd := 'cd ', source, ' && ' ].
	
	^ (GtExternalProcessBuilder new)
			command: 'bash';
			arguments: {'-c'. (cd, '~/.local/bin/mise env --json-extended').};
			yourself
]

{ #category : 'environment' }
TheHub class >> executeExternalProcess: processBuilder [
	
	^ self current signalAuto
]

{ #category : 'wall' }
TheHub class >> fileLocatorFrom: aString [

  <ttWall>

	"Answer a  FileLocator from the supplied string"

	^ FileLocator fromPath: (self fileReferenceFrom: aString) path ifNone: [ self error: '?' ]
	
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
	
	^ aBlock on: WinningBrowserHubClass do: [  :ex | 
	
			ex messageText == instanceMethodSelector
				ifTrue: [ ex resume: substituteValue ] 
				ifFalse: [ ex pass ]
		]
]

{ #category : 'wall' }
TheHub class >> globalAt: aName ifAbsent: aBlock [

	"Globals motherload"
	
	<ttWall>
	
	^ Smalltalk at: aName asSymbol ifAbsent: aBlock
]

{ #category : 'environment' }
TheHub class >> gt [

	"The Glamorous Toolkit"
	
	<ttHub>
		
  ^  TheGlamorousHub 
		  
]

{ #category : 'wall' }
TheHub class >> httpClientMaximumEntitySize [

	<ttWall>
	
	^ self signalAuto
		
]

{ #category : 'environment' }
TheHub class >> hubId [

	^ self className asLowercase
]

{ #category : 'browsing' }
TheHub class >> hubs [

	^ self browse hubs
	

]

{ #category : 'handling' }
TheHub class >> isWhoAmI [

	<ttWhoAmI>

	"Can provide identity"

	^ true
]

{ #category : 'accessing' }
TheHub class >> lookupClass: aName [

	"testable equivalent of #MyClass asClass"
	
	
]

{ #category : 'environment' }
TheHub class >> mustBeClassSide: pragma [
	
	^ pragma method isClassSide ifFalse: [
			Warning signal: pragma displayString , 'Needs to be set Class Side'.
			false.
		] ifTrue: [ true ]
			
]

{ #category : 'environment' }
TheHub class >> namedFileLocations [
	
	^ self current signalAuto
]

{ #category : 'instance creation' }
TheHub class >> newBrowsing: aClass [ 

^ self basicNew
		readFrom: aClass;
		initialize
		
		
]

{ #category : 'environment' }
TheHub class >> onStartUpBidToBeBrowser [

	^ 1
]

{ #category : 'environment' }
TheHub class >> openFileBrowser [

	"Current Working Directory"
	
	<ttSpoke>
	
	^ '.' asFileReference
]

{ #category : 'environment' }
TheHub class >> osEnvironment [
	
	^ self current signalAuto
]

{ #category : 'environment' }
TheHub class >> platform [

  "Grease Platform"
  
	<ttWall>
	
	^ GRPlatform current 
	
]

{ #category : 'spokes' }
TheHub class >> pragmasAll_ttHealthy [

	"Environment health checks"
	
	<ttSpoke>
	
	^ #ttHealthCheck gtPragmas
	

]

{ #category : 'spokes' }
TheHub class >> pragmasAll_ttHub [

	"All of the hubs... in the world"
	
	^ TheHub sortByComment: (Pragma allNamed: #ttHub)
	
]

{ #category : 'wall' }
TheHub class >> pragmasClassSideNamed: aSymbol in: aClass [
 
  "Pragma queries (class side)"
  
  <ttWall>
 
 ^ Pragma 
		allNamed: aSymbol
		from: aClass class
		toButExcluding: Object class
]

{ #category : 'wall' }
TheHub class >> pragmasNamed: aSymbol in: aClass [
 
  "Pragma queries"
  
  <ttWall>
 
 ^ Pragma 
		allNamed: aSymbol
		from: aClass
		toButExcluding: Object  
]

{ #category : 'environment' }
TheHub class >> sessionManager [

	^ self signalAuto
]

{ #category : 'environment' }
TheHub class >> shortCutRegistry [
 
   "Shortcut Registry"

   <ttSpoke>
 	
 	^ BlShortcutKeymapRegistry default
	 
	 
	
]

{ #category : 'environment' }
TheHub class >> signalAuto [	

	^ self signal: thisContext sender selector withTag: thisContext sender arguments
	

]

{ #category : 'as yet unclassified' }
TheHub class >> smalltalkImage [
	
 ^ self signalAuto
]

{ #category : 'environment' }
TheHub class >> sortByComment: pragmas [
 
 	"Sort Pragmas by method comment"
 	
 	<ttUtil>
 	
	^ pragmas asSortedCollection: [ :a :b | a method comment <= (b method comment) ] 
	

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
TheHub class >> startUp: isImageStarting [
	
	<ttStartUp>
	
	| max bid |
	
	WinningBrowserHubClass := self. 
	
	max := 0.
	self allSubclassesDo: [ :hubClass | 
	
		bid := hubClass onStartUpBidToBeBrowser.
		
		bid > max ifTrue: [
				
				WinningBrowserHubClass := hubClass. 
				max := bid.
				
		]
	].
	 
]

{ #category : 'environment' }
TheHub class >> theCuriousity [

	"Curious Things"
	
	<ttHub>
		
  ^  TheCuriousity 
		  
]

{ #category : 'environment' }
TheHub class >> theVault [
	
	^ self signalAuto
]

{ #category : 'environment' }
TheHub class >> unixMillisToDate: millisSinceUnixEpoch [

	<ttUtility>

	^ (DateAndTime unixEpoch + ((millisSinceUnixEpoch ifNil: [ ^ nil ]) / 1000)) asDate
]

{ #category : 'environment' }
TheHub class >> userId [

	^ self osEnvironment in: [ :os | os at: 'USER' ifAbsent: [ os at: 'USERNAME' ifAbsent: [ 'bob' ]] ] 
]

{ #category : 'as yet unclassified' }
TheHub class >> utils [

	^ self browse utils
	

]

{ #category : 'environment' }
TheHub class >> whoAmI [
	
	^ self signalAuto
]

{ #category : 'accessing' }
TheHub class >> winningBrowserHubClass [
	
	^ WinningBrowserHubClass ifNil: [ WinningBrowserHubClass := self ]
]

{ #category : 'environment' }
TheHub >> browser [

	^ self class browser
	

]

{ #category : 'browsing' }
TheHub >> bundleId [

	^ self class osEnvironment at: '__CFBundleIdentifier' ifAbsent: 'gtoolkit' 
]

{ #category : 'environment' }
TheHub >> current [

	^ self class current 
	

]

{ #category : 'handling' }
TheHub >> defaultAction [

	^ self perform: messageText withArguments: tag
]

{ #category : 'environment' }
TheHub >> execMiseEnvironmentIn: source [

	"Mise environment"
	
	| cd |
	
	cd := source ifNil: '' ifNotNil: [ cd := 'cd ', source, ' && ' ].
	
	^ (GtExternalProcessBuilder new)
			command: 'bash';
			arguments: {'-c'. (cd, '~/.local/bin/mise env --json-extended').};
			yourself
]

{ #category : 'environment' }
TheHub >> executeExternalProcess: processBuilder [
 
	^ processBuilder output stdout
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
TheHub >> gtAllHubsFor: aView [  
	<gtView>
	
		^ aView columnedList
		title: 'All';
		priority: 15;
		items: [ self class pragmasAll_ttHub] ;
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
TheHub >> gtInspectorTitleString [ 
    ^ self class name,' Browser (' ,(browsing gtDisplayString) , ')' 
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

{ #category : 'as yet unclassified' }
TheHub >> httpClientMaximumEntitySize [
	
	^ ZnCurrentOptions at: #maximumEntitySize
]

{ #category : 'browsing' }
TheHub >> hubs [

	^ TheHub sortByComment: 
		((self class pragmasClassSideNamed: #ttHub in: browsing) 
				select:[ :p | p method numArgs == 0 ])

]

{ #category : 'environment' }
TheHub >> namedFileLocations [
 
   "Named file locations"

   <ttSpoke>
 	
 	| origins | 
 	
 	origins := Dictionary new.
 	
	 FileLocator supportedOriginsDo: [ :resolver :selector | 
		 	
		 		origins at: selector put: (FileLocator origin: selector) 
	 ].
	 
	 ^ origins
	
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

	^ TheHub sortByComment: (
		(self class pragmasClassSideNamed: #ttSpoke in: browsing), 
		(self class pragmasNamed: #ttSpoke in: browsing))
	

]

{ #category : 'as yet unclassified' }
TheHub >> theVault [

	"Vicarious Vault"
	
	<ttSpoke>
	
	^ TTVault currentVault
]

{ #category : 'browsing' }
TheHub >> utils [

	^ self class pragmasClassSideNamed: #ttUtility in: browsing
	
	

]

{ #category : 'browsing' }
TheHub >> wall [

	^ self class pragmasClassSideNamed: #ttWall in: browsing
 
]

{ #category : 'as yet unclassified' }
TheHub >> whoAmI [

	"Vicarious Vault"
	
	<ttSpoke>
	
	^ TTVault currentVault
]
