Class {
	#name : 'TTVaultValueWriter',
	#superclass : 'Object',
	#instVars : [
		'dict'
	],
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

	^ #('_CYPHER' '_ENCODED') 
			yourself
		
]

{ #category : 'accessing' }
TTVaultValueWriter >> at: key put: value [
 
	^ dict at: key put: value.

]

{ #category : 'accessing' }
TTVaultValueWriter >> dict [
	^ dict
]

{ #category : 'accessing' }
TTVaultValueWriter >> dict: anObject [
	dict := anObject
]

{ #category : 'accessing' }
TTVaultValueWriter >> fromAnyAt: key put: value [
 
	self class suffixReaderMap do: [ :assoc |
	
		| suffix selector newKey |
		
		suffix := assoc key.
		selector  := assoc value.
		
		(key endsWith: suffix) ifTrue: [ 
		
				newKey := (self class suffixesToRemove includes: suffix)
					ifTrue: [ key withoutSuffix: suffix ] ifFalse: [ key ].
		
				"first match wins"
				^ self at: newKey put: (self perform: selector with: value)
				
		]
	].
	
	"straight forward fall through"
	^ self at: key put: value.

]

{ #category : 'accessing' }
TTVaultValueWriter >> fromDotEnvAt: key put: value [
	^ self fromAnyAt: key put: value
]

{ #category : 'accessing' }
TTVaultValueWriter >> fromMiseAt: key put: data [
	^ self fromDotEnvAt: key put: (data at: #value)
]

{ #category : 'accessing' }
TTVaultValueWriter >> fromProxyAt: key put: value [
	^ self fromAnyAt: value put: key
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
