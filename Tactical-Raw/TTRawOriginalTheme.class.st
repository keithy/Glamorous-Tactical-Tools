Class {
	#name : 'TTRawOriginalTheme',
	#superclass : 'Object',
	#instVars : [
		'object',
		'debug',
		'type'
	],
	#category : 'Tactical-Raw-Theme',
	#package : 'Tactical-Raw',
	#tag : 'Theme'
}

{ #category : 'as yet unclassified' }
TTRawOriginalTheme class >> iconForInspector: anInspectorNode [ 

	^(self basicNew)
			object: anInspectorNode rawValue;
			initialize
]

{ #category : 'as yet unclassified' }
TTRawOriginalTheme >> asElementInTreeRow [

^ (self protect: [ self icon ]) value asElement margin: (BlInsets right: 5)
]

{ #category : 'accessing' }
TTRawOriginalTheme >> beDebug [

	debug := true
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
	self resolveType.
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
