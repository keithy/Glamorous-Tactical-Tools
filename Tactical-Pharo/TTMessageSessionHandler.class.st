Class {
	#name : 'TTMessageSessionHandler',
	#superclass : 'AbstractSessionHandler',
	#instVars : [
		'registeredClassName',
		'startUpSelector',
		'shutDownSelector'
	],
	#category : 'Tactical-Pharo-StartUp-ShutDown',
	#package : 'Tactical-Pharo',
	#tag : 'StartUp-ShutDown'
}

{ #category : 'instance creation' }
TTMessageSessionHandler class >> forClassNamed: aClassName [
	^ self new
		registeredClassName: aClassName;
		yourself
]

{ #category : 'accessing' }
TTMessageSessionHandler >> handledId [
	^ registeredClassName,'>>', startUpSelector
]

{ #category : 'handlers' }
TTMessageSessionHandler >> registeredClass [
	^ Hub getClass: registeredClassName
]

{ #category : 'accessing' }
TTMessageSessionHandler >> registeredClassName: aClassName [
	registeredClassName := aClassName
]

{ #category : 'accessing' }
TTMessageSessionHandler >> shutDownSelector [
	^ shutDownSelector
]

{ #category : 'accessing' }
TTMessageSessionHandler >> shutDownSelector: anObject [
	shutDownSelector := anObject
]

{ #category : 'handlers' }
TTMessageSessionHandler >> shutdown: isImageQuitting [
	self registeredClass perform: shutDownSelector with: isImageQuitting
]

{ #category : 'accessing' }
TTMessageSessionHandler >> startUpSelector [
	^ startUpSelector
]

{ #category : 'accessing' }
TTMessageSessionHandler >> startUpSelector: anObject [
	startUpSelector := anObject
]

{ #category : 'handlers' }
TTMessageSessionHandler >> startup: isImageStarting [
	self registeredClass perform: startUpSelector with: isImageStarting
]
