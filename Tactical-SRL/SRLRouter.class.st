Class {
	#name : 'SRLRouter',
	#superclass : 'Object',
	#instVars : [
		'thing',
		'scheme',
		'resolved'
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
	
	^ nil
 	
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
	"an additional step of indirection, allowing
	 subclasses to override and reroute to another class"

	  	^ self new: aSymbol
]

{ #category : 'as yet unclassified' }
SRLRouter >> / aThing [

	resolved ifNotNil: [ :r | r +/ aThing ].
	
	"initilize unresolved"
	self thing:aThing.

	^ self initialize
]

{ #category : 'as yet unclassified' }
SRLRouter >> // aThing [

	resolved ifNotNil: [ :r | r +// aThing ].
	
	"resolved"
	
	^ (self / aThing) resolve
]

{ #category : 'guzzler-compat' }
SRLRouter >> errorHandler [

	^ [ :err | err pass ] 
]

{ #category : 'guzzler-compat' }
SRLRouter >> execute [

	"If we were an Http Client this is our call to action,
	 we are ready already"
	
]

{ #category : 'accessing' }
SRLRouter >> hub [

	^ Hub current
]

{ #category : 'guzzler-compat' }
SRLRouter >> isHttpClient [

	^ false
]

{ #category : 'as yet unclassified' }
SRLRouter >> resolve [

	^ resolved := self resolve: thing
]

{ #category : 'as yet unclassified' }
SRLRouter >> resolve: aThing [

	^ self subclassResponsibility
		
]

{ #category : 'guzzler-compat' }
SRLRouter >> response [

	"If we were an Http Client this is where we prepare a response,
	we are that response"
	
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
	^ resolved
]

{ #category : 'accessing' }
SRLRouter >> subject: anObject [
	resolved := anObject
]

{ #category : 'accessing' }
SRLRouter >> thing [
	^ thing
]

{ #category : 'accessing' }
SRLRouter >> thing: anObject [
	thing := anObject
]

{ #category : 'guzzler-compat' }
SRLRouter >> url: aUrl [

	self subclassResponsibilty
"^ self / (aUrl readStream upToAll: '://'; upToEnd)"
   
]

{ #category : 'accessing' }
SRLRouter >> vault [

	^ self hub getVault
]
