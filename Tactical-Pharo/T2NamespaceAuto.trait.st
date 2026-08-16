Trait {
	#name : 'T2NamespaceAuto',
	#category : 'Tactical-Pharo-Namespaces',
	#package : 'Tactical-Pharo',
	#tag : 'Namespaces'
}

{ #category : 'namespace' }
T2NamespaceAuto classSide >> isNamespaced [
	^ true
]

{ #category : 'namespace' }
T2NamespaceAuto classSide >> ttFullName [
	^ self name
]

{ #category : 'namespace' }
T2NamespaceAuto classSide >> ttLocalName [
	^ (self name copyFrom: 3 to: self name size) asSymbol
]

{ #category : 'namespace' }
T2NamespaceAuto classSide >> ttNamespace [
	^ (self name copyFrom: 1 to: 2) asSymbol
]

{ #category : 'namespace' }
T2NamespaceAuto classSide >> ttPrefixSize [
	
	^ self ttPrefixSize: self name
	
]

{ #category : 'namespace' }
T2NamespaceAuto classSide >> ttPrefixSize: aClassName [
	
	aClassName ifNil: [ ^ 0 ].
	
	3 to:  aClassName size do: [ :n | 
		((aClassName at: n) isUppercase or: [ (aClassName at: n) isDigit ]) ifFalse: [ ^ n - 2 ]
								
		].
	
	^ 0
	
]

{ #category : 'namespace' }
T2NamespaceAuto >> isNamespaced [
	^ self class isNamespaced
]

{ #category : 'namespace' }
T2NamespaceAuto >> printOn: aStream [
	aStream nextPutAll: 'a '.
	self ttDisplayName printOn: aStream
]

{ #category : 'namespace' }
T2NamespaceAuto >> ttDisplayName [
	^ self class ttLocalName
]

{ #category : 'namespace' }
T2NamespaceAuto >> ttFullName [
	^ self class ttFullName
]
