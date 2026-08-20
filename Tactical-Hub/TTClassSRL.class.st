Class {
	#name : 'TTClassSRL',
	#superclass : 'Object',
	#instVars : [
		'theClass',
		'theHub',
		'theScheme'
	],
	#category : 'Tactical-Hub-Browser',
	#package : 'Tactical-Hub',
	#tag : 'Browser'
}

{ #category : 'accessing' }
TTClassSRL class >> fromHub: aHub clientWithClass: aClassOrSymbol [
	^ self basicNew 
		theHub: aHub;
		theClass: aClassOrSymbol;
		theScheme: #file:
		initialize
]

{ #category : 'usl-schemes' }
TTClassSRL class >> fromHub: aHub fileWithClass: aClassOrSymbol [

	^ (aHub class: aClassOrSymbol) workingDrectory 
]

{ #category : 'accessing' }
TTClassSRL class >> fromHub: aHub httpWithClass: aClassOrSymbol [
	^ self basicNew 
		theHub: aHub;
		theClass: aClassOrSymbol;
		theScheme: #http:
		initialize
]

{ #category : 'accessing' }
TTClassSRL class >> fromHub: aHub httpsWithClass: aClassOrSymbol [
	^ self basicNew 
		theHub: aHub;
		theClass: aClassOrSymbol;
		theScheme: #https:
		initialize
]

{ #category : 'accessing' }
TTClassSRL class >> fromHub: aHub urlWithClass: aClassOrSymbol [
	^ self basicNew 
		theHub: aHub;
		theClass: aClassOrSymbol;
		theScheme: #url:
		initialize
]

{ #category : 'accessing' }
TTClassSRL >> // aThing [

 "we could parse out the scheme here and redirect accordingly"
 
^ self perform: theScheme with: aThing
]

{ #category : 'accessing' }
TTClassSRL >> client: aThing [

^ (theClass newFor: theHub) // aThing
]

{ #category : 'accessing' }
TTClassSRL >> http: aThing [

^ (theClass newFor: theHub) // aThing
]

{ #category : 'accessing' }
TTClassSRL >> https: aThing [

^ (theClass newFor: theHub) // aThing
]

{ #category : 'accessing' }
TTClassSRL >> theClass: aClassOrSymbol [

	theClass := aClassOrSymbol isSymbol 
		ifTrue: [  theHub class: aClassOrSymbol ]
		ifFalse: [ aClassOrSymbol ]
]

{ #category : 'accessing' }
TTClassSRL >> theHub: aHub [
	theHub := aHub
]

{ #category : 'accessing' }
TTClassSRL >> theScheme: anObject [
	theScheme := anObject
]

{ #category : 'accessing' }
TTClassSRL >> url: aThing [

^ (theClass newFor: theHub) // aThing
]
