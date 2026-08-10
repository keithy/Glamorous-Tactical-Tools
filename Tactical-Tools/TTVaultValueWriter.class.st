Class {
	#name : 'TTVaultValueWriter',
	#superclass : 'Object',
	#classInstVars : [
		'suffixReaderMap'
	],
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'as yet unclassified' }
TTVaultValueWriter class >> suffixMapsBuild [

	suffixReaderMap := (OrderedCollection new)
 
			add: ('_CYPHER'   -> #valueAsCyphered:  ) ;
			add: ('_ENCODED'  -> #valueAsEncoded:   ) ;
			add: ('_BASE64'   -> #valueAsEncoded:   ) ;
			add: ('_API_KEY'  -> #valueAsObfuscated:) ;
			add: ('_APIKEY'   -> #valueAsObfuscated:) ;
	  	add: ('_PASS'     -> #valueAsObfuscated:) ;
	  	add: ('_PASSWORD' -> #valueAsObfuscated:) ;
			yourself
		
]

{ #category : 'as yet unclassified' }
TTVaultValueWriter class >> suffixReaderMap [

	<gtExample>
	
	suffixReaderMap ifNil: [ self suffixMapsBuild ].
	
	^ suffixReaderMap
 
]

{ #category : 'as yet unclassified' }
TTVaultValueWriter class >> suffixesToRemove [

	^ #('_CYPHER' '_ENCODED' '_BASE64') 
			yourself
		
]

{ #category : 'accessing' }
TTVaultValueWriter >> dict: dictionary at: key write: value [
 
	self class suffixReaderMap do: [ :assoc |
	
		| suffix selector newKey |
		
		suffix := assoc key.
		selector  := assoc value.
		
		(key endsWith: suffix) ifTrue: [ 
		
				newKey := (self class suffixesToRemove includes: suffix)
					ifTrue: [ key withoutSuffix: suffix ] ifFalse: [ key ].
		
				"first match wins"
				^ dictionary at: newKey put: (self perform: selector with: value)
				
		]
	].
	
	"straight forward fall through"
	^ dictionary at: key put: value.

]

{ #category : 'as yet unclassified' }
TTVaultValueWriter >> valueAsCyphered: aString [

	self notYetImplemented.
	
	^ (TTStringEncoded newFrom: aString) beBase64
 
]

{ #category : 'as yet unclassified' }
TTVaultValueWriter >> valueAsEncoded: aString [

	^ (TTStringEncoded newFrom: aString) beBase64
 
]

{ #category : 'as yet unclassified' }
TTVaultValueWriter >> valueAsObfuscated: aString [

	^ TTStringObfuscated newFrom: aString
 
]

{ #category : 'as yet unclassified' }
TTVaultValueWriter >> valueAsString: aString [

	^ aString
]
