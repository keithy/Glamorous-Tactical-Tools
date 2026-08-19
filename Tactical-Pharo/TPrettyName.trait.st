Trait {
	#name : 'TPrettyName',
	#category : 'Tactical-Pharo-Namespaces',
	#package : 'Tactical-Pharo',
	#tag : 'Namespaces'
}

{ #category : 'namespace' }
TPrettyName >> printOn: aStream [
	aStream nextPutAll: 'a '.
	(#namespaced: //self class) value printOn: aStream
]
