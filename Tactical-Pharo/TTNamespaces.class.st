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
	#name : 'TTNamespaces',
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
TTNamespaces class >> automaticNamespaces [

	"Sorted by size"
	
	^ #(GtCSS GtCS Gt4 GtL Gt GT Br Bl TT)
]

{ #category : 'as yet unclassified' }
TTNamespaces class >> hintAuto: aClassName [
	| found |
	found := self knownNamespacesSortedBySize
			detect: [ :prefix | aClassName beginsWith: prefix ]
			ifNone: [ ^ 0 -> 0 ].

	^ found size -> 0
]

{ #category : 'as yet unclassified' }
TTNamespaces class >> namespaced: aClass [
	| sizer namespace localName fullName |
	
	aClass ifNil: [ ^ (nil -> nil) ].
	
	sizer := self sizerFor: aClass.

	fullName := aClass name.
	namespace := fullName copyFrom: 1 to: sizer key.
	localName := fullName copyFrom: ((sizer key) + 1 + (sizer value)) to: fullName size.

	^ namespace -> localName
]

{ #category : 'as yet unclassified' }
TTNamespaces class >> pragmas [ 

	^ PragmaCache ifNil: [ PragmaCache := self pragmasAll]
]

{ #category : 'as yet unclassified' }
TTNamespaces class >> pragmasAll [

	^ (Pragma allNamed: #namespaced:) reject: [ :p | p methodClass isTrait ]
]

{ #category : 'as yet unclassified' }
TTNamespaces class >> pragmasAllArgs [

	^ self pragmasAll collect: [ :p | p -> p arguments first ]
]

{ #category : 'as yet unclassified' }
TTNamespaces class >> pragmasAllSized [

	^ self pragmasAll collect: [ :p | p -> (self namespaced: p methodClass soleInstance) ]
]

{ #category : 'as yet unclassified' }
TTNamespaces class >> sizerFor: aClass [
	^ self
		sizerFromPragma: (((aClass class lookupSelector: #isNamespaced) ifNil: [ ^ 0 -> 0 ])
				pragmaAt: #namespaced:)
		forName: aClass name
]

{ #category : 'as yet unclassified' }
TTNamespaces class >> sizerFor: aClassName splitOn: aChar [

	| position |
	
	position := aClassName indexOf: aChar.
	position == 0 ifTrue: [ ^ 0 -> 0 ].
	 
	^ ((position - 1) -> 1)
		
]

{ #category : 'as yet unclassified' }
TTNamespaces class >> sizerFromPragma: pragma forName: aClassName [
	| option |
	option := pragma ifNotNil: [ :p | p arguments first ] ifNil: 0.
	
	option isSymbol ifTrue: [ ^ self perform: option with: aClassName ].
	option isString ifTrue: [ ^ option size -> 0 ].
	option isInteger ifTrue: [ ^ option -> 0 ].
	option isCharacter ifTrue: [ ^ self sizerFor: aClassName splitOn: option ].

	self error: 'Missing annotation type?'
]

{ #category : 'as yet unclassified' }
TTNamespaces class >> splitAutomatically: aClassName [
	| found |

  aClassName size == 1 ifTrue:[ ^ 0 ->0 ].
  
  (aClassName second isLowercase and: [ 
  		(aClassName count: [ :ea | ea isUppercase ]) == 1 ]) ifTrue: [ ^ 0 -> 0 ].
  
  (aClassName includes: $ˆ) ifTrue: [ ^ self splitOnCircumflex: aClassName ].

	found := self automaticNamespaces
			detect: [ :prefix | aClassName beginsWith: prefix ]
			ifNone: [ ^ 0 -> 0 ].

	^ found size -> 0
]

{ #category : 'as yet unclassified' }
TTNamespaces class >> splitOnCircumflex: aClassName [
	^ self sizerFor: aClassName splitOn: $ˆ
]

{ #category : 'as yet unclassified' }
TTNamespaces >> initialize [

	Registry := self new

 
]

{ #category : 'as yet unclassified' }
TTNamespaces >> registry [

	^ Registry
]
