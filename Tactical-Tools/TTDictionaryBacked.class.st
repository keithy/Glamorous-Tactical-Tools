Class {
	#name : 'TTDictionaryBacked',
	#superclass : 'Dictionary',
	#instVars : [
		'source',
		'valueWriter',
		'lastReadTime'
	],
	#classInstVars : [
		'suffixReaderMap'
	],
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'accessing' }
TTDictionaryBacked >> at: key write: value [

	^ valueWriter 
					ifNil: [ self at: key put: value ]
					ifNotNil: [ valueWriter dict: self at: key write: value ]
]

{ #category : 'accessing' }
TTDictionaryBacked >> initialize [

	"instance creation via new this initializes the empty dictionary using #initialize:"
	
	tally ifNil: [ self error: 'For instance creation use #new not basicNew' ].
	
	"assumes is fully setup, i.e. setValueWriter: and setSource:"

	super initialize.
	 

 
	
	
]

{ #category : 'accessing' }
TTDictionaryBacked >> initializeReadingConfig: config [

  self readSourceTooSoon ifTrue: [ ^ self ].
	self readSource.
	
	 
	
]

{ #category : 'accessing' }
TTDictionaryBacked >> isBacked [

	^ true
]

{ #category : 'accessing' }
TTDictionaryBacked >> isReadOnly [

	^ true
]

{ #category : 'accessing' }
TTDictionaryBacked >> readSource [

	^ self subclassResponsibility

]

{ #category : 'accessing' }
TTDictionaryBacked >> readSourceTooSoon [

	"protects shared instances from being pounded"

	| now |
	
	now := DateAndTime now.
	lastReadTime ifNotNil: [  now - lastReadTime < 10 seconds ifTrue: [ ^ true ] ].
  lastReadTime := now.
	
	^ false
	 
	
]

{ #category : 'accessing' }
TTDictionaryBacked >> setSource: aSource [
	
	"set implies initialization, pre-initialize"
	
	"We empty our data here, to avoid confusion and clearly demonstrate
	that we have not been read yet"

	self removeAll. 
	source := aSource.
	 
]

{ #category : 'accessing' }
TTDictionaryBacked >> setValueWriter: anObject [
  
	valueWriter := anObject
]

{ #category : 'accessing' }
TTDictionaryBacked >> source [
	^ source
]

{ #category : 'accessing' }
TTDictionaryBacked >> source: aSource [
	
	"For initialization use setSource: , use this to dynamically change source"
	self setSource: aSource.
	self readSource.
]

{ #category : 'accessing' }
TTDictionaryBacked >> valueWriter [
	
	"do not lazy initialize, we require our caller to set us
	 up correctly for the context"
	 
	^ valueWriter  
]
