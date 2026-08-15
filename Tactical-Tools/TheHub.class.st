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
		'WinningHubClass'
	],
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'environment' }
TheHub class >> _hubId [

	^ self className asLowercase
]

{ #category : 'environment' }
TheHub class >> bundleId [
	
	^ self signalAuto
]

{ #category : 'as yet unclassified' }
TheHub class >> classHttpClient [

	<ttWall>
	
	"not all environments have Zinc"
	^ self classNamed: #TTGuzzlerPharo
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
	
	^ self winningHubClass
]

{ #category : 'instance creation' }
TheHub class >> currentTestable [
	
	^ self signalAuto
]

{ #category : 'environment' }
TheHub class >> currentVault [
	
	^ self signalAuto
]

{ #category : 'testing' }
TheHub class >> during: aBlock use: substituteValue for: methodSelector [
	
	^ aBlock on: self current do: [  :ex | 
	
			ex tag == methodSelector
				ifTrue: [ ex resume: substituteValue ] 
				ifFalse: [ ex pass ]
		]
]

{ #category : 'accessing' }
TheHub class >> ensureClass: aClassOrName ifAbsent: aBlock [

   <ttWall>

   aClassOrName ifNil: [ ^ aBlock value ].
   
   aClassOrName isClass ifTrue: [ ^ aClassOrName ].
   
   ^ Smalltalk at: aClassOrName asSymbol ifAbsent: aBlock
]

{ #category : 'external-process' }
TheHub class >> execBash: script [
 
	^ (GtExternalProcessBuilder new)
			command: 'bash';
			arguments: {'-c'. script};
			yourself
]

{ #category : 'external-process' }
TheHub class >> execMiseEnvironmentIn: source [

	"Mise environment"
	
	| cd |
	
	cd := source ifNil: '' ifNotNil: [ cd := 'cd ', source, ' && ' ].
	
	^ (GtExternalProcessBuilder new)
			command: 'bash';
			arguments: {'-c'. (cd, '~/.local/bin/mise env --json-extended').};
			yourself
]

{ #category : 'external-process' }
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
TheHub class >> for: selector respondWith: substituteValue during: aBlock [
	
	^ aBlock on: WinningHubClass do: [  :ex | 
	
			ex messageText == selector
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

	^ self current _hubId
]

{ #category : 'browsing' }
TheHub class >> hubs [

	^ self openBrowser hubs
	

]

{ #category : 'handling' }
TheHub class >> isWhoAmI [

	<ttWhoAmI>

	"Identity provider from environment image"

	^ true
]

{ #category : 'accessing' }
TheHub class >> lookupClass: aName [

	"testable equivalent of #MyClass asClass"
	
	
]

{ #category : 'as yet unclassified' }
TheHub class >> makeNetworkErrorHandler [

	"Network Error Handler"
	
	<ttWall>
	
	"For your Context - Different Context, subclass TheHub"
	
	^ [ :err |
			
				(err isKindOf: NameLookupFailure)
					ifTrue: [  err messageText: 'Network problem?', err messageText ].
					
				err pass.
		  ]
		  
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

{ #category : 'instance creation' }
TheHub class >> openHubBrowser [

^ (self classNamed: #TTHubBrowser) newBrowsing: self
			
	 
		  
]

{ #category : 'instance creation' }
TheHub class >> openHubCodeBrowser [

^ (self classNamed: #TTHubCodeBrowser) newBrowsing: self
			
	 
		  
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

{ #category : 'spokes' }
TheHub class >> pragmasAll_ttUtility [

	"All of the <ttUtility>... in the world"
	
	<ttSpoke>
	
	^ TheHub sortByComment: (Pragma allNamed: #ttUtility)
	
]

{ #category : 'spokes' }
TheHub class >> pragmasAll_ttWall [

	"All of the <ttWall>... in the world"
	
	<ttSpoke>
	
	^ TheHub sortByComment: (Pragma allNamed: #ttWall)
	
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
 	
 	<ttUtility>
 	
	^ pragmas asSortedCollection: [ :a :b | (a method comment ifNil: '') <= (b method comment ifNil: '') ] 
	

]

{ #category : 'browsing' }
TheHub class >> spokes [

^  self openBrowser spokes
		 
 
]

{ #category : 'environment' }
TheHub class >> spokesMethods [

^ self spokes collect: [ :ea | ea method ]
		 
]

{ #category : 'environment' }
TheHub class >> startUp: isImageStarting [
	
	<ttStartUp>
	
	| max bid |
	
	WinningHubClass := self. 
	
	max := 0.
	self allSubclassesDo: [ :hubClass | 
	
		bid := hubClass onStartUpBidToBeBrowser.
		
		bid > max ifTrue: [
				
				WinningHubClass := hubClass. 
				max := bid.
				
		]
	].
	 
]

{ #category : 'environment' }
TheHub class >> theCuriousity [

	"Curious Things"
	
	<ttHub>
		
  ^  TheˆCuriousity 
		  
]

{ #category : 'environment' }
TheHub class >> theVault [
	
	^ self signalAuto
]

{ #category : 'environment' }
TheHub class >> tt [

	"Tactical Tools"
	
	<ttHub>
		
  ^  #TacticalToolsHub asClass 
		  
]

{ #category : 'environment' }
TheHub class >> unixMillisToDate: millisSinceUnixEpoch [

	<ttUtility>

	^ (DateAndTime unixEpoch + ((millisSinceUnixEpoch ifNil: [ ^ nil ]) / 1000)) asDate
]

{ #category : 'environment' }
TheHub class >> userId [

	^ self osEnvironment in: [ :os | os at: 'USER' ifAbsent: [ os at: 'USERNAME' ifAbsent: [ 'nemo' ]] ] 
]

{ #category : 'as yet unclassified' }
TheHub class >> utils [

	^ self openBrowser utils
	

]

{ #category : 'environment' }
TheHub class >> whoAmI [
	
	^ self signalAuto
]

{ #category : 'accessing' }
TheHub class >> winningHubClass [
	
	^ WinningHubClass ifNil: [ WinningHubClass := self ]
]

{ #category : 'environment' }
TheHub class >> wip [

	"Work In Progress"
	
	<ttHub>
		
  ^  #WipHub asClass 
		  
]

{ #category : 'browsing' }
TheHub >> bundleId [

	^ self class osEnvironment at: '__CFBundleIdentifier' ifAbsent: 'gtoolkit' 
]

{ #category : 'environment' }
TheHub >> current [

	^ self class current 
	

]

{ #category : 'environment' }
TheHub >> currentTestable [
 
	^ TheHub current
]

{ #category : 'environment' }
TheHub >> currentVault [

	"Vicarious Vault (Current)"
	
	<ttSpoke>
	
	^ TTVault currentVault
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

{ #category : 'as yet unclassified' }
TheHub >> httpClientMaximumEntitySize [
	
	^ ZnCurrentOptions at: #maximumEntitySize
]

{ #category : 'environment' }
TheHub >> namedFileLocations [
 
   "Named file locations"

   <ttSpoke>

 	^ FileLocator  namedFileLocations
	
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
TheHub >> sessionManager [
 
  "Session manager - startUp/shutdown lists"
  
  <ttSpoke>
  
	^ SessionManager default
]

{ #category : 'as yet unclassified' }
TheHub >> whoAmI [

	^ TheHub currentVault
]
