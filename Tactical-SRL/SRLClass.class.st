Class {
	#name : 'SRLClass',
	#superclass : 'SRLRouter',
	#category : 'Tactical-SRL-Schemes',
	#package : 'Tactical-SRL',
	#tag : 'Schemes'
}

{ #category : 'as yet unclassified' }
SRLClass class >> canRoute: aSymbol [

	^ aSymbol == #class:
]

{ #category : 'as yet unclassified' }
SRLClass class >> class: aClassOrName [

	"local shortcut"
	 ^ self new resolve: aClassOrName
   
    
]

{ #category : 'as yet unclassified' }
SRLClass class >> example [
	<gtExample>
	^ #class: // #Object
]

{ #category : 'as yet unclassified' }
SRLClass class >> exampleMatchesShortCut [
	<gtExample>
	^ self example == (self class: #Object)
]

{ #category : 'as yet unclassified' }
SRLClass >> namespaceSearch: circumflexAndClassName [
	self hub classSearchPath
		do: [ :namespace | 
			(self resolve: namespace , circumflexAndClassName)
				ifNotNil: [ :found | ^ found ] ].

	^ self resolve: circumflexAndClassName copyWithoutFirst
]

{ #category : 'as yet unclassified' }
SRLClass >> resolve: aClassOrSymbolOrName [

	"Better #asClass"
 
	"Better: handles nil, class already passthrough,
	 and fall back through namespace lookup"
	 
	"Returning nil when not found allows the user to implement
	 ifAbsent/ifPresent using ifNil:ifNotNil:"

   aClassOrSymbolOrName ifNil: [ ^ nil ].
   
   aClassOrSymbolOrName isClass ifTrue: [ ^ aClassOrSymbolOrName ].
   
   Smalltalk at: aClassOrSymbolOrName asSymbol ifPresent: [ :found | ^ found ].
   
   "This $ˆ is a circumflex"
   (aClassOrSymbolOrName first = $ˆ) ifTrue: [ 
   		(self namespaceSearch: aClassOrSymbolOrName)
   				 ifNotNil: [ :found | ^ found ]
   ].
   
   ^ nil
]
