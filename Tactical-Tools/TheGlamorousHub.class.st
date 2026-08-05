Class {
	#name : 'TheGlamorousHub',
	#superclass : 'TheHub',
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'environment' }
TheGlamorousHub class >> TacticalHub [ 

	"Tactical Tools"
	
	<ttHub>
		
  ^  #TacticalToolsHub asClass 
		  
]

{ #category : 'environment' }
TheGlamorousHub class >> gitRepositories [

	"the list of repositories registered with the git tool"
	^ self signalAuto

]

{ #category : 'environment' }
TheGlamorousHub class >> gtImageInfo [

	"Image information"
	
	<ttSpoke>
	
	^ GtImage instance
]

{ #category : 'environment' }
TheGlamorousHub class >> gtImageStats [

	"Live image stats"
	
	<ttSpoke>
	
	^ GtImage stats
]

{ #category : 'environment' }
TheGlamorousHub class >> homeTools [ 

	"Home Tools"
	
	<ttHub>
		
  ^  GtHomeToolsSection 
		  
]

{ #category : 'environment' }
TheGlamorousHub class >> httpClientOptions [
	
	^ self signalAuto
]

{ #category : 'environment' }
TheGlamorousHub class >> iceCredentialsStore [

	"Credentials (iceberg/git)"
	
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

	^ self current signalAuto
]

{ #category : 'environment' }
TheGlamorousHub class >> lepiterPropertiesFile [

	"Lepiter properties file (fix this if duplicate databases are defined)"
	
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

	"Open getting started section"
	
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

	"Open monitor window"
	
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
  
  "Open transcript window"
  
  <ttSpoke>
  
	self openTranscript: nil.
	
	^ nil "nothing to spawn"
]

{ #category : 'spokes' }
TheGlamorousHub class >> pragmasAllToolButtonStencils [

	"Tool button stencils"
	
	<ttSpoke>
	
	^ Pragma allNamed: #gtToolButton
	

]

{ #category : 'spokes' }
TheGlamorousHub class >> pragmasAllViews [

	"All of the views... in the world"
	
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
TheGlamorousHub class >> theCuriousity [

	"Curious Things in Glamorous Toolkit"
	
	<ttHub>
		
  ^  TheCuriousity 
		  
]

{ #category : 'environment' }
TheGlamorousHub class >> whatIsHome [

	"Main screen layout"
	
	<ttSpoke>

	^ GtHome
]

{ #category : 'environment' }
TheGlamorousHub class >> wipHub [ 

	"Work In Progress"
	
	<ttHub>
		
  ^  #WipHub asClass 
		  
]

{ #category : 'environment' }
TheGlamorousHub >> gitRepositories [

	"Repository browsers (iceberg/git)"

	<ttSpoke>
	
	^ IceRepository gtGitRepositories
]

{ #category : 'environment' }
TheGlamorousHub >> httpClientOptions [ 

	"Http client default options (zinc)"
	
	<ttSpoke>
		
  ^  ZnOptions globalDefault clone allBindings 
		  
]

{ #category : 'environment' }
TheGlamorousHub >> iceRepositories [
	
	"Repositories registration (git)"
	 
	<ttSpoke>

	^ IceRepository repositories
]

{ #category : 'environment' }
TheGlamorousHub >> lepiter [

 	"Lepiter - current loaded default logical database"
 	
 	<ttSpoke>
 	
	^ LeDatabasesRegistry defaultLogicalDatabase
]
