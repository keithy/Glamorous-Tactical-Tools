Class {
	#name : 'TTFileSRL',
	#superclass : 'Object',
	#instVars : [
		'fileReference',
		'theHub',
		'theTemplate',
		'theClass'
	],
	#classVars : [
		'NamedLocations',
		'OriginRegex'
	],
	#category : 'Tactical-Hub-Browser',
	#package : 'Tactical-Hub',
	#tag : 'Browser'
}

{ #category : 'accessing' }
TTFileSRL class >> exampleEnvVar [

	<gtExample>
	
	^ #fileSRL:// '{home}/.config/${NICKNAME}.env'
]

{ #category : 'accessing' }
TTFileSRL class >> exampleHome [

	<gtExample>
	
	^ #file:// '{home}/.config'
]

{ #category : 'accessing' }
TTFileSRL class >> exampleNamedLocation [

	<gtExample>
	
	^ #file://  #home / '.config' 
]

{ #category : 'accessing' }
TTFileSRL class >> fileReferenceFromString: aString [
	
	<ttWall>
	
	"Prefer #file: // aString"
	
	| regex dirName path |
	regex := OriginRegex copy.

	(regex matches: aString) ifFalse: [ ^ aString asFileReference ].

	dirName := regex subexpression: 2.
	path := regex subexpression: 3.

	self namedLocations
		at: dirName
		ifPresent: [ :locator | 
			^ path
				ifEmpty: [ locator resolve ]
				ifNotEmpty: [ locator resolve resolve: path allButFirst ] ]
		ifAbsent: [ self error: 'Unknown directory: ' , dirName printString ]
]

{ #category : 'accessing' }
TTFileSRL class >> fileReferenceFromSymbol: aSymbol [
	
	<ttWall>
	
	^ self namedLocations at: aSymbol
 
]

{ #category : 'usl-schemes' }
TTFileSRL class >> fromHub: aHub fileWith: aThing [ 

 	aThing isClass
			ifTrue: [ ^ self fromHub: aHub fileWithClass: aThing ].
		
	 aThing isSymbol
			ifTrue: [ ^ self fromHub: aHub fileWithSymbol: aThing ].
				
	 aThing isString
			ifTrue: [ ^ self fromHub: aHub fileWithString: aThing ].
				
	^ self error: 'other?'
]

{ #category : 'accessing' }
TTFileSRL class >> fromHub: aHub fileWithClass: aClass [
	^ self basicNew
		theHub: aHub;
		theClass: aClass;
		initialize	 
]

{ #category : 'accessing' }
TTFileSRL class >> fromHub: aHub fileWithString: aString [
	^ self basicNew
		theHub: aHub;
		theTemplate: (TTStringTemplate newFrom: aString);
		initialize
]

{ #category : 'accessing' }
TTFileSRL class >> fromHub: aHub fileWithSymbol: aSymbol [
	^ self basicNew
		theHub: aHub;
		setFileReference: (self fileReferenceFromSymbol: aSymbol);
		initialize	"theScheme: #file"
]

{ #category : 'accessing' }
TTFileSRL class >> namedLocations [

	^ NamedLocations ifNil: [ NamedLocations := FileLocator  namedFileLocations ]
]

{ #category : 'accessing' }
TTFileSRL class >> reset [

	  NamedLocations := nil.
	  OriginRegex := '\{([a-zA-Z]+)\}(.*)' asRegex.
	
]

{ #category : 'accessing' }
TTFileSRL class >> startUpAtSystemPriority: isImageStarting [
	<ttStartUp>
	self reset
]

{ #category : 'accessing' }
TTFileSRL >> asFileReference [
	 
	self resolve.
	
	^ fileReference
]

{ #category : 'accessing' }
TTFileSRL >> fileReference: anObject [
	fileReference := anObject
]

{ #category : 'accessing' }
TTFileSRL >> resolve [
	"early bound resolution"

	fileReference
		ifNil: [ fileReference := self class
					fileReferenceFromString: (theTemplate templateResolveUsing: theHub getVault) ].
	^ fileReference
]

{ #category : 'accessing' }
TTFileSRL >> setFileReference: anObject [
	fileReference := anObject
]

{ #category : 'accessing' }
TTFileSRL >> theHub: aHub [
	theHub := aHub
]

{ #category : 'accessing' }
TTFileSRL >> theTemplate: aTemplateOrString [ 
	theTemplate := aTemplateOrString
]
