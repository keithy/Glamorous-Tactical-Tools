Class {
	#name : 'TTRawOriginalTheme',
	#superclass : 'Object',
	#instVars : [
		'object',
		'debug',
		'type',
		'node'
	],
	#category : 'Tactical-Raw-Theme',
	#package : 'Tactical-Raw',
	#tag : 'Theme'
}

{ #category : 'as yet unclassified' }
TTRawOriginalTheme class >> arrayExpansion [

^ #()
]

{ #category : 'as yet unclassified' }
TTRawOriginalTheme class >> dictionaryExpansion [

^ #()
]

{ #category : 'as yet unclassified' }
TTRawOriginalTheme class >> forInspector: anInspectorNode [ 

	^(self basicNew)
			node: anInspectorNode;
			initialize
]

{ #category : 'as yet unclassified' }
TTRawOriginalTheme class >> limitExpansion [

^ #()
]

{ #category : 'as yet unclassified' }
TTRawOriginalTheme class >> specialExpansion [

^ #()
]

{ #category : 'as yet unclassified' }
TTRawOriginalTheme >> asElementInTreeRow [
	
	| assoc |
	assoc := self protect: [ self icon ].
	
	^ assoc value: (assoc value asElement margin: (BlInsets right: 3))
]

{ #category : 'accessing' }
TTRawOriginalTheme >> beDebug [

	debug := true
]

{ #category : 'as yet unclassified' }
TTRawOriginalTheme >> childrenNodes [
 
	(self class dictionaryExpansion includes: type) ifTrue: [ ^ type -> self childrenNodesAsKeysAndValues ].
		
	(self class arrayExpansion includes: type) ifTrue: [ ^ type -> self childrenNodesAsArray  ].

	(self class limitExpansion includes: type) ifTrue: [ ^ type ->#() ].
	
	^ type ->  node childrenNodes
	
]

{ #category : 'as yet unclassified' }
TTRawOriginalTheme >> childrenNodesAsArray [
	| variableNodes |
	variableNodes := OrderedCollection new: object size.

	object asArray gtInspectorVariableNodesIn: variableNodes.

	^ variableNodes
]

{ #category : 'as yet unclassified' }
TTRawOriginalTheme >> childrenNodesAsAssociations [
	| variableNodes |
	variableNodes := OrderedCollection new: object size.

	object associations gtInspectorVariableNodesIn: variableNodes.

	^ variableNodes
]

{ #category : 'as yet unclassified' }
TTRawOriginalTheme >> childrenNodesAsKeysAndValues [
		
	^  (object associations collect: [ :assoc |
			GtInspectorDynamicNode hostObject: object label: assoc key value: assoc value
	])

]

{ #category : 'as yet unclassified' }
TTRawOriginalTheme >> icon [
	^ type
		-> (object gtInspectorIcon
				ifNil: [ object class iconNamed: object class systemIconName ])
]

{ #category : 'accessing' }
TTRawOriginalTheme >> initialize [
	debug := false.
	object := node rawValue.
	self resolveType.
]

{ #category : 'accessing' }
TTRawOriginalTheme >> node [
	^ node
]

{ #category : 'accessing' }
TTRawOriginalTheme >> node: anObject [
	node := anObject
]

{ #category : 'accessing' }
TTRawOriginalTheme >> object [
	^ object
]

{ #category : 'accessing' }
TTRawOriginalTheme >> object: anObject [
	object := anObject.
]

{ #category : 'as yet unclassified' }
TTRawOriginalTheme >> protect: aBlock [
	debug ifTrue: [ ^ aBlock value ].
	
	^ aBlock on: Error do: [ :error | #error ->Smalltalk ui icons iconNamed: #smallWarning]
]

{ #category : 'accessing' }
TTRawOriginalTheme >> resolveType [
	type   := object askFor: #ttType ifAbsent: [ object gtIconName ].
	type == #empty ifTrue: [ 
		type := object gtSystemIconName.
		type == #class ifTrue: [ type := #instance ]
	].
]
