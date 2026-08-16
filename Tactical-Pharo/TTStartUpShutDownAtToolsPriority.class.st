Class {
	#name : 'TTStartUpShutDownAtToolsPriority',
	#superclass : 'TTStartUpShutDownAtSystemPriority',
	#category : 'Tactical-Pharo-StartUp/ShutDown',
	#package : 'Tactical-Pharo',
	#tag : 'StartUp/ShutDown'
}

{ #category : 'as yet unclassified' }
TTStartUpShutDownAtToolsPriority class >> initialize [
	Hub sessionManager
		in: [ :sm | 
			sm
				register: (ClassSessionHandler forClassNamed: self name)
				inCategory: sm toolsCategory ].

	self startUp: true
]

{ #category : 'as yet unclassified' }
TTStartUpShutDownAtToolsPriority class >> selectorShutDown [

	^ #shutDownAtToolPriority:
]

{ #category : 'as yet unclassified' }
TTStartUpShutDownAtToolsPriority class >> selectorStartUp [

	^ #startUpAtToolPriority:
]
