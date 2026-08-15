Trait {
	#name : 'T2Namespace',
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'namespace' }
T2Namespace classSide >> isNamespaced [
	^ true
]

{ #category : 'namespace' }
T2Namespace classSide >> ttFullName [
	^ self name
]

{ #category : 'namespace' }
T2Namespace classSide >> ttLocalName [
	^ (self name copyFrom: 3 to: self name size) asSymbol
]

{ #category : 'namespace' }
T2Namespace classSide >> ttNamespace [
	^ (self name copyFrom: 1 to: 2) asSymbol
]

{ #category : 'namespace' }
T2Namespace classSide >> ttPrefixSize [
	^ 2
]

{ #category : 'namespace' }
T2Namespace >> isNamespaced [
	^ self class isNamespaced
]

{ #category : 'namespace' }
T2Namespace >> printOn: aStream [
	aStream nextPutAll: 'a '.
	self ttDisplayName printOn: aStream
]

{ #category : 'namespace' }
T2Namespace >> ttDisplayName [
	^ self class ttLocalName
]

{ #category : 'namespace' }
T2Namespace >> ttFullName [
	^ self class ttFullName
]
