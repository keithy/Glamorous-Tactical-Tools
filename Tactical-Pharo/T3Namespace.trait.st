Trait {
	#name : 'T3Namespace',
	#category : 'Tactical-Pharo-Namespaces',
	#package : 'Tactical-Pharo',
	#tag : 'Namespaces'
}

{ #category : 'namespace' }
T3Namespace classSide >> isNamespaced [
	<nsSize:#hint3:>
	^ true
]

{ #category : 'namespace' }
T3Namespace >> printOn: aStream [
	aStream nextPutAll: 'a '.
	(#namespaced: //self class) value printOn: aStream
]
