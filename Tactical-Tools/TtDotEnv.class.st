Class {
	#name : 'TtDotEnv',
	#superclass : 'TtDictionaryProxy',
	#classInstVars : [
		'suffixReaderMap'
	],
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'as yet unclassified' }
TtDotEnv class >> newNamed: aName fromFile: aStreamable [
	
	"The important thing for testing is that the file
	 reference provided can respond to #readStream.
	 
	 Therefore a string can be used to mock file contents, 
	 but cant be used as a path here"
	
		^ self newNamed: aName fromSource: aStreamable 
]

{ #category : 'as yet unclassified' }
TtDotEnv class >> newStringObfuscated: aString [

	^ TtStringObfuscated newFrom: aString
 
]

{ #category : 'as yet unclassified' }
TtDotEnv class >> suffixMapsBuild [

	suffixReaderMap := (OrderedCollection new)
 
			add: ('_CYPHER'   -> #newStringCyphered:  ) ;
			add: ('_ENCODED'  -> #newStringEncoded:   ) ;
			add: ('_API_KEY'  -> #newStringObfuscated:) ;
			add: ('_APIKEY'   -> #newStringObfuscated:) ;
	  	add: ('_PASS'     -> #newStringObfuscated:) ;
	  	add: ('_PASSWORD' -> #newStringObfuscated:) ;
			yourself
		
]

{ #category : 'as yet unclassified' }
TtDotEnv class >> suffixReaderMap [

	suffixReaderMap ifNil: [ self suffixMapsBuild ].
	
	^ suffixReaderMap
 
]

{ #category : 'as yet unclassified' }
TtDotEnv >> at: key putReading: value [

	self class suffixReaderMap do: [ :assoc |
	
		| suffix selector |
		
		suffix := assoc key.
		selector  := assoc value.
		
		(key endsWith: suffix) ifTrue: [ 
		
				"first match wins"
				^ self at: key put: (self class perform: selector with: value)
				
		]
	].
	
	"straight forward fall through"
	self at: key put: value
	
 
]

{ #category : 'as yet unclassified' }
TtDotEnv >> readSource [
	
	self reset.
	self readingFromStream: self source readStream.
	
]

{ #category : 'as yet unclassified' }
TtDotEnv >> readingFromStream: aStream [
	
	[ 
	[ aStream atEnd ] whileFalse: [ 
	
		| line key value |	
		
		line := aStream nextLine readStream.
				
		key := line upTo: $=.
		value := line upToEnd.
		
		(key beginsWith: '#') 
			  ifFalse: [		
  			    value isEmpty ifFalse: [ self at: key putReading: (value trimRight withoutQuoting) ].	
		    ]
	].

	] ensure: [ aStream close ]
			
 
]
