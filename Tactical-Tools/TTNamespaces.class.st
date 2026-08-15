Class {
	#name : 'TTNamespaces',
	#superclass : 'Object',
	#classVars : [
		'Registry'
	],
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'accessing' }
TTNamespaces class >> allNamespaces [ 
      ^ ((TheHub allClasses
          select: [ :c | c askFor: #isNamespaced ] thenCollect: [ :n | n ttNamespace ]) 
          
          asSet asSortedCollection: [:a :b | a size >= b size ]) asArray.

]

{ #category : 'accessing' }
TTNamespaces class >> allNamespacesRegistry [

	| namespaces registry |
	
	namespaces := self allNamespaces .
	registry :=  Dictionary new.
	
  TheHub allClasses collect: [ :c | 
     
     	| namespace |
     	
     	namespace := self namespaceFor: c name.
     	
     	namespace ifNotNil: [ :ns |
     			(registry at: ns ifAbsentPut: IdentityDictionary new) at: c name put: c.
       ]
  	].
          
   ^ registry 

]

{ #category : 'accessing' }
TTNamespaces class >> namespaceFor: aClassName [

	
	
	^ self registry detect: [ :ns | 
	
			(aClassName beginsWith: ns) ifTrue: [ 
		
						(aClassName at: (ns size + 1)) isLowercase ifTrue: [ ^ nil ].
			
			true
		] 
		ifFalse: false
		
	] ifNone: [ ^ nil ].
	
	 
 
]

{ #category : 'accessing' }
TTNamespaces class >> registry [

	 ^ Registry ifNil: [ Registry := self allNamespaces ]
]

{ #category : 'accessing' }
TTNamespaces class >> shutDown [
	
	<ttShutDown>
	
	Registry := nil
]

{ #category : 'accessing' }
TTNamespaces class >> ttPrefixOf: aClassName [
	
 ^ aClassName copyFrom: 1 to: (self ttPrefixSize: aClassName)
	
]

{ #category : 'accessing' }
TTNamespaces class >> ttPrefixSize: aClassName [
	
	| size |
	aClassName ifNil: [ ^ 0 ].
	
	size := aClassName size.
	3 to:  aClassName size do: [ :n | 
		((aClassName at: n) isUppercase or: [ (aClassName at: n) isDigit ]) 
			ifFalse: [ 
				 (n = size) ifTrue: [ ^ 0 ].
			   n = 3 ifTrue: [ ^ 0 ].
			   ^ n - 2 
			]
								
		].
	
	^ 0
	
]
