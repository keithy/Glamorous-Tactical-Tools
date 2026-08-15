Class {
	#name : 'TTAbstractNotifyingHub',
	#superclass : 'Notification',
	#classVars : [
		'WinningHubClass'
	],
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'environment' }
TTAbstractNotifyingHub class >> _hubId [

	^ self className asLowercase
]

{ #category : 'accessing' }
TTAbstractNotifyingHub class >> allIdentifyingAsClasses [

	<ttWall>
      
   ^ Smalltalk allClasses select: [ :c | c isClass ]

]

{ #category : 'accessing' }
TTAbstractNotifyingHub class >> allIdentifyingAsTraits [
      ^ Smalltalk allClasses select: [ :c | c isTrait ]

]

{ #category : 'environment' }
TTAbstractNotifyingHub class >> bundleId [
	
	^ self signalAuto
]

{ #category : 'instance creation' }
TTAbstractNotifyingHub class >> current [
	
	^ self winningHubClass
]

{ #category : 'instance creation' }
TTAbstractNotifyingHub class >> currentTestable [
	
	^ self signalAuto
]

{ #category : 'environment' }
TTAbstractNotifyingHub class >> currentVault [
	
	^ self signalAuto
]

{ #category : 'environment' }
TTAbstractNotifyingHub class >> currentVaultUpdated: incomingNewVault [
	
	"A courtesy call from the incomming current vault"
 
]

{ #category : 'as yet unclassified' }
TTAbstractNotifyingHub class >> doRebuildMethodDictionary [
	self subclassResponsibility
]

{ #category : 'testing' }
TTAbstractNotifyingHub class >> during: aBlock use: substituteValue for: methodSelector [
	
	^ aBlock on: self current do: [  :ex | 
	
			ex tag == methodSelector
				ifTrue: [ ex resume: substituteValue ] 
				ifFalse: [ ex pass ]
		]
]

{ #category : 'testing' }
TTAbstractNotifyingHub class >> for: selector respondWith: substituteValue during: aBlock [
	
	^ aBlock on: WinningHubClass do: [  :ex | 
	
			ex messageText == selector
				ifTrue: [ ex resume: substituteValue ] 
				ifFalse: [ ex pass ]
		]
]

{ #category : 'instance creation' }
TTAbstractNotifyingHub class >> getClass: aClassOrName [

	 "Better #asClass"

	 <ttWall>
	 
	 "When you direct your makeClass request towards a preferred Hub,
	 that Hub may offer local Namespacing lookup"
	 
   self getClass: aClassOrName ifAbsent: [ KeyNotFound signalFor: aClassOrName ]
   
]

{ #category : 'instance creation' }
TTAbstractNotifyingHub class >> getClass: aClassOrName ifAbsent: aBlock [

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
TTAbstractNotifyingHub class >> getClass: aClassOrName search: aList [

	aList do: [ :ea |
		
		(Smalltalk at: (ea, aClassOrName) asSymbol ifAbsent: nil) ifNotNil: [ :c | ^ c ].
	
	].
	
	^ nil

]

{ #category : 'wall' }
TTAbstractNotifyingHub class >> globalAt: aName ifAbsent: aBlock [

	"Globals motherload"
	
	<ttWall>
	
	^ Smalltalk at: aName asSymbol ifAbsent: aBlock
]

{ #category : 'environment' }
TTAbstractNotifyingHub class >> hubId [

	"The Hub"
	
	^ self current _hubId
]

{ #category : 'environment' }
TTAbstractNotifyingHub class >> isHub [

  <ttIsHub>
  
	"The Hub"
	
	^ true
]

{ #category : 'namespace' }
TTAbstractNotifyingHub class >> isNamespaced [
	self subclassResponsibility
]

{ #category : 'environment' }
TTAbstractNotifyingHub class >> mustBeClassSide: pragma [
	
	^ pragma method isClassSide ifFalse: [
			Warning signal: pragma displayString , 'Needs to be set Class Side'.
			false.
		] ifTrue: [ true ]
			
]

{ #category : 'environment' }
TTAbstractNotifyingHub class >> namedFileLocations [
	
	^ self current signalAuto
]

{ #category : 'instance creation' }
TTAbstractNotifyingHub class >> openHubBrowser [

^ (self getClass: #TTHubBrowser) newBrowsing: self
			
	 
		  
]

{ #category : 'instance creation' }
TTAbstractNotifyingHub class >> openHubCodeBrowser [

^ (self getClass: #TTHubCodeBrowser) newBrowsing: self
			
	 
		  
]

{ #category : 'environment' }
TTAbstractNotifyingHub class >> osEnvironment [
	
	^ self current signalAuto
]

{ #category : 'wall' }
TTAbstractNotifyingHub class >> pragmasClassSideNamed: aSymbol in: aClass [
 
  "Pragma queries (class side)"
  
  <ttWall>
 
 ^ Pragma 
		allNamed: aSymbol
		from: aClass class
		toButExcluding: Object class
]

{ #category : 'wall' }
TTAbstractNotifyingHub class >> pragmasNamed: aSymbol in: aClass [
 
  "Pragma queries"
  
  <ttWall>
 
 ^ Pragma 
		allNamed: aSymbol
		from: aClass
		toButExcluding: Object  
]

{ #category : 'as yet unclassified' }
TTAbstractNotifyingHub class >> recategorizeSelector: selector from: oldProtocol to: newProtocol [
	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
TTAbstractNotifyingHub class >> removeFromComposition: aTrait [
	self subclassResponsibility
]

{ #category : 'environment' }
TTAbstractNotifyingHub class >> sessionManager [

	^ self signalAuto
]

{ #category : 'environment' }
TTAbstractNotifyingHub class >> signalAuto [	

	^ self signal: thisContext sender selector withTag: thisContext sender arguments
	

]

{ #category : 'as yet unclassified' }
TTAbstractNotifyingHub class >> smalltalkImage [
	
 ^ self signalAuto
]

{ #category : 'environment' }
TTAbstractNotifyingHub class >> sortByComment: pragmas [
 
 	"Sort Pragmas by method comment"
 	
 	<ttUtility>
 	
	^ pragmas asSortedCollection: [ :a :b | (a method comment ifNil: '') <= (b method comment ifNil: '') ] 
	

]

{ #category : 'browsing' }
TTAbstractNotifyingHub class >> spokes [

^  self openBrowser spokes
		 
 
]

{ #category : 'environment' }
TTAbstractNotifyingHub class >> spokesMethods [

^ self spokes collect: [ :ea | ea method ]
		 
]

{ #category : 'environment' }
TTAbstractNotifyingHub class >> startUp: isImageStarting [
	
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
TTAbstractNotifyingHub class >> theCuriousity [

	"Curious Things"
	
	<ttHub>
		
  ^  TheCuriousity 
		  
]

{ #category : 'environment' }
TTAbstractNotifyingHub class >> theVault [
	
	^ self signalAuto
]

{ #category : 'as yet unclassified' }
TTAbstractNotifyingHub class >> traitComposition: aComposition [
	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
TTAbstractNotifyingHub class >> traitUsers [
	self subclassResponsibility
]

{ #category : 'environment' }
TTAbstractNotifyingHub class >> tt [

	"Tactical Tools"
	
	<ttHub>
		
  ^  #TheTacticalToolsHub asClass 
		  
]

{ #category : 'namespace' }
TTAbstractNotifyingHub class >> ttFullName [
	self subclassResponsibility
]

{ #category : 'namespace' }
TTAbstractNotifyingHub class >> ttLocalName [
	self subclassResponsibility
]

{ #category : 'namespace' }
TTAbstractNotifyingHub class >> ttNamespace [
	self subclassResponsibility
]

{ #category : 'namespace' }
TTAbstractNotifyingHub class >> ttPrefixSize [
	self subclassResponsibility
]

{ #category : 'environment' }
TTAbstractNotifyingHub class >> unixMillisToDate: millisSinceUnixEpoch [

	<ttUtility>

	^ (DateAndTime unixEpoch + ((millisSinceUnixEpoch ifNil: [ ^ nil ]) / 1000)) asDate
]

{ #category : 'environment' }
TTAbstractNotifyingHub class >> userId [

	^ self osEnvironment in: [ :os | os at: 'USER' ifAbsent: [ os at: 'USERNAME' ifAbsent: [ 'nemo' ]] ] 
]

{ #category : 'as yet unclassified' }
TTAbstractNotifyingHub class >> utils [

	^ self openBrowser utils
	

]

{ #category : 'environment' }
TTAbstractNotifyingHub class >> whoAmI [
	
	^ self signalAuto
]

{ #category : 'accessing' }
TTAbstractNotifyingHub class >> winningHubClass [
	
	^ WinningHubClass ifNil: [ WinningHubClass := self ]
]

{ #category : 'environment' }
TTAbstractNotifyingHub class >> wip [

	"Work In Progress"
	
	<ttHub>
		
  ^  #WipHub asClass 
		  
]

{ #category : 'browsing' }
TTAbstractNotifyingHub >> bundleId [

	^ self class osEnvironment at: '__CFBundleIdentifier' ifAbsent: 'gtoolkit' 
]

{ #category : 'environment' }
TTAbstractNotifyingHub >> current [

	^ self class current 
	

]

{ #category : 'environment' }
TTAbstractNotifyingHub >> currentTestable [
 
	^ TheHub current
]

{ #category : 'environment' }
TTAbstractNotifyingHub >> currentVault [

	"Vicarious Vault (Current)"
	
	<ttSpoke>
	
	^ TTVault currentVault
]

{ #category : 'handling' }
TTAbstractNotifyingHub >> defaultAction [

	^ self perform: messageText withArguments: tag
]

{ #category : 'namespace' }
TTAbstractNotifyingHub >> isNamespaced [
	self subclassResponsibility
]

{ #category : 'environment' }
TTAbstractNotifyingHub >> osEnvironment [

	"Host environment"
	
	<ttSpoke>
	
	^ OSEnvironment current
]

{ #category : 'environment' }
TTAbstractNotifyingHub >> sessionManager [
 
  "Session manager - startUp/shutdown lists"
  
  <ttSpoke>
  
	^ SessionManager default
]

{ #category : 'namespace' }
TTAbstractNotifyingHub >> ttDisplayName [
	self subclassResponsibility
]

{ #category : 'namespace' }
TTAbstractNotifyingHub >> ttFullName [
	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
TTAbstractNotifyingHub >> whoAmI [

	^ TheHub currentVault
]
