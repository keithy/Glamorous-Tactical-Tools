Class {
	#name : 'TTDictionaryDotEnv',
	#superclass : 'TTDictionaryProxy',
	#classInstVars : [
		'suffixReaderMap'
	],
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'as yet unclassified' }
TTDictionaryDotEnv class >> newStringEncoded: aString [

	^ (TTStringEncoded newFrom: aString) beBase64
 
]

{ #category : 'as yet unclassified' }
TTDictionaryDotEnv class >> newStringObfuscated: aString [

	^ TTStringObfuscated newFrom: aString
 
]

{ #category : 'as yet unclassified' }
TTDictionaryDotEnv class >> newTest [

	<gtExample>
	<return: #TTDictionaryDotEnv>
	| store |
	
	store := self newWithTierKey: #test.
	store readSource: 

	'HELLO=WORLD
	HELLO1=WORLD1
	HELLO2_PASS="WORLD2" 
	HELLO3_ENCODED="V09STEQz"'.
	
	^ store
	 
]

{ #category : 'as yet unclassified' }
TTDictionaryDotEnv class >> suffixMapsBuild [

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
TTDictionaryDotEnv class >> suffixReaderMap [

	suffixReaderMap ifNil: [ self suffixMapsBuild ].
	
	^ suffixReaderMap
 
]

{ #category : 'as yet unclassified' }
TTDictionaryDotEnv >> at: key putReading: value [

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
TTDictionaryDotEnv >> readSource [
	
	self reset.
	self readingFromStream: self source readStream.
	
]

{ #category : 'as yet unclassified' }
TTDictionaryDotEnv >> readingFromStream: aStream [
	
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
