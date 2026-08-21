Class {
	#name : 'SRLFile',
	#superclass : 'SRLRouter',
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
	
	^ #file:/  #home 
]

{ #category : 'accessing' }
SRLFile class >> examplesResolved [

	<gtExample>
	
	^ { self exampleHome. self exampleEnvVar. self exampleNamedLocation } collect: #resolve
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
SRLFile >> fileReferenceFromString: aString [

	^ self class fileReferenceFromString: (aString templateResolveUsing: self vault)
]

{ #category : 'accessing' }
SRLFile >> printOn: str [

	(subject ifNil: [ thing ]) printOn: str

]

{ #category : 'accessing' }
SRLFile >> resolve: aThing [
	"early bound resolution"

	aThing isSymbol
		ifTrue: [ subject := self class fileReferenceFromSymbol: aThing ]
		ifFalse: [ subject := self fileReferenceFromString: aThing ].

	^ subject
]
