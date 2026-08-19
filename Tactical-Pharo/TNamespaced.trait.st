Trait {
	#name : 'TNamespaced',
	#category : 'Tactical-Pharo-Namespaces',
	#package : 'Tactical-Pharo',
	#tag : 'Namespaces'
}

{ #category : 'namespace' }
TNamespaced classSide >> isNamespaced [
	<nsSize: #hintCircumflex:>
	^ true
]

{ #category : 'namespace' }
TNamespaced >> printOn: aStream [
	aStream nextPutAll: 'a '.
	(#namespaced: //self class) value printOn: aStream
]
