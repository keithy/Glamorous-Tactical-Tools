Class {
	#name : 'TheGlamorousHub',
	#superclass : 'TheHub',
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'as yet unclassified' }
TheGlamorousHub class >> _httpClientMaximumEntitySize [
	
	^ ZnCurrentOptions at: #maximumEntitySize
]

{ #category : 'environment' }
TheGlamorousHub class >> gitRepositories [

	<ttSpoke>
	
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

  ^  GtHomeToolsSection 
		  
]

{ #category : 'environment' }
TheGlamorousHub class >> homeToolsHub [

 <ttSpoke "comment">
 
 ^ self classPragmas: #ttSpoke in: GtHomeToolsSection 
		  
]

{ #category : 'environment' }
TheGlamorousHub class >> iceCredentialsStore [

	<ttSpoke>

		^ IceCredentialStore current
]

{ #category : 'environment' }
TheGlamorousHub class >> iceRegistry [

	<ttSpoke>
	
	"the list of repositories registered with the git tool"
	^ self signalAuto

]

{ #category : 'environment' }
TheGlamorousHub class >> iceRepositories [

	<ttSpoke>
	
	"the list of repositories registered with the git tool"
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
	<ttSpoke>
	^ self signalAuto
]

{ #category : 'environment' }
TheGlamorousHub class >> lepiterPropertiesFile [
	<ttSpoke>

		"this is where duplicates may be defined"
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
TheGlamorousHub class >> openGitManagerWindow [

	<ttSpoke>

	self openGitManagerFrom: nil.
	
	^ nil
]

{ #category : 'environment' }
TheGlamorousHub class >> openMonitorWindow [

	<ttSpoke>

	self openMonitorFrom: nil.
	
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
TheGlamorousHub >> gitRepositories [
	<ttSpoke>
	
	"the list of repositories registered with the git tool"
	^ IceRepository gtGitRepositories
]

{ #category : 'environment' }
TheGlamorousHub >> iceRegistry [
	<ttSpoke>
	
	"the Ice Repository manager"
	^ IceRepository 
]

{ #category : 'environment' }
TheGlamorousHub >> iceRepositories [
	
	 "the list of repositories registered with the git tool"
	^ IceRepository repositories
]

{ #category : 'environment' }
TheGlamorousHub >> lepiter [
 	
 	<ttSpoke>
 	
	^ LeDatabasesRegistry defaultLogicalDatabase
]
