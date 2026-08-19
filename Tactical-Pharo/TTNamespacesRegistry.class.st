"
Characters discovered that could conceivably be used as separators:

circumflex: $ˆ
masculine ordinal: $º
feminine ordinal: $ª
phonetic f: $
omega: $Ω
eszett: ¢ß 

"
Class {
	#name : 'TTNamespacesRegistry',
	#superclass : 'Object',
	#classVars : [
		'PragmaCache',
		'Registry'
	],
	#category : 'Tactical-Pharo-Namespaces',
	#package : 'Tactical-Pharo',
	#tag : 'Namespaces'
}

{ #category : 'as yet unclassified' }
TTNamespacesRegistry class >> hint1: aClassName [

	^ 1 -> 0
		
]

{ #category : 'as yet unclassified' }
TTNamespacesRegistry class >> hint2: aClassName [

	^ 2 -> 0
		
]

{ #category : 'as yet unclassified' }
TTNamespacesRegistry class >> hint3: aClassName [

	^ 3 -> 0
		
]

{ #category : 'as yet unclassified' }
TTNamespacesRegistry class >> hint4: aClassName [

	^ 4 -> 0
		
]

{ #category : 'as yet unclassified' }
TTNamespacesRegistry class >> hintAuto: aClassName [
	| found |
	found := self knownNamespacesSortedBySize
			detect: [ :prefix | aClassName beginsWith: prefix ]
			ifNone: [ ^ 0 -> 0 ].

	^ found size -> 0
]

{ #category : 'as yet unclassified' }
TTNamespacesRegistry class >> hintCircumflex: aClassName [
	| position |
	
	position := aClassName indexOf: $ˆ.
	
	position == 0 ifTrue: [ ^ 0 -> 0 ].
	^ position -> 1
		
]

{ #category : 'as yet unclassified' }
TTNamespacesRegistry class >> hintNone: aClassName [

	^ 0 -> 0
		
]

{ #category : 'as yet unclassified' }
TTNamespacesRegistry class >> hintSelectorFrom: pragma [
	pragma ifNil: [ ^ #hintNone:  ].
	
	^ pragma arguments first
]

{ #category : 'as yet unclassified' }
TTNamespacesRegistry class >> knownNamespacesSortedBySize [
	"until we have some form of registration"

	^ self someNamespaces
]

{ #category : 'as yet unclassified' }
TTNamespacesRegistry class >> namespaced: aClass [
	| sizer namespace localName fullName |
	
	aClass ifNil: [ ^ (nil -> nil) ].
	
	sizer := self sizerFor: aClass.

	fullName := aClass name.
	namespace := fullName copyFrom: 1 to: sizer key.
	localName := fullName copyFrom: (namespace size + 1 + sizer value) to: fullName size.

	^ namespace -> localName
]

{ #category : 'as yet unclassified' }
TTNamespacesRegistry class >> pragmaSizeFor: aClass [
	^ (aClass lookupSelector: #isNamespaced) pragmaAt: #nsSize:
		 
]

{ #category : 'as yet unclassified' }
TTNamespacesRegistry class >> pragmas [ 

	^ PragmaCache ifNil: [ PragmaCache := self pragmasAll]
]

{ #category : 'as yet unclassified' }
TTNamespacesRegistry class >> pragmasAll [

	^ (Pragma allNamed: #nsSize:) reject: [ :p | p methodClass isTrait ]
]

{ #category : 'as yet unclassified' }
TTNamespacesRegistry class >> pragmasAllSized [

	^ self pragmasAll collect: [ :p | p -> (self namespaced: p methodClass) ]
]

{ #category : 'as yet unclassified' }
TTNamespacesRegistry class >> sizeFrom: pragma forName: aClassName [

	| hint |
	pragma ifNil: [ ^ nil ].
	hint := self hintSelectorFrom: pragma.
	hint isInteger ifTrue: [ ^hint  ].
	^ self perform: (self hintSelectorFrom: pragma) with: aClassName
]

{ #category : 'as yet unclassified' }
TTNamespacesRegistry class >> sizerFor: aClass [
	^ self
		sizeFrom: ((aClass class lookupSelector: #isNamespaced) pragmaAt: #nsSize:)
		forName: aClass name
]

{ #category : 'as yet unclassified' }
TTNamespacesRegistry class >> someNamespaces [

	^ #(GtCSS GtCS Gt4 GtL Gt GT Br Bl)
]

{ #category : 'as yet unclassified' }
TTNamespacesRegistry >> initialize [

	Registry := self new

 
]

{ #category : 'as yet unclassified' }
TTNamespacesRegistry >> registry [

	^ Registry
]
