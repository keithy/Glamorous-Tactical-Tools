Class {
	#name : 'SRLFile',
	#superclass : 'SRLRouter',
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
	#category : 'Tactical-SRL-Schemes',
	#package : 'Tactical-SRL',
	#tag : 'Schemes'
}

{ #category : 'accessing' }
SRLFile class >> canRoute: aSymbol [

	^ aSymbol == #file:

]

{ #category : 'accessing' }
SRLFile class >> exampleEnvVar [

	<gtExample>
	
	^ #file:/ '{home}/.config/${NICKNAME}.env'
]

{ #category : 'accessing' }
SRLFile class >> exampleHome [

	<gtExample>
	
	^ #file:/ '{home}/.config'
]

{ #category : 'accessing' }
SRLFile class >> exampleNamedLocation [

	<gtExample>
	
	^ #file:/  #home / '.config' 
]

{ #category : 'accessing' }
SRLFile class >> fileReferenceFromString: aString [
	
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
SRLFile class >> fileReferenceFromSymbol: aSymbol [
	
	<ttWall>
	
	^ self namedLocations at: aSymbol
 
]

{ #category : 'usl-schemes' }
SRLFile class >> fromHub: aHub fileWith: aThing [ 

 	aThing isClass
			ifTrue: [ ^ self fromHub: aHub fileWithClass: aThing ].
		
	 aThing isSymbol
			ifTrue: [ ^ self fromHub: aHub fileWithSymbol: aThing ].
				
	 aThing isString
			ifTrue: [ ^ self fromHub: aHub fileWithString: aThing ].
				
	^ self error: 'other?'
]

{ #category : 'accessing' }
SRLFile class >> fromHub: aHub fileWithClass: aClass [
	^ self basicNew
		theHub: aHub;
		theClass: aClass;
		initialize	 
]

{ #category : 'accessing' }
SRLFile class >> fromHub: aHub fileWithString: aString [
	^ self basicNew
		theHub: aHub;
		theTemplate: (TTStringTemplate newFrom: aString);
		initialize
]

{ #category : 'accessing' }
SRLFile class >> fromHub: aHub fileWithSymbol: aSymbol [
	^ self basicNew
		theHub: aHub;
		setFileReference: (self fileReferenceFromSymbol: aSymbol);
		initialize	"theScheme: #file"
]

{ #category : 'accessing' }
SRLFile class >> namedLocations [

	^ NamedLocations ifNil: [ NamedLocations := FileLocator  namedFileLocations ]
]

{ #category : 'accessing' }
SRLFile class >> reset [

	  NamedLocations := nil.
	  OriginRegex := '\{([a-zA-Z]+)\}(.*)' asRegex.
	
]

{ #category : 'accessing' }
SRLFile class >> startUpAtSystemPriority: isImageStarting [
	<ttStartUp>
	self reset
]

{ #category : 'accessing' }
SRLFile >> asFileReference [
	 
	 ^ fileReference ifNil: [ self class fileReferenceFromString: (theTemplate templateResolveUsing: theHub getVault) ]

]

{ #category : 'accessing' }
SRLFile >> fileReference: anObject [
	fileReference := anObject
]

{ #category : 'accessing' }
SRLFile >> printOn: str [

	self asFileReference printOn: str

]

{ #category : 'accessing' }
SRLFile >> resolve [
	
	"early bound resolution"

	^ fileReference ifNil: [ fileReference := self asFileReference ]
 
]

{ #category : 'accessing' }
SRLFile >> setFileReference: anObject [
	fileReference := anObject
]

{ #category : 'accessing' }
SRLFile >> theHub: aHub [
	theHub := aHub
]

{ #category : 'accessing' }
SRLFile >> theTemplate: aTemplateOrString [ 
	theTemplate := aTemplateOrString
]
