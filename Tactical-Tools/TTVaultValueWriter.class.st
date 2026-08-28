Class {
	#name : 'TTVaultValueWriter',
	#superclass : 'Object',
	#classInstVars : [
		'suffixMap'
	],
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'as yet unclassified' }
TTVaultValueWriter class >> reset [ 

	suffixMap := nil.
]

{ #category : 'as yet unclassified' }
TTVaultValueWriter class >> shutDownAtSystemPriority: quitting [

  <ttShutDown>

  self reset
]

{ #category : 'as yet unclassified' }
TTVaultValueWriter class >> suffixMap [
	^ suffixMap
		ifNil: [ suffixMap := self selectors
					select: [ :ea | ea beginsWith: 'valueAs_' ]
					thenCollect: [ :ea | ea -> (ea copyFrom: 8 to: ea size - 1) ] ]
]

{ #category : 'accessing' }
TTVaultValueWriter >> dict: theDict at: aKeyWithSuffix write: aValue [
	| selector newKey map |
	map := self class suffixMap
			detect: [ :ea | aKeyWithSuffix endsWith: ea value ]
			ifNone: [ #valueAsSame: -> 'x' ].

	selector := map key.
	newKey := map value last = $_
			ifTrue: [ aKeyWithSuffix withoutSuffix: map value ]
			ifFalse: [ aKeyWithSuffix ].

	^ theDict at: newKey put: (self perform: selector with: aValue)
]

{ #category : 'accessing' }
TTVaultValueWriter >> suffixFor: aKey [
	^ self class suffixMap detect: [ :suffix | aKey endsWith: suffix ] ifNone: ''
]

{ #category : 'as yet unclassified' }
TTVaultValueWriter >> valueAsBase64: aString [

	^ (TTStringEncoded newFrom: aString) beBase64
 
]

{ #category : 'as yet unclassified' }
TTVaultValueWriter >> valueAsCyphered: aString [
	
	^ (TTStringEncoded newFrom: aString) beCyphered
 
]

{ #category : 'as yet unclassified' }
TTVaultValueWriter >> valueAsObfuscated: aString [

	^ TTStringObfuscated newFrom: aString
 
]

{ #category : 'as yet unclassified' }
TTVaultValueWriter >> valueAsSame: aString [

	('*${*}*' matches: aString) ifTrue: [ ^ self valueAsTemplate: aString ].
	
	^ aString
 
]

{ #category : 'as yet unclassified' }
TTVaultValueWriter >> valueAsString: aString [

	^ aString
]

{ #category : 'as yet unclassified' }
TTVaultValueWriter >> valueAsTemplate: aString [
	
	^ StringTemplate newFrom: aString 
]

{ #category : 'as yet unclassified' }
TTVaultValueWriter >> valueAs_APIKEY: aString [
	^ self valueAsObfuscated: aString
]

{ #category : 'as yet unclassified' }
TTVaultValueWriter >> valueAs_API_KEY: aString [
	^ self valueAsObfuscated: aString
]

{ #category : 'as yet unclassified' }
TTVaultValueWriter >> valueAs_BASE64_: aString [

	^ self valueAsBase64: aString
 
]

{ #category : 'as yet unclassified' }
TTVaultValueWriter >> valueAs_CYPHER_: aString [
	^ self valueAsCyphered: aString
]

{ #category : 'as yet unclassified' }
TTVaultValueWriter >> valueAs_ENCODED_: aString [

	^ self valueAsBase64: aString
 
]

{ #category : 'as yet unclassified' }
TTVaultValueWriter >> valueAs_OBFUSCATE_: aString [
	^ self valueAsObfuscated: aString
]

{ #category : 'as yet unclassified' }
TTVaultValueWriter >> valueAs_PASS: aString [
	^ self valueAsObfuscated: aString
]

{ #category : 'as yet unclassified' }
TTVaultValueWriter >> valueAs_PASSWORD: aString [
	^ self valueAsObfuscated: aString
]
