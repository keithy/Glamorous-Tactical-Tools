Class {
	#name : 'TTStartUpShutDownLowPriority',
	#superclass : 'TTStartUpShutDown',
	#category : 'Tactical-Pharo-StartUp/ShutDown',
	#package : 'Tactical-Pharo',
	#tag : 'StartUp/ShutDown'
}

{ #category : 'as yet unclassified' }
TTStartUpShutDownLowPriority class >> initialize [
	
	TheHub sessionManager
		registerSystemClassNamed: self name
		atPriority: 50.
	
	self startUp: true.
]

{ #category : 'as yet unclassified' }
TTStartUpShutDownLowPriority class >> selectorShutDown [

	^ #shutDownLowPriority:
]

{ #category : 'as yet unclassified' }
TTStartUpShutDownLowPriority class >> selectorStartUp [

	^ #startUpLowPriority:
]
