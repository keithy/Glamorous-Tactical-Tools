Trait {
	#name : 'T3Namespace',
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'as yet unclassified' }
T3Namespace classSide >> isNamespaced [
	^ true
]

{ #category : 'as yet unclassified' }
T3Namespace classSide >> ttFullName [
	^ self name
]

{ #category : 'as yet unclassified' }
T3Namespace classSide >> ttLocalName [
	^ (self name copyFrom: 4 to: self name size) asSymbol
]

{ #category : 'as yet unclassified' }
T3Namespace classSide >> ttNamespace [
	^ (self name copyFrom: 1 to: 3) asSymbol
]

{ #category : 'as yet unclassified' }
T3Namespace classSide >> ttPrefixSize [
	^ 3
]

{ #category : 'as yet unclassified' }
T3Namespace >> isNamespaced [
	^ self class isNamespaced
]

{ #category : 'as yet unclassified' }
T3Namespace >> printOn: aStream [
	aStream nextPutAll: 'a '.
	self ttDisplayName printOn: aStream
]

{ #category : 'as yet unclassified' }
T3Namespace >> ttDisplayName [
	^ self class ttLocalName
]

{ #category : 'as yet unclassified' }
T3Namespace >> ttFullName [
	^ self class ttFullName
]
