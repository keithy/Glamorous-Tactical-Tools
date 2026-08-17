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

{ #category : 'accessing' }
TTNotifyingHubAbstract class >> allIdentifyingAsClasses [

	<ttWall>
      
   ^ Smalltalk allClasses select: [ :c | c isClass ]

]

{ #category : 'accessing' }
TTNotifyingHubAbstract class >> allIdentifyingAsTraits [
      ^ Smalltalk allClasses select: [ :c | c isTrait ]

]

{ #category : 'whoami' }
TTNotifyingHubAbstract class >> bundleId [

	^ self osEnvironment at: '__CFBundleIdentifier' ifAbsent: 'gtoolkit' 
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

	 "A Better #asClass"

	 <ttWall>
	 
	 "Better, handles nil quietly, class already passthrough,
	 and fall back through namespace lookup"
   
   ^ self getClass: aClassOrName ifAbsent: [ KeyNotFound signalFor: aClassOrName ]
   
]

{ #category : 'instance creation' }
TTNotifyingHubAbstract class >> getClass: aClassOrName ifAbsent: aBlock [

	 "Better #asClass"

	 <ttWall>
	 
	"Better, handles nil, class already passthrough,
	 and fall back through namespace lookup"
	 
   aClassOrName ifNil: [ ^ aBlock value ].
   
   aClassOrName isClass ifTrue: [ ^ aClassOrName ].
   
   "This is a circumflex"
   (aClassOrName first = $ˆ) ifTrue: [ 
   		(self getClass: aClassOrName 
   				 search: self getClassSearchPath)
   				 ifNotNil: [ :found | ^ found ]
   ].
   
   ^ Smalltalk at: aClassOrName asSymbol ifAbsent: aBlock
   
]

{ #category : 'instance creation' }
TTNotifyingHubAbstract class >> getClass: circumflexAndClassName search: aList [
	aList
		do: [ :ea | 
			| namespace |
			namespace := (ea first = $$) ifFalse: [ ea ] ifTrue: [ self getEnv: ea ].

			namespace
				ifNotNil: [ (self getClass: namespace , circumflexAndClassName)
						ifNotNil: [ :found | ^ found ] ] ].

	^ self getClass: (circumflexAndClassName copyWithoutFirst)
]

{ #category : 'instance creation' }
TTNotifyingHubAbstract class >> getClassSearchPath [
	^ (self namespaceSearchPath
		collect: [ :ea | self getEnv: ea ]
		thenSelect: #notNil) asArray
]

{ #category : 'instance creation' }
TTNotifyingHubAbstract class >> getEnv: varNameWithDollar [

	"go via vault later"
	
	| varName |
	
	varName := varNameWithDollar withoutPrefix: '${'.
	varName := varName withoutSuffix: '}'.
	
	^ self osEnvironment at: (varName asSymbol) ifAbsent: nil
		

]

{ #category : 'environment' }
TTNotifyingHubAbstract class >> getVault [
	
	^ self signalAuto
]

{ #category : 'wall' }
TTNotifyingHubAbstract class >> globalAt: aName ifAbsent: aBlock [

	"Globals motherload"
	
	<ttWall>
	
	^ Smalltalk at: aName asSymbol ifAbsent: aBlock
]

{ #category : 'whoami' }
TTNotifyingHubAbstract class >> hubId [

	"The Hub"
	
	^ self current ttNamespace 
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

{ #category : 'handling' }
TTNotifyingHubAbstract class >> isWhoAmI [

	<ttWhoAmI>

	"Identity provider from environment image, in lieu of currentVault"

	^ true
]

{ #category : 'environment' }
TTNotifyingHubAbstract class >> makeFactory [

	"Fabulous Factory"
	
	<ttSpoke>
	
	^ TTFactory new
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
TTNotifyingHubAbstract class >> namespaceSearchPath [

	self subclassResponsibility
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

{ #category : 'whoami' }
TTNotifyingHubAbstract class >> projectDir [

	^ self osEnvironment at: 'PROJECT_DIR' ifAbsent: 'xanadu' 
]

{ #category : 'whoami' }
TTNotifyingHubAbstract class >> projectId [

	^ self osEnvironment at: 'PROJECT_ID' ifAbsent: 'Xanadu' 
]

{ #category : 'whoami' }
TTNotifyingHubAbstract class >> projectName [

	^ self osEnvironment at: 'PROJECT_NAME' ifAbsent: 'Xanadu' 
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
TTNotifyingHubAbstract class >> startUpAtSystemPriority: isImageStarting [
	
	<ttStartUp>
	
	| max bid |
	
	WinningHubClass := self. 
	
	max := 0.
	self allSubclassesDo: [ :hubClass | 
	
		bid := hubClass onStartUpBidToBeCurrent.
		
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
	<ttSpoke>
		
  ^  Hub getClass:#TTTacticalToolsHub 
		  
]

{ #category : 'namespace' }
TTNotifyingHubAbstract class >> ttFullName [
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
  #(NICKNAME USER USERNAME) do: [ :var |
    self osEnvironment in: [ :os | os at: var ifPresent: [ :v | ^ v ] ]
  ].
  
  ^ 'Nemo' 
]

{ #category : 'as yet unclassified' }
TTNotifyingHubAbstract class >> utils [

	^ self openBrowser utils
	

]

{ #category : 'environment' }
TTNotifyingHubAbstract class >> whoAmI [
	"For Identity before currentVault has been read, use Hub class methods"
	
	"Identity provider methods:
			 #bundleId/#bundleId/#projectId/#projectDir/#projectName,
	 For testing use  Hub with an alternative vault: 
	 Hub for: #whoAmI respondWith: (TTVault new ...) during: [ ... ]"

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

{ #category : 'environment' }
TTNotifyingHubAbstract >> current [

	^ self class current 
	

]

{ #category : 'environment' }
TTNotifyingHubAbstract >> currentTestable [
 
	^ Hub current
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

{ #category : 'environment' }
TTNotifyingHubAbstract >> getVault [

	"Vicarious Vault (Current)"
	
	<ttSpoke>
	
	^ TTVault currentVault
]

{ #category : 'namespace' }
TTNotifyingHubAbstract >> isNamespaced [
	self subclassResponsibility
]

{ #category : 'environment' }
TTNotifyingHubAbstract >> osEnvironment [

	"Host environment"
	
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

{ #category : 'whoami' }
TTNotifyingHubAbstract >> whoAmI [

	^ Hub currentVault
]
