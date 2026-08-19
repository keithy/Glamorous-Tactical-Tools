Trait {
	#name : 'T2Namespace',
	#category : 'Tactical-Pharo-Namespaces',
	#package : 'Tactical-Pharo',
	#tag : 'Namespaces'
}

{ #category : 'namespace' }
T2Namespace classSide >> isNamespaced [
	<nsSize:#hint2:>
	^ true
]

{ #category : 'namespace' }
T2Namespace >> printOn: aStream [
	aStream nextPutAll: 'a '.
	(#namespaced: //self class) value printOn: aStream
]
