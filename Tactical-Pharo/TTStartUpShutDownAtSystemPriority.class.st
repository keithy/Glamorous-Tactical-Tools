Class {
	#name : 'TTStartUpShutDownAtSystemPriority',
	#superclass : 'Object',
	#category : 'Tactical-Pharo-StartUp/ShutDown',
	#package : 'Tactical-Pharo',
	#tag : 'StartUp/ShutDown'
}

{ #category : 'environment' }
TTStartUpShutDownAtSystemPriority class >> initialize [
	Hub sessionManager
		in: [ :sm | 
			sm
				register: (ClassSessionHandler forClassNamed: self name)
				inCategory: sm systemCategory ].

	self startUp: true
]

{ #category : 'spokes' }
TTStartUpShutDownAtSystemPriority class >> mustBeClassSide: pragma [
	
	^ pragma method isClassSide ifFalse: [
			Warning signal: pragma displayString , 'Needs to be set Class Side'.
			false.
		] ifTrue: [ true ]
			
]

{ #category : 'environment' }
TTStartUpShutDownAtSystemPriority class >> performPragma: pragma flag: isQuittingOrRestartingFlag [
	TTStartUpShutDownNotification
		signal: pragma displayString
		withTag: pragma method.
	^ pragma method methodClass soleInstance
		perform: pragma method selector
		with: isQuittingOrRestartingFlag
]

{ #category : 'spokes' }
TTStartUpShutDownAtSystemPriority class >> pragmasAll_ttShutDown [

	"Tactical-Tools startUp methods <ttShutDown>"
	
	"<ttSpoke>"
	
	^ Pragma allNamed: #ttShutDown
]

{ #category : 'spokes' }
TTStartUpShutDownAtSystemPriority class >> pragmasAll_ttStartUp [

	"Tactical-Tools startUp methods <ttStartUp>"
	
	"<ttSpoke>"
	
	^ Pragma allNamed: #ttStartUp
]

{ #category : 'environment' }
TTStartUpShutDownAtSystemPriority class >> pragmasShutDown [
	^ self pragmasAll_ttShutDown
		select: [ :p | p methodSelector = self selectorShutDown and: [ self mustBeClassSide: p ] ]
]

{ #category : 'environment' }
TTStartUpShutDownAtSystemPriority class >> pragmasStartUp [
	^ self pragmasAll_ttStartUp
		select: [ :p | p methodSelector = self selectorStartUp and: [ self mustBeClassSide: p ] ]
]

{ #category : 'spokes' }
TTStartUpShutDownAtSystemPriority class >> selectorShutDown [

	^ #shutDownAtSystemPriority:
]

{ #category : 'spokes' }
TTStartUpShutDownAtSystemPriority class >> selectorStartUp [

	^ #startUpAtSystemPriority:
]

{ #category : 'environment' }
TTStartUpShutDownAtSystemPriority class >> shutDown: quitting [
	self pragmasShutDown
		do: [ :pragma | self performPragma: pragma flag: quitting ]
]

{ #category : 'environment' }
TTStartUpShutDownAtSystemPriority class >> shutDownDryRun [
	"Sanity test startUp methods without the risk of breaking the image"

	^ TTStartUpShutDownNotification collectDuring: [ self shutDown: true ]
]

{ #category : 'environment' }
TTStartUpShutDownAtSystemPriority class >> startUp: isImageStarting [
	^ self pragmasStartUp
		do: [ :pragma | self performPragma: pragma flag: isImageStarting ]
]

{ #category : 'environment' }
TTStartUpShutDownAtSystemPriority class >> startUpDryRun [
	"Sanity test startUp methods without the risk of breaking the image"

	^ TTStartUpShutDownNotification collectDuring: [ self startUp: true ]
]
