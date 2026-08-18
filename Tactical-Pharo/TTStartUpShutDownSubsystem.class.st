Class {
	#name : 'TTStartUpShutDownSubsystem',
	#superclass : 'Object',
	#category : 'Tactical-Pharo-StartUp-ShutDown',
	#package : 'Tactical-Pharo',
	#tag : 'StartUp-ShutDown'
}

{ #category : 'environment' }
TTStartUpShutDownSubsystem class >> config [

	^ #(AtSystemPriority AtToolsPriority)

]

{ #category : 'environment' }
TTStartUpShutDownSubsystem class >> dryRunAll [
	"Dry Run"

	<ttSpoke>
	^ TTStartUpShutDownNotification
		collectDuring: [ self pragmasAll do: [ :p | self performPragma: p flag: true ] ]
]

{ #category : 'environment' }
TTStartUpShutDownSubsystem class >> initialize [
	
	self config do: [ :ea | self perform: ('initialize', ea) asSymbol ]
]

{ #category : 'environment' }
TTStartUpShutDownSubsystem class >> initializeAtSystemPriority [
	self sessionManager
		in: [ :sm | 
			sm
				register: ((TTMessageSessionHandler forClassNamed: self name)
						startUpSelector: #startUpAtSystemPriority:;
						shutDownSelector: #shutDownAtSystemPriority:;
						yourself)
				inCategory: sm systemCategory ].

	self startUp: true
]

{ #category : 'as yet unclassified' }
TTStartUpShutDownSubsystem class >> initializeAtToolsPriority [
	self sessionManager
		in: [ :sm | 
			sm
				register: ((TTMessageSessionHandler forClassNamed: self name)
						startUpSelector: #startUpAtToolsPriority:;
						shutDownSelector: #shutDownAtToolsPriority:;
						yourself)
				inCategory: sm toolsCategory ].

	self startUp: true
]

{ #category : 'spokes' }
TTStartUpShutDownSubsystem class >> mustBeClassSide: pragma [
	
	^ pragma method isClassSide ifFalse: [
			Warning signal: pragma displayString , 'Needs to be set Class Side'.
			false.
		] ifTrue: [ true ]
			
]

{ #category : 'environment' }
TTStartUpShutDownSubsystem class >> open [

	^ TTHubCodeBrowser newBrowsing: self
]

{ #category : 'environment' }
TTStartUpShutDownSubsystem class >> performAll: pragmas withFlag: aFlag [
		
		pragmas do: [ :pragma | self performPragma: pragma flag: aFlag ]
]

{ #category : 'environment' }
TTStartUpShutDownSubsystem class >> performPragma: pragma flag: isQuittingOrRestartingFlag [
	TTStartUpShutDownNotification
		signal: pragma displayString
		withTag: pragma method.
	^ pragma method methodClass soleInstance
		perform: pragma method selector
		with: isQuittingOrRestartingFlag
]

{ #category : 'environment' }
TTStartUpShutDownSubsystem class >> pragmasAll [

	"Pragmas (all)"
	
	<ttSpoke>
	
	^ (self withAllSubclasses flatCollect: [ :ea | (self pragmasAll_ttShutDown), (self pragmasAll_ttStartUp) ] ) 
]

{ #category : 'spokes' }
TTStartUpShutDownSubsystem class >> pragmasAll_ttShutDown [

	"Tactical-Tools startUp methods <ttShutDown>"
	
	"<ttSpoke>"
	
	^ (Pragma allNamed: #ttShutDown) 
]

{ #category : 'spokes' }
TTStartUpShutDownSubsystem class >> pragmasAll_ttStartUp [

	"Tactical-Tools startUp methods <ttStartUp>"
	
	"<ttSpoke>"
	
	^ (Pragma allNamed: #ttStartUp)  
]

{ #category : 'spokes' }
TTStartUpShutDownSubsystem class >> pragmasShutDown: aShutDownSelector [
 
	^ self pragmasAll_ttShutDown
		select: [ :p | (p methodSelector = aShutDownSelector) and: [ self mustBeClassSide: p] ]
]

{ #category : 'spokes' }
TTStartUpShutDownSubsystem class >> pragmasStartUp: aStartUpSelector [
 
	^ self pragmasAll_ttStartUp
		select: [ :p | (p methodSelector = aStartUpSelector) and: [ self mustBeClassSide: p] ]
]

{ #category : 'environment' }
TTStartUpShutDownSubsystem class >> sessionManager [
	"Session Manager"

	<ttSpoke>
	^ Hub sessionManager
]

{ #category : 'environment' }
TTStartUpShutDownSubsystem class >> shutDownAtSystemPriority: isQuitting [
	^ self
		performAll: (self pragmasShutDown: #shutDownAtSystemPriority:)
		withFlag: isQuitting
]

{ #category : 'environment' }
TTStartUpShutDownSubsystem class >> shutDownAtToolsPriority: isQuitting [
	^ self
		performAll: (self pragmasShutDown: #shutDownAtToolsPriority:)
		withFlag: isQuitting
]

{ #category : 'environment' }
TTStartUpShutDownSubsystem class >> startUpAtSystemPriority: isImageRestarting [
	^ self
		performAll: (self pragmasStartUp: #startUpAtSystemPriority:)
		withFlag: isImageRestarting
]

{ #category : 'environment' }
TTStartUpShutDownSubsystem class >> startUpAtToolsPriority: isImageRestarting [
	^ self
		performAll: (self pragmasStartUp: #startUpAtToolsPriority:)
		withFlag: isImageRestarting
]
