Trait {
	#name : 'T2NamespaceAuto',
	#category : 'Tactical-Pharo-Namespaces',
	#package : 'Tactical-Pharo',
	#tag : 'Namespaces'
}

{ #category : 'namespace' }
T2NamespaceAuto classSide >> isNamespaced [
  <namespaced:#splitAutomatically:>
  
	^ true
]

{ #category : 'namespace' }
T2NamespaceAuto >> printOn: aStream [
	aStream nextPutAll: 'a '.
	(#namespaced: //self class) value printOn: aStream
]
