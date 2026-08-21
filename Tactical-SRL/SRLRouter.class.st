Class {
	#name : 'SRLRouter',
	#superclass : 'Object',
	#instVars : [
		'thing',
		'scheme',
		'subject'
	],
	#category : 'Tactical-SRL-Schemes',
	#package : 'Tactical-SRL',
	#tag : 'Schemes'
}

{ #category : 'as yet unclassified' }
SRLRouter class >> canRoute: aSymbol [

	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
SRLRouter class >> fromSymbol: aSymbol [
	"file: // aThing"
	self allSubclassesDo: [ :sc | 
	
		(sc canRoute: aSymbol) ifTrue: [ ^ sc newRoute: aSymbol ]
	
	].
	self error: 'Unknown scheme'
 	
]

{ #category : 'as yet unclassified' }
SRLRouter class >> isNamespaced [

	<namespaced>
	<namespaced:'SRL'>
	^true
]

{ #category : 'as yet unclassified' }
SRLRouter class >> new: aSymbol [
	
 	^ (self basicNew)
 				scheme: aSymbol
]

{ #category : 'as yet unclassified' }
SRLRouter class >> newRoute: aSymbol [
	
 	^ self new: aSymbol
]

{ #category : 'as yet unclassified' }
SRLRouter >> / aThing [

	"initilize unresolved"
	
	thing := aThing.

	^ self initialize
]

{ #category : 'as yet unclassified' }
SRLRouter >> // aThing [

	"resolved"
	
	^ (self / aThing) resolve
]

{ #category : 'accessing' }
SRLRouter >> hub [

	^ Hub current
]

{ #category : 'as yet unclassified' }
SRLRouter >> resolve [

	^ self resolve: thing
]

{ #category : 'as yet unclassified' }
SRLRouter >> resolve: aThing [

	"Univeral Smalltalk Resource Location"
	
	"explicit list enables method drill down"
	scheme == #class: ifTrue: [ ^ Hub class: aThing ].
	scheme == #file: ifTrue: [ ^ Hub file: aThing ].
	scheme == #url: ifTrue: [ ^ Hub url: aThing ].
	scheme == #https: ifTrue: [ ^ Hub https: aThing ].
	scheme == #http: ifTrue: [ ^ Hub http: aThing ].
	scheme == #client: ifTrue: [ ^ Hub client: aThing ].

	^ Hub  perform: scheme with: aThing
]

{ #category : 'accessing' }
SRLRouter >> scheme [
	^ scheme
]

{ #category : 'accessing' }
SRLRouter >> scheme: anObject [
	scheme := anObject
]

{ #category : 'accessing' }
SRLRouter >> subject [
	^ subject
]

{ #category : 'accessing' }
SRLRouter >> subject: anObject [
	subject := anObject
]

{ #category : 'accessing' }
SRLRouter >> thing [
	^ thing
]

{ #category : 'accessing' }
SRLRouter >> thing: anObject [
	thing := anObject
]

{ #category : 'accessing' }
SRLRouter >> vault [

	^ self hub getVault
]
