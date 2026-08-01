Extension { #name : 'GtHomeToolsSection' }

{ #category : '*Tactical-Tools' }
GtHomeToolsSection >> newCoderButtonStencil [
	<gtToolButton>
	^ GtToolButtonStencil new
		title: 'Coder';
		priority: 25;
		icon: BrGlamorousVectorIcons largeBook;
		action: [ :card | self class openCoder: card ];
		description: 'Browse and manipulate code.';
		elementId: GtHomeCoderButtonId
]

{ #category : '*Tactical-Tools' }
GtHomeToolsSection >> newGitButtonStencil [
	<gtToolButton>
	^ GtToolButtonStencil new
		title: 'Git';
		priority: 30;
		icon: BrGlamorousVectorIcons largebranching;
		action: [ :card | self class openGitManager: card ];
		description: 'Manage git repositories.'
]

{ #category : '*Tactical-Tools' }
GtHomeToolsSection >> newMonitorButtonStencil [
	<gtToolButton>
	^ GtToolButtonStencil new
		title: 'Monitor';
		priority: 40;
		icon: BrGlamorousVectorIcons largeSignal;
		action: [ :card | self class openMonitor: card ];
		description: 'Monitor processes and high level tasks.'
]

{ #category : '*Tactical-Tools' }
GtHomeToolsSection class >> openCoder: from [
	^ self
		showSpaceWithIcon: BrGlamorousVectorIcons emphasizedBrowse
		title: 'Coder'
		with: GtCoderStencil new
		from: from
]

{ #category : '*Tactical-Tools' }
GtHomeToolsSection class >> openCoderWindow [
	
	<ttSpoke>
	
	self openCoder: nil.
	
	^ nil "dont spawn"
]

{ #category : '*Tactical-Tools' }
GtHomeToolsSection class >> openGitManager: card [
	^ self
		showSpaceWithIcon: BrGlamorousVectorIcons emphasizedInspect
		title: 'Git'
		with: GtGitStencil new
		from: card
]

{ #category : '*Tactical-Tools' }
GtHomeToolsSection class >> openGitManagerWindow [
	
	<ttSpoke>
	
	self openGitManager: nil.
	
	^ nil "dont spawn"
]

{ #category : '*Tactical-Tools' }
GtHomeToolsSection class >> openMonitor: card [

^ self
		showSpaceWithIcon: BrGlamorousVectorIcons emphasizedInspect
		title: 'Monitor'
		with: (GtInspector createOn: GtMonitor new) maximized
		from: card


]

{ #category : '*Tactical-Tools' }
GtHomeToolsSection class >> openMonitorWindow [
	
	<ttSpoke>
	
	self openMonitor: nil.
	
	^ nil "dont spawn"
]

{ #category : '*Tactical-Tools' }
GtHomeToolsSection class >> openPlayground: card [
	^ 
	self
				showSpaceWithIcon: GtPlaygroundStencil playgroundClass defaultIcon
				title: 'Playground'
				with: (GtPlaygroundStencil new
					knowledgeBase: self knowledgeBase)
				from: card
	
	 
]

{ #category : '*Tactical-Tools' }
GtHomeToolsSection class >> openTranscript: card [
	^ self
		showSpaceWithIcon: BrGlamorousVectorIcons emphasizedInspect
		title: 'Transcript'
		with: GtTranscriptStencil new
		from: card
		
		
		
	 
]

{ #category : '*Tactical-Tools' }
GtHomeToolsSection class >> openTranscriptWindow [
	
	<ttSpoke>
	
	self openTranscript: nil.
	
	^ nil "dont spawn"
]
