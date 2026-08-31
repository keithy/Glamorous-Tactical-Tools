Class {
	#name : 'TTInspectorOriginalTheme',
	#superclass : 'Object',
	#instVars : [
		'object',
		'debug',
		'type',
		'node',
		'stream',
		'venue'
	],
	#category : 'Tactical-GT-Views',
	#package : 'Tactical-GT',
	#tag : 'Views'
}

{ #category : 'as yet unclassified' }
TTInspectorOriginalTheme class >> arrayExpansion [

^ #()
]

{ #category : 'as yet unclassified' }
TTInspectorOriginalTheme class >> dictionaryExpansion [

^ #()
]

{ #category : 'as yet unclassified' }
TTInspectorOriginalTheme class >> forInspector: anInspectorNode [ 

	^(self basicNew)
			node: anInspectorNode;
			initialize
]

{ #category : 'as yet unclassified' }
TTInspectorOriginalTheme class >> limitExpansion [

^ #()
]

{ #category : 'as yet unclassified' }
TTInspectorOriginalTheme class >> titleRawView [

	^ 'Raw'
]

{ #category : 'as yet unclassified' }
TTInspectorOriginalTheme >> asElementInTreeRow [
	
	^ (self protectIcon: [ self icon ]) asElement margin: (BlInsets right: 3)
	
]

{ #category : 'accessing' }
TTInspectorOriginalTheme >> beDebug [

	debug := true
]

{ #category : 'as yet unclassified' }
TTInspectorOriginalTheme >> childrenNodes [
 
  node childrenNodes ifEmpty: [ ^ #() ].
   
	(self class dictionaryExpansion includes: type) ifTrue: [ ^ self childrenNodesAsKeysAndValues ].
		
	(self class arrayExpansion includes: type) ifTrue: [ ^ self childrenNodesAsArray  ].

	(self class limitExpansion includes: type) ifTrue: [ ^ #() ].
	
	^ node childrenNodes
	
]

{ #category : 'as yet unclassified' }
TTInspectorOriginalTheme >> childrenNodesAsArray [
	| variableNodes |
	variableNodes := OrderedCollection new: object size.

	object asArray gtInspectorVariableNodesIn: variableNodes.

	^ variableNodes
]

{ #category : 'as yet unclassified' }
TTInspectorOriginalTheme >> childrenNodesAsAssociations [
	| variableNodes |
	variableNodes := OrderedCollection new: object size.

	object associations gtInspectorVariableNodesIn: variableNodes.

	^ variableNodes
]

{ #category : 'as yet unclassified' }
TTInspectorOriginalTheme >> childrenNodesAsKeysAndValues [
		
	^  (object associations collect: [ :assoc |
			GtInspectorDynamicNode hostObject: object label: assoc key value: assoc value
	])

]

{ #category : 'as yet unclassified' }
TTInspectorOriginalTheme >> displayOn: aStream [
	"This offers a means to customize how the object is shown in the GlamorousToolkit UI"
	^ object gtDisplayOn: aStream
]

{ #category : 'as yet unclassified' }
TTInspectorOriginalTheme >> displayString [
    | limitedString limit |
    limit := 1000.
    limitedString := String streamContents: [:s | self displayOn: s] limitedTo: limit.
    limitedString size < limit ifTrue: [^ limitedString].
    ^ limitedString , ' ...'
]

{ #category : 'as yet unclassified' }
TTInspectorOriginalTheme >> displayText [
  
  type == #instance ifTrue: [ object gtDisplayText ].
  
	^ [ self displayString asRopedText ]
		on: Error, Halt 
		do: [ node errorMessage asRopedText foreground: Color red ]
]

{ #category : 'as yet unclassified' }
TTInspectorOriginalTheme >> icon [
	^ (object gtInspectorIcon
				ifNil: [ object gtIcon ifNil: [ object class iconNamed: object class systemIconName ] ])
]

{ #category : 'accessing' }
TTInspectorOriginalTheme >> initialize [
	debug := false.
	object := node rawValue.
	self originalType.
]

{ #category : 'accessing' }
TTInspectorOriginalTheme >> node [
	^ node
]

{ #category : 'accessing' }
TTInspectorOriginalTheme >> node: anObject [
	node := anObject
]

{ #category : 'accessing' }
TTInspectorOriginalTheme >> object [
	^ object
]

{ #category : 'accessing' }
TTInspectorOriginalTheme >> object: anObject [
	object := anObject.
]

{ #category : 'accessing' }
TTInspectorOriginalTheme >> originalType [
 
 	type := object askFor: #ttType ifAbsent: #instance
	
]

{ #category : 'as yet unclassified' }
TTInspectorOriginalTheme >> protectIcon: aBlock [
	debug ifTrue: [ ^ aBlock value ].
	
	^ aBlock on: Error do: [ :error | #error ->Smalltalk ui icons iconNamed: #smallWarning]
]

{ #category : 'as yet unclassified' }
TTInspectorOriginalTheme >> type [
	
	^ type
]
