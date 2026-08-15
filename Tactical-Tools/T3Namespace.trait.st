Trait {
	#name : 'T3Namespace',
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'namespace' }
T3Namespace classSide >> isNamespaced [
	^ true
]

{ #category : 'namespace' }
T3Namespace classSide >> ttFullName [
	^ self name
]

{ #category : 'namespace' }
T3Namespace classSide >> ttLocalName [
	^ (self name copyFrom: 4 to: self name size) asSymbol
]

{ #category : 'namespace' }
T3Namespace classSide >> ttNamespace [
	^ (self name copyFrom: 1 to: 3) asSymbol
]

{ #category : 'namespace' }
T3Namespace classSide >> ttPrefixSize [
	^ 3
]

{ #category : 'namespace' }
T3Namespace >> isNamespaced [
	^ self class isNamespaced
]

{ #category : 'namespace' }
T3Namespace >> printOn: aStream [
	aStream nextPutAll: 'a '.
	self ttDisplayName printOn: aStream
]

{ #category : 'namespace' }
T3Namespace >> ttDisplayName [
	^ self class ttLocalName
]

{ #category : 'namespace' }
T3Namespace >> ttFullName [
	^ self class ttFullName
]
