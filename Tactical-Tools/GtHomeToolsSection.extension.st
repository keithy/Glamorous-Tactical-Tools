Extension { #name : 'GtHomeToolsSection' }

{ #category : '*Tactical-Tools-GT' }
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

{ #category : '*Tactical-Tools-GT' }
GtHomeToolsSection >> newGitButtonStencil [
	<gtToolButton>
	^ GtToolButtonStencil new
		title: 'Git';
		priority: 30;
		icon: BrGlamorousVectorIcons largebranching;
		action: [ :card | self class openGitManager: card ];
		description: 'Manage git repositories.'
]

{ #category : '*Tactical-Tools-GT' }
GtHomeToolsSection >> newMonitorButtonStencil [
	<gtToolButton>
	^ GtToolButtonStencil new
		title: 'Monitor';
		priority: 40;
		icon: BrGlamorousVectorIcons largeSignal;
		action: [ :card | self class openMonitor: card ];
		description: 'Monitor processes and high level tasks.'
]

{ #category : '*Tactical-Tools-GT' }
GtHomeToolsSection class >> openCoder: from [
	^ self
		showSpaceWithIcon: BrGlamorousVectorIcons emphasizedBrowse
		title: 'Coder'
		with: GtCoderStencil new
		from: from
]

{ #category : '*Tactical-Tools-GT' }
GtHomeToolsSection class >> openCoderWindow [
	
	<ttSpoke>
	
	self openCoder: nil.
	
	^ nil "dont spawn"
]

{ #category : '*Tactical-Tools-GT' }
GtHomeToolsSection class >> openGitManager: card [
	^ self
		showSpaceWithIcon: BrGlamorousVectorIcons emphasizedInspect
		title: 'Git'
		with: GtGitStencil new
		from: card
]

{ #category : '*Tactical-Tools-GT' }
GtHomeToolsSection class >> openGitManagerWindow [
	
	<ttSpoke>
	
	self openGitManager: nil.
	
	^ nil "dont spawn"
]

{ #category : '*Tactical-Tools-GT' }
GtHomeToolsSection class >> openMonitorWindow [
	
	<ttSpoke>
	
	self openMonitor: nil.
	
	^ nil "dont spawn"
]

{ #category : '*Tactical-Tools-GT' }
GtHomeToolsSection class >> openTranscript: card [
	^ self
		showSpaceWithIcon: BrGlamorousVectorIcons emphasizedInspect
		title: 'Transcript'
		with: GtTranscriptStencil new
		from: card
]

{ #category : '*Tactical-Tools-GT' }
GtHomeToolsSection class >> openTranscriptWindow [
	
	<ttSpoke>
	
	self openTranscript: nil.
	
	^ nil "dont spawn"
]
