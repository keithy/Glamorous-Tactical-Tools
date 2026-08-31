Class {
	#name : 'TTViewBuilderAbstract',
	#superclass : 'Object',
	#instVars : [
		'theme',
		'root',
		'context',
		'view'
	],
	#category : 'Tactical-GT-Views',
	#package : 'Tactical-GT',
	#tag : 'Views'
}

{ #category : 'as yet unclassified' }
TTViewBuilderAbstract >> childrenForNode: anInspectorNode [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
TTViewBuilderAbstract >> context: aContext [
	context := aContext
		
]

{ #category : 'as yet unclassified' }
TTViewBuilderAbstract >> iconElementForNode: anInspectorNode [
	^ (theme forInspector: anInspectorNode) beDebug asElementInTreeRow value
]

{ #category : 'accessing' }
TTViewBuilderAbstract >> root: anObject [
	root := anObject
]

{ #category : 'accessing' }
TTViewBuilderAbstract >> setView: aView [
	view := aView
]

{ #category : 'accessing' }
TTViewBuilderAbstract >> theme: anObject [
	theme := anObject
]
