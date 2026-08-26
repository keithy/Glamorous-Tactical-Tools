Class {
	#name : 'TTNotifyingHubAbstract',
	#superclass : 'Notification',
	#classVars : [
		'WinningHubClass'
	],
	#classInstVars : [
		'classSearchPath'
	],
	#category : 'Tactical-Hub-Entrypoint',
	#package : 'Tactical-Hub',
	#tag : 'Entrypoint'
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

{ #category : 'instance creation' }
TTNotifyingHubAbstract class >> classSearchPath [
	^ classSearchPath ifNil: [ classSearchPath := self getClassSearchPath ]
]

{ #category : 'instance creation' }
TTNotifyingHubAbstract class >> current [
	
	^ self winningHubClass
]

{ #category : 'instance creation' }
TTNotifyingHubAbstract class >> currentClassSearchPath [

	<gtExample>

	^  self current getClassSearchPath
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

{ #category : 'testing' }
TTNotifyingHubAbstract class >> for: selector respondWith: substituteValue during: aBlock [
	
	^ aBlock on: WinningHubClass do: [  :ex | 
	
			ex messageText == selector
				ifTrue: [ ex resume: substituteValue ] 
				ifFalse: [ ex pass ]
		]
]

{ #category : 'instance creation' }
TTNotifyingHubAbstract class >> getClassSearchPath [
	^ (self namespacedSearchPath
					collect: [ :ea | ea first = $$ ifTrue: [ #env://ea ] ifFalse: [ ea ] ]
					thenSelect: #notNil) asArray
]

{ #category : 'environment' }
TTNotifyingHubAbstract class >> getVault [
	
	^ TTVault currentVault
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
	 
	^ #namespace: // self
]

{ #category : 'environment' }
TTNotifyingHubAbstract class >> initialize [
	
	self withAllSubclassesDo: #reset.
	
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

{ #category : 'usl-schemes' }
TTNotifyingHubAbstract class >> isNamespaced [
	<namespaced>
	<namespaced:#splitAutomatically:>
	^ true
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
TTNotifyingHubAbstract class >> namespacedSearchPath [

	^ #()
]

{ #category : 'instance creation' }
TTNotifyingHubAbstract class >> open [ 

	^ self openHubCodeBrowser
	 
		  
]

{ #category : 'instance creation' }
TTNotifyingHubAbstract class >> openHubBrowser [

^ (#class:// #TTHubBrowser) newBrowsing: self
			
	 
		  
]

{ #category : 'instance creation' }
TTNotifyingHubAbstract class >> openHubCodeBrowser [

^ (#class:// #TTHubCodeBrowser) newBrowsing: self
			
	 
		  
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

{ #category : 'environment' }
TTNotifyingHubAbstract class >> reset [
	
	classSearchPath := nil.
	WinningHubClass := nil.
 
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

^  self openHubBrowser spokes
		 
 
]

{ #category : 'environment' }
TTNotifyingHubAbstract class >> spokesMethods [

^ self spokes collect: [ :ea | ea method ]
		 
]

{ #category : 'environment' }
TTNotifyingHubAbstract class >> startUpAtSystemPriority: isImageStarting [
	
	<ttStartUp>
	
	self initialize
	
]

{ #category : 'environment' }
TTNotifyingHubAbstract class >> theCuriousity [

	"Curious Things"
	
	<ttHub>
		
  ^  #class://#TheCuriousity 
		  
]

{ #category : 'environment' }
TTNotifyingHubAbstract class >> tt [

	"Tactical Tools"
	
	<ttHub>
		
  ^  #class://#TTTacticalToolsHub 
		  
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

	^ self openHubCodeBrowser utils
	

]

{ #category : 'whoami' }
TTNotifyingHubAbstract class >> vmId [

	^ self osEnvironment at: '__CFBundleIdentifier' ifAbsent: 'gtoolkit' 
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
	
	| max |
	
	WinningHubClass ifNotNil: [ :hub | ^ hub ].
	
	max := 0.
	self allSubclassesDo: [ :hubClass | 
	
		| bid |
		bid := hubClass onStartUpBidToBeCurrent.
		
		bid > max ifTrue: [
				
				WinningHubClass := hubClass. 
				max := bid.
				
		]
	].
	
	^ WinningHubClass
]

{ #category : 'environment' }
TTNotifyingHubAbstract class >> wip [

	"Work In Progress"
	
	<ttHub>
		
  ^  #WipHub asClass 
		  
]

{ #category : 'environment' }
TTNotifyingHubAbstract >> currentTestable [
 
	^ Hub current
]

{ #category : 'environment' }
TTNotifyingHubAbstract >> currentVault [

	"Vicarious Vault (Current)"
	
	<ttSpoke>
	
	^ self class getVault
]

{ #category : 'handling' }
TTNotifyingHubAbstract >> defaultAction [

	^ self perform: messageText withArguments: tag
]

{ #category : 'environment' }
TTNotifyingHubAbstract >> namedFileLocations [
 
   "Named file locations"

   <ttSpoke>

 	^ SRLFile namedLocations
	
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

{ #category : 'whoami' }
TTNotifyingHubAbstract >> whoAmI [

	^ self getVault
]
