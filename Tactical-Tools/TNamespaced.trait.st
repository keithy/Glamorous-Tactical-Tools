Trait {
	#name : 'TNamespaced',
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'as yet unclassified' }
TNamespaced classSide >> isNamespaced [
    ^ true
]

{ #category : 'as yet unclassified' }
TNamespaced classSide >> ttFullName [
    ^ self name
]

{ #category : 'as yet unclassified' }
TNamespaced classSide >> ttLocalName [
    ^ (self name copyFrom: self ttPrefixSize + 1 to: self name size) asSymbol
]

{ #category : 'as yet unclassified' }
TNamespaced classSide >> ttNamespace [
    ^ (self name copyFrom: 1 to: self ttPrefixSize) asSymbol
]

{ #category : 'as yet unclassified' }
TNamespaced classSide >> ttPrefixSize [
    ^ self name indexOf: $ˆ
]

{ #category : 'as yet unclassified' }
TNamespaced >> isNamespaced [
    ^ self class isNamespaced
]

{ #category : 'as yet unclassified' }
TNamespaced >> printOn: aStream [
    aStream nextPutAll: 'a '.
    self ttDisplayName printOn: aStream
]

{ #category : 'as yet unclassified' }
TNamespaced >> ttDisplayName [
    ^ self class ttLocalName
]

{ #category : 'as yet unclassified' }
TNamespaced >> ttFullName [
    ^ self class ttFullName
]
