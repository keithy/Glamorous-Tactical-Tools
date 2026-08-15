Class {
	#name : 'TTAbstractHub',
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
TTAbstractHub class >> _hubId [

	^ self className asLowercase
]

{ #category : 'accessing' }
TTAbstractHub class >> allIdentifyingAsClasses [

	<ttWall>
      
   ^ Smalltalk allClasses select: [ :c | c isClass ]

]

{ #category : 'accessing' }
TTAbstractHub class >> allIdentifyingAsTraits [
      ^ Smalltalk allClasses select: [ :c | c isTrait ]

]

{ #category : 'environment' }
TTAbstractHub class >> bundleId [
	
	^ self signalAuto
]

{ #category : 'instance creation' }
TTAbstractHub class >> current [
	
	^ self winningHubClass
]

{ #category : 'instance creation' }
TTAbstractHub class >> currentTestable [
	
	^ self signalAuto
]

{ #category : 'environment' }
TTAbstractHub class >> currentVault [
	
	^ self signalAuto
]

{ #category : 'as yet unclassified' }
TTAbstractHub class >> doRebuildMethodDictionary [
	self subclassResponsibility
]

{ #category : 'testing' }
TTAbstractHub class >> during: aBlock use: substituteValue for: methodSelector [
	
	^ aBlock on: self current do: [  :ex | 
	
			ex tag == methodSelector
				ifTrue: [ ex resume: substituteValue ] 
				ifFalse: [ ex pass ]
		]
]

{ #category : 'testing' }
TTAbstractHub class >> for: selector respondWith: substituteValue during: aBlock [
	
	^ aBlock on: WinningHubClass do: [  :ex | 
	
			ex messageText == selector
				ifTrue: [ ex resume: substituteValue ] 
				ifFalse: [ ex pass ]
		]
]

{ #category : 'instance creation' }
TTAbstractHub class >> getClass: aClassOrName [

	 "Better #asClass"

	 <ttWall>
	 
	 "When you direct your makeClass request towards a preferred Hub,
	 that Hub may offer local Namespacing lookup"
	 
   self getClass: aClassOrName ifAbsent: [ KeyNotFound signalFor: aClassOrName ]
   
]

{ #category : 'instance creation' }
TTAbstractHub class >> getClass: aClassOrName ifAbsent: aBlock [

	 "Better #asClass"

	 <ttWall>
	 
	 "When you direct your makeClass request towards a preferred Hub,
	 that Hub may offer local Namespacing lookup"
	 
   aClassOrName ifNil: [ ^ aBlock value ].
   
   aClassOrName isClass ifTrue: [ ^ aClassOrName ].
   
   (aClassOrName first = $ˆ) ifTrue: [ 
   		(self getClass: aClassOrName 
   				 search: self getClassNamespaceSearchPath)
   				 ifNotNil: [ :found | ^ found ]
   				  
   ].
   
   ^ Smalltalk at: aClassOrName asSymbol ifAbsent: aBlock
   
]

{ #category : 'instance creation' }
TTAbstractHub class >> getClass: aClassOrName search: aList [

	aList do: [ :ea |
		
		(Smalltalk at: (ea, aClassOrName) asSymbol ifAbsent: nil) ifNotNil: [ :c | ^ c ].
	
	].
	
	^ nil

]

{ #category : 'accessing' }
TTAbstractHub class >> getClassNamespaceSearchPath [

	^ #(Pharo)
]

{ #category : 'wall' }
TTAbstractHub class >> globalAt: aName ifAbsent: aBlock [

	"Globals motherload"
	
	<ttWall>
	
	^ Smalltalk at: aName asSymbol ifAbsent: aBlock
]

{ #category : 'environment' }
TTAbstractHub class >> hubId [

	"The Hub"
	
	^ self current _hubId
]

{ #category : 'environment' }
TTAbstractHub class >> isHub [

  <ttIsHub>
  
	"The Hub"
	
	^ true
]

{ #category : 'namespace' }
TTAbstractHub class >> isNamespaced [
	self subclassResponsibility
]

{ #category : 'environment' }
TTAbstractHub class >> mustBeClassSide: pragma [
	
	^ pragma method isClassSide ifFalse: [
			Warning signal: pragma displayString , 'Needs to be set Class Side'.
			false.
		] ifTrue: [ true ]
			
]

{ #category : 'environment' }
TTAbstractHub class >> namedFileLocations [
	
	^ self current signalAuto
]

{ #category : 'instance creation' }
TTAbstractHub class >> openHubBrowser [

^ (self getClass: #TTHubBrowser) newBrowsing: self
			
	 
		  
]

{ #category : 'instance creation' }
TTAbstractHub class >> openHubCodeBrowser [

^ (self getClass: #TTHubCodeBrowser) newBrowsing: self
			
	 
		  
]

{ #category : 'environment' }
TTAbstractHub class >> osEnvironment [
	
	^ self current signalAuto
]

{ #category : 'wall' }
TTAbstractHub class >> pragmasClassSideNamed: aSymbol in: aClass [
 
  "Pragma queries (class side)"
  
  <ttWall>
 
 ^ Pragma 
		allNamed: aSymbol
		from: aClass class
		toButExcluding: Object class
]

{ #category : 'wall' }
TTAbstractHub class >> pragmasNamed: aSymbol in: aClass [
 
  "Pragma queries"
  
  <ttWall>
 
 ^ Pragma 
		allNamed: aSymbol
		from: aClass
		toButExcluding: Object  
]

{ #category : 'as yet unclassified' }
TTAbstractHub class >> recategorizeSelector: selector from: oldProtocol to: newProtocol [
	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
TTAbstractHub class >> removeFromComposition: aTrait [
	self subclassResponsibility
]

{ #category : 'environment' }
TTAbstractHub class >> sessionManager [

	^ self signalAuto
]

{ #category : 'environment' }
TTAbstractHub class >> signalAuto [	

	^ self signal: thisContext sender selector withTag: thisContext sender arguments
	

]

{ #category : 'as yet unclassified' }
TTAbstractHub class >> smalltalkImage [
	
 ^ self signalAuto
]

{ #category : 'environment' }
TTAbstractHub class >> sortByComment: pragmas [
 
 	"Sort Pragmas by method comment"
 	
 	<ttUtility>
 	
	^ pragmas asSortedCollection: [ :a :b | (a method comment ifNil: '') <= (b method comment ifNil: '') ] 
	

]

{ #category : 'browsing' }
TTAbstractHub class >> spokes [

^  self openBrowser spokes
		 
 
]

{ #category : 'environment' }
TTAbstractHub class >> spokesMethods [

^ self spokes collect: [ :ea | ea method ]
		 
]

{ #category : 'environment' }
TTAbstractHub class >> startUp: isImageStarting [
	
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
TTAbstractHub class >> theCuriousity [

	"Curious Things"
	
	<ttHub>
		
  ^  TheCuriousity 
		  
]

{ #category : 'environment' }
TTAbstractHub class >> theVault [
	
	^ self signalAuto
]

{ #category : 'as yet unclassified' }
TTAbstractHub class >> traitComposition: aComposition [
	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
TTAbstractHub class >> traitUsers [
	self subclassResponsibility
]

{ #category : 'environment' }
TTAbstractHub class >> tt [

	"Tactical Tools"
	
	<ttHub>
		
  ^  #TheTacticalToolsHub asClass 
		  
]

{ #category : 'namespace' }
TTAbstractHub class >> ttFullName [
	self subclassResponsibility
]

{ #category : 'namespace' }
TTAbstractHub class >> ttLocalName [
	self subclassResponsibility
]

{ #category : 'namespace' }
TTAbstractHub class >> ttNamespace [
	self subclassResponsibility
]

{ #category : 'namespace' }
TTAbstractHub class >> ttPrefixSize [
	self subclassResponsibility
]

{ #category : 'environment' }
TTAbstractHub class >> unixMillisToDate: millisSinceUnixEpoch [

	<ttUtility>

	^ (DateAndTime unixEpoch + ((millisSinceUnixEpoch ifNil: [ ^ nil ]) / 1000)) asDate
]

{ #category : 'environment' }
TTAbstractHub class >> userId [

	^ self osEnvironment in: [ :os | os at: 'USER' ifAbsent: [ os at: 'USERNAME' ifAbsent: [ 'nemo' ]] ] 
]

{ #category : 'as yet unclassified' }
TTAbstractHub class >> utils [

	^ self openBrowser utils
	

]

{ #category : 'environment' }
TTAbstractHub class >> whoAmI [
	
	^ self signalAuto
]

{ #category : 'accessing' }
TTAbstractHub class >> winningHubClass [
	
	^ WinningHubClass ifNil: [ WinningHubClass := self ]
]

{ #category : 'environment' }
TTAbstractHub class >> wip [

	"Work In Progress"
	
	<ttHub>
		
  ^  #WipHub asClass 
		  
]

{ #category : 'browsing' }
TTAbstractHub >> bundleId [

	^ self class osEnvironment at: '__CFBundleIdentifier' ifAbsent: 'gtoolkit' 
]

{ #category : 'environment' }
TTAbstractHub >> current [

	^ self class current 
	

]

{ #category : 'environment' }
TTAbstractHub >> currentTestable [
 
	^ TheHub current
]

{ #category : 'environment' }
TTAbstractHub >> currentVault [

	"Vicarious Vault (Current)"
	
	<ttSpoke>
	
	^ TTVault currentVault
]

{ #category : 'handling' }
TTAbstractHub >> defaultAction [

	^ self perform: messageText withArguments: tag
]

{ #category : 'namespace' }
TTAbstractHub >> isNamespaced [
	self subclassResponsibility
]

{ #category : 'environment' }
TTAbstractHub >> osEnvironment [

	"Host environment"
	
	<ttSpoke>
	
	^ OSEnvironment current
]

{ #category : 'environment' }
TTAbstractHub >> sessionManager [
 
  "Session manager - startUp/shutdown lists"
  
  <ttSpoke>
  
	^ SessionManager default
]

{ #category : 'namespace' }
TTAbstractHub >> ttDisplayName [
	self subclassResponsibility
]

{ #category : 'namespace' }
TTAbstractHub >> ttFullName [
	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
TTAbstractHub >> whoAmI [

	^ TheHub currentVault
]
