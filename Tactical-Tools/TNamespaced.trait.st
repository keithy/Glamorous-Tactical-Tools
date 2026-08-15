Trait {
	#name : 'TNamespaced',
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'namespace' }
TNamespaced classSide >> isNamespaced [
    ^ true
]

{ #category : 'namespace' }
TNamespaced classSide >> ttFullName [
    ^ self name
]

{ #category : 'namespace' }
TNamespaced classSide >> ttLocalName [
    ^ (self name copyFrom: self ttPrefixSize + 1 to: self name size) asSymbol
]

{ #category : 'namespace' }
TNamespaced classSide >> ttNamespace [
    ^ (self name copyFrom: 1 to: self ttPrefixSize) asSymbol
]

{ #category : 'namespace' }
TNamespaced classSide >> ttPrefixSize [
    ^ self name indexOf: $ˆ
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
