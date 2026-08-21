Class {
	#name : 'SRLOldClassHolder',
	#superclass : 'Object',
	#instVars : [
		'theClass',
		'theHub',
		'theScheme'
	],
	#category : 'Tactical-SRL-Misc',
	#package : 'Tactical-SRL',
	#tag : 'Misc'
}

{ #category : 'accessing' }
SRLOldClassHolder class >> fromHub: aHub clientWithClass: aClassOrSymbol [
	^ self basicNew 
		theHub: aHub;
		theClass: aClassOrSymbol;
		theScheme: #file:
		initialize
]

{ #category : 'usl-schemes' }
SRLOldClassHolder class >> fromHub: aHub fileWithClass: aClassOrSymbol [

	^ (aHub class: aClassOrSymbol) workingDrectory 
]

{ #category : 'accessing' }
SRLOldClassHolder >> // aThing [

 "we could parse out the scheme here and redirect accordingly"
 
^ self perform: theScheme with: aThing
]

{ #category : 'accessing' }
SRLOldClassHolder >> client: aThing [

^ (theClass newFor: theHub) // aThing
]

{ #category : 'accessing' }
SRLOldClassHolder >> http: aThing [

^ (theClass newFor: theHub) // aThing
]

{ #category : 'accessing' }
SRLOldClassHolder >> https: aThing [

^ (theClass newFor: theHub) // aThing
]

{ #category : 'accessing' }
SRLOldClassHolder >> theClass: aClassOrSymbol [

	theClass := aClassOrSymbol isSymbol 
		ifTrue: [  theHub class: aClassOrSymbol ]
		ifFalse: [ aClassOrSymbol ]
]

{ #category : 'accessing' }
SRLOldClassHolder >> theHub: aHub [
	theHub := aHub
]

{ #category : 'accessing' }
SRLOldClassHolder >> theScheme: anObject [
	theScheme := anObject
]

{ #category : 'accessing' }
SRLOldClassHolder >> url: aThing [

^ (theClass newFor: theHub) // aThing
]
