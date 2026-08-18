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
	^ (self isNamespaced
		ifTrue: [ self name copyFrom: self ttPrefixSize + 1 to: self name size ]
		ifFalse: [ self name withoutPrefix: (self askFor: #ttNamespaceDefault ifAbsent: '') ])
		asSymbol
]

{ #category : 'namespace' }
TNamespaced classSide >> ttNamespace [
    ^ (self isNamespaced
     	ifTrue: [ self name copyFrom: 1 to: (self ttPrefixSize - 1) ]
     	ifFalse: [ self askFor: #ttNamespaceDefault ifAbsent: '' ]) asSymbol
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
