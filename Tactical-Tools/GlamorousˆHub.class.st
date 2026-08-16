Class {
	#name : 'GlamorousˆHub',
	#superclass : 'PharoˆHub',
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'environment' }
GlamorousˆHub class >> _hubId [

	^ 'gt'
]

{ #category : 'external-process' }
GlamorousˆHub class >> execBash: script [
 
	^ (GtExternalProcessBuilder new)
			command: 'bash';
			arguments: {'-c'. script};
			yourself
]

{ #category : 'external-process' }
GlamorousˆHub class >> execMiseEnvironmentIn: source [

	"Mise environment"
	
	| cd |
	
	cd := source ifNil: '' ifNotNil: [ cd := 'cd ', source, ' && ' ].
	
	^ (GtExternalProcessBuilder new)
			command: 'bash';
			arguments: {'-c'. (cd, '~/.local/bin/mise env --json-extended').};
			yourself
]

{ #category : 'external-process' }
GlamorousˆHub class >> executeExternalProcess: processBuilder [
	
	^ self current signalAuto
]

{ #category : 'environment' }
GlamorousˆHub class >> gitRepositories [

	"the list of repositories registered with the git tool"
	^ self signalAuto

]

{ #category : 'environment' }
GlamorousˆHub class >> gtImageInfo [

	"Image information"
	
	<ttSpoke>
	
	^ GtImage instance
]

{ #category : 'environment' }
GlamorousˆHub class >> gtImageStats [

	"Live image stats"
	
	<ttSpoke>
	
	^ GtImage stats
]

{ #category : 'environment' }
GlamorousˆHub class >> homeTools [ 

	"Home Tools"
	
	<ttHub>
		
  ^  GtHomeToolsSection 
		  
]

{ #category : 'environment' }
GlamorousˆHub class >> isHub [

  <ttIsHub>
  
	"The Glamorous Hub"
	
	^ true
]

{ #category : 'environment' }
GlamorousˆHub class >> lepiter [

	^ self current signalAuto
]

{ #category : 'environment' }
GlamorousˆHub class >> lepiterPropertiesFile [

	"Lepiter properties file (fix this if duplicate databases are defined)"
	
	<ttSpoke>

	^ self lepiter properties localFile
]

{ #category : 'environment' }
GlamorousˆHub class >> lepiterReload [

	"re-read batabases defined in the the properties file"
	^ self lepiter reload
]

{ #category : 'environment' }
GlamorousˆHub class >> namespaceSearchPath [

	^ #(Glam Pharo)
]

{ #category : 'environment' }
GlamorousˆHub class >> onStartUpBidToBeBrowser [
	
	"Determine if we are based on GT or Pharo (better ways?)"
	(self getClass: #GtImage ifAbsent: [ ^ 0 ]).
	
	^ 20 
]

{ #category : 'environment' }
GlamorousˆHub class >> openGettingStartedSection [

	"Open getting started section"
	
	<ttSpoke>

	^ GtHomeMultiCardGetStartedSection new
]

{ #category : 'environment' }
GlamorousˆHub class >> openMonitor: aCard [

  "from GtHomeToolsSection"
 
	^ self
		showSpaceWithIcon: BrGlamorousVectorIcons emphasizedInspect
		title: 'Monitor'
		with: GtMonitorStencil new
		from: aCard.
 
]

{ #category : 'environment' }
GlamorousˆHub class >> openMonitorWindow [

	"Open monitor window"
	
	<ttSpoke>

	self openMonitor: nil.
	
	^ nil
]

{ #category : 'environment' }
GlamorousˆHub class >> openTranscript: aCard [

  "from GtHomeToolsSection"
 
	^ self
		showSpaceWithIcon: BrGlamorousVectorIcons emphasizedInspect
		title: 'Transcript'
		with: GtTranscriptStencil new
		from: aCard.
 
]

{ #category : 'environment' }
GlamorousˆHub class >> openTranscriptWindow [
  
  "Open transcript window"
  
  <ttSpoke>
  
	self openTranscript: nil.
	
	^ nil "nothing to spawn"
]

{ #category : 'spokes' }
GlamorousˆHub class >> pragmasAll_gtExamples [

	"All examples (needs an examples browser)"

		<ttSpoke>
	
	^ Pragma allNamed: #gtExample
	

]

{ #category : 'spokes' }
GlamorousˆHub class >> pragmasAll_gtToolButton [

	"Tool button stencils"
	
	<ttSpoke>
	
	^ Pragma allNamed: #gtToolButton
	

]

{ #category : 'spokes' }
GlamorousˆHub class >> pragmasAll_gtViews [

	"All of the views... in the world"
	
	<ttSpoke>
	
	^ Pragma allNamed: #gtView
	

]

{ #category : 'environment' }
GlamorousˆHub class >> shortCutRegistry [
 
   "Shortcut Registry"

   <ttSpoke>
 	
 	^ BlShortcutKeymapRegistry default
	 
	 
	
]

{ #category : 'as yet unclassified' }
GlamorousˆHub class >> showSpaceWithIcon: anIcon title: aString with: aStencil from: anotherElement [

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
GlamorousˆHub class >> whatIsHome [

	"Main screen layout"
	
	<ttSpoke>

	^ GtHome
]

{ #category : 'environment' }
GlamorousˆHub >> execMiseEnvironmentIn: source [

	"Mise environment"
	
	| cd |
	
	cd := source ifNil: '' ifNotNil: [ cd := 'cd ', source, ' && ' ].
	
	^ (GtExternalProcessBuilder new)
			command: 'bash';
			arguments: {'-c'. (cd, '~/.local/bin/mise env --json-extended').};
			yourself
]

{ #category : 'environment' }
GlamorousˆHub >> executeExternalProcess: processBuilder [
 
	^ processBuilder output stdout
]

{ #category : 'environment' }
GlamorousˆHub >> gitRepositories [

	"Repository browsers (iceberg/git)"

	<ttSpoke>
	
	^ IceRepository gtGitRepositories
]

{ #category : 'environment' }
GlamorousˆHub >> httpClientOptions [ 

	"Http client default options (zinc)"
	
	<ttSpoke>
		
  ^  ZnOptions globalDefault clone allBindings 
		  
]

{ #category : 'environment' }
GlamorousˆHub >> iceRepositories [
	
	"Repositories registration (git)"
	 
	<ttSpoke>

	^ IceRepository repositories
]

{ #category : 'environment' }
GlamorousˆHub >> lepiter [

 	"Lepiter - current loaded default logical database"
 	
 	<ttSpoke>
 	
	^ LeDatabasesRegistry defaultLogicalDatabase
]
