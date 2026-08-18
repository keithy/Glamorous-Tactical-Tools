Class {
	#name : 'TTFileResourceLocator',
	#superclass : 'Object',
	#instVars : [
		'givenSymbolClassOrString'
	],
	#classVars : [
		'NamedLocations',
		'Regex'
	],
	#category : 'Tactical-Hub-Browser',
	#package : 'Tactical-Hub',
	#tag : 'Browser'
}

{ #category : 'accessing' }
TTFileResourceLocator class >> fileReferenceFromString: aString [
	
	<ttWall>
	
	"Prefer #file: // aString"
	
	| regex dirName path |
	regex := Regex copy.

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
TTFileResourceLocator class >> namedLocations [

	^ NamedLocations ifNil: [ NamedLocations := FileLocator  namedFileLocations ]
]

{ #category : 'accessing' }
TTFileResourceLocator class >> newStart: aSymbolClassOrString [
	^ self basicNew
		start: aSymbolClassOrString;
		yourself
]

{ #category : 'accessing' }
TTFileResourceLocator class >> reset [

	  NamedLocations := nil.
	  Regex := '\{([a-zA-Z]+)\}(.*)' asRegex.
	
]

{ #category : 'accessing' }
TTFileResourceLocator class >> startUpAtSystemPriority: isImageStarting [
	<ttStartUp>
	self reset
]

{ #category : 'accessing' }
TTFileResourceLocator >> isClass [

	^ givenSymbolClassOrString isClass
]

{ #category : 'accessing' }
TTFileResourceLocator >> isSymbol [

	^ givenSymbolClassOrString isSymbol
]

{ #category : 'accessing' }
TTFileResourceLocator >> next [
	self isSymbol
		ifTrue: [ self class namedLocations
				at: givenSymbolClassOrString
				ifPresent: [ :locator | ^ locator resolve ] ].	
				
	self isString
		ifTrue: [ ^ self class fileReferenceFromString: givenSymbolClassOrString ]
		
	"self isClass ifTrue:  [
	
		givenSymbolClassOrString := givenSymbolClassOrString asFile

	]
	
	we sit here and wait for what is next"
	
]

{ #category : 'accessing' }
TTFileResourceLocator >> start [
	^ givenSymbolClassOrString
]

{ #category : 'accessing' }
TTFileResourceLocator >> start: anObject [
	givenSymbolClassOrString := anObject
]
