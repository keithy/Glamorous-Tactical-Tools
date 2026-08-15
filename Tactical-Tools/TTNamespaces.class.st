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
      ^ (self traitedNamespaces  , self someNamespaces)
]

{ #category : 'accessing' }
TTNamespaces class >> allNamespacesRegistry [

	| namespaces registry |
	
	namespaces := self allNamespacesSorted .
	registry :=  Dictionary new.
	
  TheHub allIdentifyingAsClasses collect: [ :c | 
     
     	| namespace |
     	
     	namespace := self nameAsAssoc: c name.
     	
     	namespace ifNotNil: [ :ns |
     			(registry at: ns value ifAbsentPut: IdentityDictionary new) 
     			
     			at: (self nameKeyFromAssoc: namespace) put:c
       ]
  	].
          
   ^ registry 

]

{ #category : 'accessing' }
TTNamespaces class >> allNamespacesSorted [
      ^ (self allNamespaces asSortedCollection: [:a :b | a size >= b size ]) asArray.
]

{ #category : 'accessing' }
TTNamespaces class >> name: aClassName after: n [

    ^ aClassName copyFrom: (n + 1) to: aClassName size
	 
 
]

{ #category : 'accessing' }
TTNamespaces class >> name: aClassName before: n [

    ^ aClassName copyFrom:  1 to: n
	 
 
]

{ #category : 'accessing' }
TTNamespaces class >> nameAsAssoc: aClassName [

	| n |
	
	n := (self namespacePrefixSizeFor: aClassName) ifNil: [ ^nil ].
	
  ^ Association  
    		key: (self name: aClassName after: n)
    		value: (self name: aClassName before: n)
 
]

{ #category : 'accessing' }
TTNamespaces class >> nameAssocAsKey: assoc [

  ^  (assoc value),'ˆ', (assoc key)
     
 
]

{ #category : 'accessing' }
TTNamespaces class >> nameKeyFromAssoc: assoc [

  ^  (assoc value),'ˆ', (assoc key)
     
 
]

{ #category : 'accessing' }
TTNamespaces class >> namespacePrefixSizeFor: aClassName [

	self registry do: [ :ns | 
	
			(aClassName beginsWith: ns) ifTrue: [ 
		
						aClassName size = ns size ifTrue: [ ^ nil ].
						(aClassName at: (ns size + 1)) isLowercase ifTrue: [ ^ nil ].
			
			 		^ ns size
			 	]
		].
		
		^ nil
		 
	  
]

{ #category : 'accessing' }
TTNamespaces class >> registry [

	 ^ Registry ifNil: [ Registry := self allNamespacesSorted ]
]

{ #category : 'accessing' }
TTNamespaces class >> shutDown: quitting [
	
	<ttShutDown>
	
	Registry := nil
]

{ #category : 'accessing' }
TTNamespaces class >> someNamespaces [

	^ #(Gt4 GtCSS GtCS GtL Gt GT Br Bl)
]

{ #category : 'accessing' }
TTNamespaces class >> traitedNamespaces [
      ^ (TheHub allIdentifyingAsClasses
          select: [ :c | c askFor: #isNamespaced ] thenCollect: [ :n | n ttNamespace ])  asSet 

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
