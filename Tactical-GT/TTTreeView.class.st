Class {
	#name : 'TTTreeView',
	#superclass : 'TTRawTreeView',
	#instVars : [
		'callback'
	],
	#category : 'Tactical-GT-Views',
	#package : 'Tactical-GT',
	#tag : 'Views'
}

{ #category : 'accessing' }
TTTreeView >> callback: anObject [
	callback := anObject
]

{ #category : 'as yet unclassified' }
TTTreeView >> childrenForNode: anInspectorNode [
		^ (self childrenFromCallbackTo: anInspectorNode rawValue)
		ifNil: [ (theme forInspector: anInspectorNode) childrenNodes ]
	
]

{ #category : 'as yet unclassified' }
TTTreeView >> childrenFromCallbackTo: anItem [
	^ self
		nodesChosen: (anItem askFor: callback ifAbsent: [ ^ nil ] )
		from: anItem
]

{ #category : 'as yet unclassified' }
TTTreeView >> nodes [
	^ self nodesChosen: (root askFor: callback ifAbsent: #()) from: root
]

{ #category : 'as yet unclassified' }
TTTreeView >> nodesChosen: chosenList from: anItem [

"single symbol is a #slotName
array #(label #accessor)"
	| nodes |
	
	nodes := OrderedCollection new.

			nodes
				addAll: (chosenList
						collect: [ :item | 
							| newNode |
							item isSymbol
								ifTrue: [ newNode := GtInspectorSlotNode
											hostObject: anItem
											slot: (anItem class slotNamed: item) ].

							item isArray
								ifTrue: [ newNode := GtInspectorDynamicNode
											hostObject: anItem
											label: item first
											value: (anItem askFor: item second ifAbsent: nil) ].

							newNode ]).
							
		^ nodes 
]
