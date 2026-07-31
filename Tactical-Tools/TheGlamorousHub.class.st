Class {
	#name : 'TheGlamorousHub',
	#superclass : 'TheHub',
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'environment' }
TheGlamorousHub class >> gitRepositories [

	"the list of repositories registered with the git tool"
	^ self signalAuto

]

{ #category : 'environment' }
TheGlamorousHub class >> gtImage [

	<ttSpoke>
	
	^ GtImage instance
]

{ #category : 'environment' }
TheGlamorousHub class >> homeTools [ 

	<ttHub>
		
  ^  GtHomeToolsSection 
		  
]

{ #category : 'environment' }
TheGlamorousHub class >> httpClientOptions [
	
	^ self signalAuto
]

{ #category : 'environment' }
TheGlamorousHub class >> iceCredentialsStore [

	"Iceberg registry of github credentials"
	
	<ttSpoke>

		^ IceCredentialStore current
]

{ #category : 'environment' }
TheGlamorousHub class >> iceRepositories [

	^ self signalAuto

]

{ #category : 'environment' }
TheGlamorousHub class >> iceRepositoryIncludesPackageNamed: aPackage [

	"public interface to repositories list (testable)
		 
	TheHub current for: #iceRepositories respondWith: { ... } during: [ .. ]"
	
	^ self iceRepositories 
		detect: [ :repository | repository includesPackageNamed: aPackage name ]
		ifNone: [ nil ]
		
]

{ #category : 'environment' }
TheGlamorousHub class >> iceRepositoryNamed: aString [
	
	"public interface to repositories list (testable)
	
	 TheHub current for: #iceRepositories respondWith: { ... } during: [ .. ]"
	
		^ self iceRepositories 
		
		detect: [ :each | each name = aString ]
		ifNone: [ nil ]
	 
]

{ #category : 'environment' }
TheGlamorousHub class >> lepiter [

	^ self signalAuto
]

{ #category : 'environment' }
TheGlamorousHub class >> lepiterPropertiesFile [

	"(fix this if duplicate databases are defined)"
	
	<ttSpoke>

	^ self lepiter properties localFile
]

{ #category : 'environment' }
TheGlamorousHub class >> lepiterReload [

	"re-read batabases defined in the the properties file"
	^ self lepiter reload
]

{ #category : 'environment' }
TheGlamorousHub class >> onStartUpBidToBeCurrentHubClass [
	
	"Determine if we are based on GT or Pharo (better ways?)"
	(self classNamed: #GtImage ifAbsent: [ ^ 0 ]).
	
	^ 20 
]

{ #category : 'environment' }
TheGlamorousHub class >> openGettingStartedSection [

	<ttSpoke>

	^ GtHomeMultiCardGetStartedSection new
]

{ #category : 'environment' }
TheGlamorousHub class >> openMonitor: aCard [

  "from GtHomeToolsSection"
 
	^ self
		showSpaceWithIcon: BrGlamorousVectorIcons emphasizedInspect
		title: 'Monitor'
		with: GtMonitorStencil new
		from: aCard.
 
]

{ #category : 'environment' }
TheGlamorousHub class >> openMonitorWindow [

	<ttSpoke>

	self openMonitor: nil.
	
	^ nil
]

{ #category : 'environment' }
TheGlamorousHub class >> openTranscript: aCard [

  "from GtHomeToolsSection"
 
	^ self
		showSpaceWithIcon: BrGlamorousVectorIcons emphasizedInspect
		title: 'Transcript'
		with: GtTranscriptStencil new
		from: aCard.
 
]

{ #category : 'environment' }
TheGlamorousHub class >> openTranscriptWindow [
  
  <ttSpoke>
  
	self openTranscript: nil.
	
	^ nil "nothing to spawn"
]

{ #category : 'spokes' }
TheGlamorousHub class >> pragmasAllToolButtonStencils [

	<ttSpoke>
	
	^ Pragma allNamed: #gtToolButton
	

]

{ #category : 'spokes' }
TheGlamorousHub class >> pragmasAllViews [

	<ttSpoke>
	
	^ Pragma allNamed: #gtView
	

]

{ #category : 'as yet unclassified' }
TheGlamorousHub class >> showSpaceWithIcon: anIcon title: aString with: aStencil from: anotherElement [

  "Utility method for opening an new space borrowed verbatim from GtHomeToolsSection"

	anotherElement ifNotNil: [ :elem | 
		elem enqueueTask: [elem fireEvent: BrDropdownHideWish new] asBlTask ].
	
	^ BlSpace new
		icon: anIcon;
		title: aString;
		addChild: aStencil asElement;
		withSceneDriller;
		showFrom: anotherElement
]

{ #category : 'environment' }
TheGlamorousHub class >> whatIsHome [

	<ttSpoke>
	<ttHub>

	^ GtHome
]

{ #category : 'environment' }
TheGlamorousHub >> gitRepositories [
	<ttSpoke>
	
	"the list of repositories registered with the git tool"
	^ IceRepository gtGitRepositories
]

{ #category : 'environment' }
TheGlamorousHub >> httpClientOptions [ 

	<ttSpoke>
		
  ^  ZnOptions globalDefault clone allBindings 
		  
]

{ #category : 'environment' }
TheGlamorousHub >> iceRepositories [
	
	<ttSpoke>
	
	 "the list of repositories registered with the git tool"
	^ IceRepository repositories
]

{ #category : 'environment' }
TheGlamorousHub >> lepiter [
 	"current loaded default logical database"
 	
 	<ttSpoke>
 	
	^ LeDatabasesRegistry defaultLogicalDatabase
]
