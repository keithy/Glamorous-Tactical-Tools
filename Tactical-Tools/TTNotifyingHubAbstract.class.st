Class {
	#name : 'TTNotifyingHubAbstract',
	#superclass : 'Notification',
	#classVars : [
		'WinningHubClass'
	],
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'environment' }
TTNotifyingHubAbstract class >> _hubId [

	^ self className asLowercase
]

{ #category : 'accessing' }
TTNotifyingHubAbstract class >> allIdentifyingAsClasses [

	<ttWall>
      
   ^ Smalltalk allClasses select: [ :c | c isClass ]

]

{ #category : 'accessing' }
TTNotifyingHubAbstract class >> allIdentifyingAsTraits [
      ^ Smalltalk allClasses select: [ :c | c isTrait ]

]

{ #category : 'environment' }
TTNotifyingHubAbstract class >> bundleId [
	
	^ self signalAuto
]

{ #category : 'instance creation' }
TTNotifyingHubAbstract class >> current [
	
	^ self winningHubClass
]

{ #category : 'instance creation' }
TTNotifyingHubAbstract class >> currentTestable [
	
	^ self signalAuto
]

{ #category : 'environment' }
TTNotifyingHubAbstract class >> currentVault [
	
	^ self signalAuto
]

{ #category : 'environment' }
TTNotifyingHubAbstract class >> currentVaultUpdated: incomingNewVault [
	
	"A courtesy call from the incomming current vault"
 
]

{ #category : 'as yet unclassified' }
TTNotifyingHubAbstract class >> doRebuildMethodDictionary [
	self subclassResponsibility
]

{ #category : 'testing' }
TTNotifyingHubAbstract class >> during: aBlock use: substituteValue for: methodSelector [
	
	^ aBlock on: self current do: [  :ex | 
	
			ex tag == methodSelector
				ifTrue: [ ex resume: substituteValue ] 
				ifFalse: [ ex pass ]
		]
]

{ #category : 'testing' }
TTNotifyingHubAbstract class >> for: selector respondWith: substituteValue during: aBlock [
	
	^ aBlock on: WinningHubClass do: [  :ex | 
	
			ex messageText == selector
				ifTrue: [ ex resume: substituteValue ] 
				ifFalse: [ ex pass ]
		]
]

{ #category : 'instance creation' }
TTNotifyingHubAbstract class >> getClass: aClassOrName [

	 "Better #asClass"

	 <ttWall>
	 
	 "When you direct your makeClass request towards a preferred Hub,
	 that Hub may offer local Namespacing lookup"
	 
   self getClass: aClassOrName ifAbsent: [ KeyNotFound signalFor: aClassOrName ]
   
]

{ #category : 'instance creation' }
TTNotifyingHubAbstract class >> getClass: aClassOrName ifAbsent: aBlock [

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
TTNotifyingHubAbstract class >> getClass: aClassOrName search: aList [

	aList do: [ :ea |
		
		(Smalltalk at: (ea, aClassOrName) asSymbol ifAbsent: nil) ifNotNil: [ :c | ^ c ].
	
	].
	
	^ nil

]

{ #category : 'wall' }
TTNotifyingHubAbstract class >> globalAt: aName ifAbsent: aBlock [

	"Globals motherload"
	
	<ttWall>
	
	^ Smalltalk at: aName asSymbol ifAbsent: aBlock
]

{ #category : 'environment' }
TTNotifyingHubAbstract class >> hubId [

	"The Hub"
	
	^ self current _hubId
]

{ #category : 'environment' }
TTNotifyingHubAbstract class >> isAbstract [

	^ self == TTNotifyingHubAbstract
]

{ #category : 'environment' }
TTNotifyingHubAbstract class >> isHub [

  <ttIsHub>
  
	"The Hub"
	
	^ true
]

{ #category : 'namespace' }
TTNotifyingHubAbstract class >> isNamespaced [
	self subclassResponsibility
]

{ #category : 'environment' }
TTNotifyingHubAbstract class >> mustBeClassSide: pragma [
	
	^ pragma method isClassSide ifFalse: [
			Warning signal: pragma displayString , 'Needs to be set Class Side'.
			false.
		] ifTrue: [ true ]
			
]

{ #category : 'environment' }
TTNotifyingHubAbstract class >> namedFileLocations [
	
	^ self current signalAuto
]

{ #category : 'instance creation' }
TTNotifyingHubAbstract class >> openHubBrowser [

^ (self getClass: #TTHubBrowser) newBrowsing: self
			
	 
		  
]

{ #category : 'instance creation' }
TTNotifyingHubAbstract class >> openHubCodeBrowser [

^ (self getClass: #TTHubCodeBrowser) newBrowsing: self
			
	 
		  
]

{ #category : 'environment' }
TTNotifyingHubAbstract class >> osEnvironment [
	
	^ self current signalAuto
]

{ #category : 'wall' }
TTNotifyingHubAbstract class >> pragmasClassSideNamed: aSymbol in: aClass [
 
  "Pragma queries (class side)"
  
  <ttWall>
 
 ^ Pragma 
		allNamed: aSymbol
		from: aClass class
		toButExcluding: Object class
]

{ #category : 'wall' }
TTNotifyingHubAbstract class >> pragmasNamed: aSymbol in: aClass [
 
  "Pragma queries"
  
  <ttWall>
 
 ^ Pragma 
		allNamed: aSymbol
		from: aClass
		toButExcluding: Object  
]

{ #category : 'as yet unclassified' }
TTNotifyingHubAbstract class >> recategorizeSelector: selector from: oldProtocol to: newProtocol [
	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
TTNotifyingHubAbstract class >> removeFromComposition: aTrait [
	self subclassResponsibility
]

{ #category : 'environment' }
TTNotifyingHubAbstract class >> sessionManager [

	^ self signalAuto
]

{ #category : 'environment' }
TTNotifyingHubAbstract class >> signalAuto [	

	^ self signal: thisContext sender selector withTag: thisContext sender arguments
	

]

{ #category : 'as yet unclassified' }
TTNotifyingHubAbstract class >> smalltalkImage [
	
 ^ self signalAuto
]

{ #category : 'environment' }
TTNotifyingHubAbstract class >> sortByComment: pragmas [
 
 	"Sort Pragmas by method comment"
 	
 	<ttUtility>
 	
	^ pragmas asSortedCollection: [ :a :b | (a method comment ifNil: '') <= (b method comment ifNil: '') ] 
	

]

{ #category : 'browsing' }
TTNotifyingHubAbstract class >> spokes [

^  self openBrowser spokes
		 
 
]

{ #category : 'environment' }
TTNotifyingHubAbstract class >> spokesMethods [

^ self spokes collect: [ :ea | ea method ]
		 
]

{ #category : 'environment' }
TTNotifyingHubAbstract class >> startUp: isImageStarting [
	
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
TTNotifyingHubAbstract class >> theCuriousity [

	"Curious Things"
	
	<ttHub>
		
  ^  TheCuriousity 
		  
]

{ #category : 'environment' }
TTNotifyingHubAbstract class >> theVault [
	
	^ self signalAuto
]

{ #category : 'as yet unclassified' }
TTNotifyingHubAbstract class >> traitComposition: aComposition [
	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
TTNotifyingHubAbstract class >> traitUsers [
	self subclassResponsibility
]

{ #category : 'environment' }
TTNotifyingHubAbstract class >> tt [

	"Tactical Tools"
	
	<ttHub>
		
  ^  #TheTacticalToolsHub asClass 
		  
]

{ #category : 'namespace' }
TTNotifyingHubAbstract class >> ttFullName [
	self subclassResponsibility
]

{ #category : 'namespace' }
TTNotifyingHubAbstract class >> ttLocalName [
	self subclassResponsibility
]

{ #category : 'namespace' }
TTNotifyingHubAbstract class >> ttNamespace [
	self subclassResponsibility
]

{ #category : 'namespace' }
TTNotifyingHubAbstract class >> ttPrefixSize [
	self subclassResponsibility
]

{ #category : 'environment' }
TTNotifyingHubAbstract class >> unixMillisToDate: millisSinceUnixEpoch [

	<ttUtility>

	^ (DateAndTime unixEpoch + ((millisSinceUnixEpoch ifNil: [ ^ nil ]) / 1000)) asDate
]

{ #category : 'environment' }
TTNotifyingHubAbstract class >> userId [

	^ self osEnvironment in: [ :os | os at: 'USER' ifAbsent: [ os at: 'USERNAME' ifAbsent: [ 'nemo' ]] ] 
]

{ #category : 'as yet unclassified' }
TTNotifyingHubAbstract class >> utils [

	^ self openBrowser utils
	

]

{ #category : 'environment' }
TTNotifyingHubAbstract class >> whoAmI [
	
	^ self signalAuto
]

{ #category : 'accessing' }
TTNotifyingHubAbstract class >> winningHubClass [
	
	^ WinningHubClass ifNil: [ WinningHubClass := self ]
]

{ #category : 'environment' }
TTNotifyingHubAbstract class >> wip [

	"Work In Progress"
	
	<ttHub>
		
  ^  #WipHub asClass 
		  
]

{ #category : 'browsing' }
TTNotifyingHubAbstract >> bundleId [

	^ self class osEnvironment at: '__CFBundleIdentifier' ifAbsent: 'gtoolkit' 
]

{ #category : 'environment' }
TTNotifyingHubAbstract >> current [

	^ self class current 
	

]

{ #category : 'environment' }
TTNotifyingHubAbstract >> currentTestable [
 
	^ TheHub current
]

{ #category : 'environment' }
TTNotifyingHubAbstract >> currentVault [

	"Vicarious Vault (Current)"
	
	<ttSpoke>
	
	^ TTVault currentVault
]

{ #category : 'handling' }
TTNotifyingHubAbstract >> defaultAction [

	^ self perform: messageText withArguments: tag
]

{ #category : 'namespace' }
TTNotifyingHubAbstract >> isNamespaced [
	self subclassResponsibility
]

{ #category : 'environment' }
TTNotifyingHubAbstract >> osEnvironment [

	"Host environment"
	
	<ttSpoke>
	
	^ OSEnvironment current
]

{ #category : 'environment' }
TTNotifyingHubAbstract >> sessionManager [
 
  "Session manager - startUp/shutdown lists"
  
  <ttSpoke>
  
	^ SessionManager default
]

{ #category : 'namespace' }
TTNotifyingHubAbstract >> ttDisplayName [
	self subclassResponsibility
]

{ #category : 'namespace' }
TTNotifyingHubAbstract >> ttFullName [
	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
TTNotifyingHubAbstract >> whoAmI [

	^ TheHub currentVault
]
