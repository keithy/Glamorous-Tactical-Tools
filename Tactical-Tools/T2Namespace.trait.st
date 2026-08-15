Trait {
	#name : 'T2Namespace',
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'as yet unclassified' }
T2Namespace classSide >> isNamespaced [
	^ true
]

{ #category : 'as yet unclassified' }
T2Namespace classSide >> ttFullName [
	^ self name
]

{ #category : 'as yet unclassified' }
T2Namespace classSide >> ttLocalName [
	^ (self name copyFrom: 3 to: self name size) asSymbol
]

{ #category : 'as yet unclassified' }
T2Namespace classSide >> ttNamespace [
	^ (self name copyFrom: 1 to: 2) asSymbol
]

{ #category : 'accessing' }
T2Namespace classSide >> ttPrefixSize [
	^ 2
]

{ #category : 'as yet unclassified' }
T2Namespace >> isNamespaced [
	^ self class isNamespaced
]

{ #category : 'as yet unclassified' }
T2Namespace >> printOn: aStream [
	aStream nextPutAll: 'a '.
	self ttDisplayName printOn: aStream
]

{ #category : 'as yet unclassified' }
T2Namespace >> ttDisplayName [
	^ self class ttLocalName
]

{ #category : 'as yet unclassified' }
T2Namespace >> ttFullName [
	^ self class ttFullName
]
