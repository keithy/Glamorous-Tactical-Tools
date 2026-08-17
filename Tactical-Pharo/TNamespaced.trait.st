Trait {
	#name : 'TNamespaced',
	#category : 'Tactical-Pharo-Namespaces',
	#package : 'Tactical-Pharo',
	#tag : 'Namespaces'
}

{ #category : 'namespace' }
TNamespaced classSide >> isNamespaced [
    ^ self ttPrefixSize ~~ 0
]

{ #category : 'namespace' }
TNamespaced classSide >> ttFullName [
    ^ self name
]

{ #category : 'namespace' }
TNamespaced classSide >> ttLocalName [
	| start |
	start := self ttPrefixSize + 2.
	start = 2 ifTrue: [ start := 1 ].

	^ (self name copyFrom: start to: self name size) asSymbol
]

{ #category : 'namespace' }
TNamespaced classSide >> ttNamespace [
    ^ (self name copyFrom: 1 to: self ttPrefixSize) asSymbol
]

{ #category : 'namespace' }
TNamespaced classSide >> ttPrefixSize [
    ^ (self name indexOf: $ˆ)  
]

{ #category : 'namespace' }
TNamespaced classSide >> ttPrettyName [
	^ self ttLocalName splitCamelCase joinUsing: ' '
]

{ #category : 'namespace' }
TNamespaced >> isNamespaced [
    ^ self class isNamespaced
]

{ #category : 'namespace' }
TNamespaced >> printOn: aStream [
    aStream nextPutAll: 'a '.
    self ttDisplayName printOn: aStream
]

{ #category : 'namespace' }
TNamespaced >> ttDisplayName [
    ^ self class ttLocalName
]

{ #category : 'namespace' }
TNamespaced >> ttFullName [
    ^ self class ttFullName
]
