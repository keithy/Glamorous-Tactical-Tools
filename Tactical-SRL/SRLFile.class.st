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
	
	"Prefer #file:// aString"
	
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
	
	"Prefer #file:// #home"
	
	^ self namedLocations at: aSymbol
 
]

{ #category : 'accessing' }
SRLFile class >> isHttpClient [

	^ false
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
SRLFile >> asDictionary [

	^ Dictionary // self 
	
]

{ #category : 'accessing' }
SRLFile >> asResult [

	^ TTResult // self
	
]

{ #category : 'accessing' }
SRLFile >> contents [

	^ self resolve contents
	
]

{ #category : 'accessing' }
SRLFile >> fileReferenceFromTemplate: aTemplate [

	^ aTemplate envSubst: self vault
]

{ #category : 'accessing' }
SRLFile >> gtNamedLocationsFor: aView [
	<gtView>
	^ aView forward
		title: 'Origins';
		priority: 110;
		object: [ self class namedLocations ];
		view: #gtItemsFor:
		
]

{ #category : 'accessing' }
SRLFile >> gtPrintFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Print';
		priority: 110;
		aptitude: BrGlamorousCodeEditorAptitude;
		text: [ self printString asRopedText ];
		actionUpdateButton
]

{ #category : 'accessing' }
SRLFile >> output [
 self error: thisContext.
	^ self  
]

{ #category : 'accessing' }
SRLFile >> outputProvider [

	self resolve.
	
	^ self  
]

{ #category : 'accessing' }
SRLFile >> resolve: aThing [
	"early bound resolution"

	aThing isSymbol ifTrue: [ ^ self class fileReferenceFromSymbol: aThing ].
	
	aThing isTemplate ifTrue: [ ^ self fileReferenceFromTemplate: aThing ].
	
	^ self class fileReferenceFromString: aThing

]

{ #category : 'accessing' }
SRLFile >> responseContents [

	^ resolved contents
	
]

{ #category : 'accessing' }
SRLFile >> responseStatusCode [
  
 ^ resolved exists ifTrue: 0 ifFalse: 1

]

{ #category : 'accessing' }
SRLFile >> stdout [

	^ self resolve contents
]

{ #category : 'accessing' }
SRLFile >> thing: aString [
	thing := ('*${*}*' matches: aString)
			ifTrue: [ StringTemplate newFrom: aString ]
			ifFalse: [ aString ]
]

{ #category : 'accessing' }
SRLFile >> url: aUrl [

^ self / (aUrl withoutPrefix: 'file:///')
   
]
