Class {
	#name : 'TTHoldem',
	#superclass : 'Object',
	#instVars : [
		'givenSymbolClassOrString'
	],
	#classVars : [
		'NamedLocations',
		'Regex'
	],
	#category : 'Tactical-SRL-Misc',
	#package : 'Tactical-SRL',
	#tag : 'Misc'
}

{ #category : 'accessing' }
TTHoldem class >> fileReferenceFromString: aString [
	
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
TTHoldem class >> namedLocations [

	^ NamedLocations ifNil: [ NamedLocations := FileLocator  namedFileLocations ]
]

{ #category : 'accessing' }
TTHoldem class >> newStart: aSymbolClassOrString [
	^ self basicNew
		start: aSymbolClassOrString;
		yourself
]

{ #category : 'accessing' }
TTHoldem class >> reset [

	  NamedLocations := nil.
	  Regex := '\{([a-zA-Z]+)\}(.*)' asRegex.
	
]

{ #category : 'accessing' }
TTHoldem class >> startUpAtSystemPriority: isImageStarting [
	<ttStartUp>
	self reset
]

{ #category : 'accessing' }
TTHoldem >> / aThing [ 
]

{ #category : 'accessing' }
TTHoldem >> // anotherThing [ 
]

{ #category : 'accessing' }
TTHoldem >> applySlashTo: aClass [

self isSymbol ifTrue: [ ^ aClass new perform: givenSymbolClassOrString ]
]

{ #category : 'accessing' }
TTHoldem >> isClass [

	^ givenSymbolClassOrString isClass
]

{ #category : 'accessing' }
TTHoldem >> isSymbol [

	^ givenSymbolClassOrString isSymbol
]

{ #category : 'accessing' }
TTHoldem >> next [
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
TTHoldem >> start [
	^ givenSymbolClassOrString
]

{ #category : 'accessing' }
TTHoldem >> start: anObject [
	givenSymbolClassOrString := anObject
]
