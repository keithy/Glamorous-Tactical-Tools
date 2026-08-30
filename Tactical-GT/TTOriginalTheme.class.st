Class {
	#name : 'TTOriginalTheme',
	#superclass : 'Object',
	#instVars : [
		'object',
		'debug',
		'type',
		'node'
	],
	#category : 'Tactical-GT-Views',
	#package : 'Tactical-GT',
	#tag : 'Views'
}

{ #category : 'as yet unclassified' }
TTOriginalTheme class >> arrayExpansion [

^ #()
]

{ #category : 'as yet unclassified' }
TTOriginalTheme class >> dictionaryExpansion [

^ #()
]

{ #category : 'as yet unclassified' }
TTOriginalTheme class >> forInspector: anInspectorNode [ 

	^(self basicNew)
			node: anInspectorNode;
			initialize
]

{ #category : 'as yet unclassified' }
TTOriginalTheme class >> limitExpansion [

^ #()
]

{ #category : 'as yet unclassified' }
TTOriginalTheme class >> toolTitle [

	^ 'Raw'
]

{ #category : 'as yet unclassified' }
TTOriginalTheme class >> viewRawOn: object for: aView [
 
	^ aView columnedTree
		title: (self toolTitle);
		importantFutureExecutionConfiguration;
		priority: 100;
		items: [ | variableNodes |
			variableNodes := OrderedCollection new: object class allSlots size.
			variableNodes add: (GtInspectorSelfNode hostObject: object).
			object gtInspectorVariableNodesIn: variableNodes.
			variableNodes ];
		children: [ :anInspectorNode | (self forInspector: anInspectorNode) childrenNodes value ];
		column: 'Variable'
			do: [ :aColumn | 
				aColumn
					dataBinder: [ :itemElement :anInspectorNode | 
						| variableLabel classNameLabel extraInfoLabel |
						itemElement
							removeChildren;
							addChild: (self forInspector: anInspectorNode) beDebug asElementInTreeRow value.

						variableLabel := BrLabel new
								aptitude: BrGlamorousListLabelAptitude;
								text: (anInspectorNode label);
								alignCenterLeft;
								fitContent.

						anInspectorNode isSlotNode
							ifTrue: [ classNameLabel := BrLabel new
										aptitude: (BrGlamorousListLabelAptitude new
												foreground: itemElement theme button disabledTextColor);
										beSmallSize;
										text: anInspectorNode value class name;
										alignCenterLeft;
										hMatchParent;
										vFitContent ].

						anInspectorNode isWeakClassNode
							ifTrue: [ extraInfoLabel := BrLabel new
										aptitude: (BrGlamorousListLabelAptitude new
												foreground: itemElement theme button disabledTextColor);
										beMiniSize;
										text: 'weak class';
										alignCenterLeft;
										hMatchParent;
										vFitContent ].

						anInspectorNode isEphemeronClassNode
							ifTrue: [ extraInfoLabel := BrLabel new
										aptitude: (BrGlamorousListLabelAptitude new
												foreground: itemElement theme button disabledTextColor);
										beMiniSize;
										text: 'ephemeron class';
										alignCenterLeft;
										hMatchParent;
										vFitContent ].

						anInspectorNode isWeakReferenceNode
							ifTrue: [ extraInfoLabel := BrLabel new
										aptitude: (BrGlamorousListLabelAptitude new
												foreground: itemElement theme button disabledTextColor);
										beMiniSize;
										text: 'weak reference';
										alignCenterLeft;
										hMatchParent;
										vFitContent ].

						anInspectorNode isEphemeronReferenceNode
							ifTrue: [ extraInfoLabel := BrLabel new
										aptitude: (BrGlamorousListLabelAptitude new
												foreground: itemElement theme button disabledTextColor);
										beMiniSize;
										text: 'ephemeron reference';
										alignCenterLeft;
										hMatchParent;
										vFitContent ].

						(classNameLabel isNotNil or: [ extraInfoLabel isNotNil ])
							ifTrue: [ | labelsContainer |
								labelsContainer := BlElement new
										layout: BrEditorTextFlowLayout new;
										constraintsDo: [ :c | 
											c horizontal fitContent.
											c vertical fitContent ].

								labelsContainer addChild: variableLabel.
								classNameLabel
									ifNotNil: [ itemElement
											addAptitude: (BrLazyStyleCommonAptitude new
													@ classNameLabel;
													default: [ :style | style gone ];
													hovered: [ :style | style visible ]).
										labelsContainer addChild: classNameLabel ].
								extraInfoLabel ifNotNil: [ labelsContainer addChild: extraInfoLabel ].

								itemElement addChild: labelsContainer ]
							ifFalse: [ itemElement addChild: variableLabel ].	"extraInfo ifFalse: [ itemElement children last hMatchParent ]."

						itemElement ];
					cellStencil: [ BrHorizontalPane new
							hMatchParent;
							vFitContent;
							alignCenterLeft ] ];
		column: 'Value'
			text: [ :anInspectorNode | 
				[ anInspectorNode rawValue gtDisplayText ]
					on: Error , Halt
					do: [ anInspectorNode errorMessage asRopedText foreground: Color red ] ]
			weight: 2;
		send: #value;
		dynamicContextItems: [ :anElement :anInspectorNode | 
			anInspectorNode isSlotNode
				ifTrue: [ (GtViewCreator
						viewCreatorsForObject: anInspectorNode rawValue
						andSource: anInspectorNode key
						in: anInspectorNode hostObject class)
						collect: [ :creator | 
							creator selfObject: anInspectorNode hostObject.
							creator asMenuItem ] ]
				ifFalse: [ #() ] ];
		dynamicContextItems: [ :anElement :anInspectorNode | 
			Array
				streamContents: [ :aStream | 
					anInspectorNode isSlotNode
						ifTrue: [ | aPhlowContext |
							aPhlowContext := GtPhlowContext new.
							aPhlowContext selfObject: anInspectorNode hostObject.
							aPhlowContext behavior: anInspectorNode hostObject class.

							GtCoderVariableTarget
								menuItemsForObject: anInspectorNode slot
								inContext: aPhlowContext
								hostElement: nil
								do: [ :aMenuItem | aStream nextPut: aMenuItem ] ] ] ];
		actionUpdateButton
]

{ #category : 'as yet unclassified' }
TTOriginalTheme >> asElementInTreeRow [
	
	| assoc |
	assoc := self protect: [ self icon ].
	
	^ assoc value: (assoc value asElement margin: (BlInsets right: 3))
]

{ #category : 'accessing' }
TTOriginalTheme >> beDebug [

	debug := true
]

{ #category : 'as yet unclassified' }
TTOriginalTheme >> childrenNodes [
 
  node childrenNodes ifEmpty: [ ^ type -> #() ].
   
	(self class dictionaryExpansion includes: type) ifTrue: [ ^ type -> self childrenNodesAsKeysAndValues ].
		
	(self class arrayExpansion includes: type) ifTrue: [ ^ type -> self childrenNodesAsArray  ].

	(self class limitExpansion includes: type) ifTrue: [ ^ type ->#() ].
	
	^ type ->  node childrenNodes
	
]

{ #category : 'as yet unclassified' }
TTOriginalTheme >> childrenNodesAsArray [
	| variableNodes |
	variableNodes := OrderedCollection new: object size.

	object asArray gtInspectorVariableNodesIn: variableNodes.

	^ variableNodes
]

{ #category : 'as yet unclassified' }
TTOriginalTheme >> childrenNodesAsAssociations [
	| variableNodes |
	variableNodes := OrderedCollection new: object size.

	object associations gtInspectorVariableNodesIn: variableNodes.

	^ variableNodes
]

{ #category : 'as yet unclassified' }
TTOriginalTheme >> childrenNodesAsKeysAndValues [
		
	^  (object associations collect: [ :assoc |
			GtInspectorDynamicNode hostObject: object label: assoc key value: assoc value
	])

]

{ #category : 'as yet unclassified' }
TTOriginalTheme >> icon [
	^ type
		-> (object gtInspectorIcon
				ifNil: [ object class iconNamed: object class systemIconName ])
]

{ #category : 'accessing' }
TTOriginalTheme >> initialize [
	debug := false.
	object := node rawValue.
	self resolveType.
]

{ #category : 'accessing' }
TTOriginalTheme >> node [
	^ node
]

{ #category : 'accessing' }
TTOriginalTheme >> node: anObject [
	node := anObject
]

{ #category : 'accessing' }
TTOriginalTheme >> object [
	^ object
]

{ #category : 'accessing' }
TTOriginalTheme >> object: anObject [
	object := anObject.
]

{ #category : 'as yet unclassified' }
TTOriginalTheme >> protect: aBlock [
	debug ifTrue: [ ^ aBlock value ].
	
	^ aBlock on: Error do: [ :error | #error ->Smalltalk ui icons iconNamed: #smallWarning]
]

{ #category : 'accessing' }
TTOriginalTheme >> resolveType [
	type := object askFor: #ttType ifAbsent: [ object gtIconName ].
	type == #empty
		ifTrue: [ type := object gtSystemIconName.
			type == #class ifTrue: [ type := #instance ] ] "fix wierdness"
]
