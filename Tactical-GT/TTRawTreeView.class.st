Class {
	#name : 'TTRawTreeView',
	#superclass : 'TTViewBuilderAbstract',
	#category : 'Tactical-GT-Views',
	#package : 'Tactical-GT',
	#tag : 'Views'
}

{ #category : 'as yet unclassified' }
TTRawTreeView >> asRawView [
	^ self asView
		title: theme titleRawView;
		priority: 100;
		send: #value
]

{ #category : 'as yet unclassified' }
TTRawTreeView >> asView [
  
	view
		importantFutureExecutionConfiguration;
		items: [ self nodes ];
		children: [ :aNode | self childrenForNode: aNode ].
		
	self viewAddColumnEntry:'Entry'.
	self viewAddColumnValue:'Value'.
	self viewAddDynamicItems.
	
	view actionUpdateButton.
		
	^ view
]

{ #category : 'as yet unclassified' }
TTRawTreeView >> childrenForNode: anInspectorNode [
	^ (theme forInspector: anInspectorNode) childrenNodes
]

{ #category : 'as yet unclassified' }
TTRawTreeView >> nodes [
| variableNodes |
			variableNodes := OrderedCollection new: root class allSlots size.
			variableNodes add: (GtInspectorSelfNode hostObject: root).
			root gtInspectorVariableNodesIn: variableNodes.
			
			^ variableNodes 
]

{ #category : 'accessing' }
TTRawTreeView >> setView: aView [
	view := aView columnedTree
						send: #value
						yourself
		
]

{ #category : 'as yet unclassified' }
TTRawTreeView >> viewAddColumnEntry: aHeading [

	view	column: aHeading
			do: [ :aColumn | 
				aColumn
					dataBinder: [ :itemElement :aNode | 
						| variableLabel classNameLabel extraInfoLabel |
						itemElement
							removeChildren;
							addChild: (self iconElementForNode: aNode).

						variableLabel := BrLabel new
								aptitude: BrGlamorousListLabelAptitude;
								text: aNode label;
								alignCenterLeft;
								fitContent.

						aNode isSlotNode
							ifTrue: [ classNameLabel := BrLabel new
										aptitude: (BrGlamorousListLabelAptitude new
												foreground: itemElement theme button disabledTextColor);
										beSmallSize;
										text: aNode value class name;
										alignCenterLeft;
										hMatchParent;
										vFitContent ].

						aNode isWeakClassNode
							ifTrue: [ extraInfoLabel := BrLabel new
										aptitude: (BrGlamorousListLabelAptitude new
												foreground: itemElement theme button disabledTextColor);
										beMiniSize;
										text: 'weak class';
										alignCenterLeft;
										hMatchParent;
										vFitContent ].

						aNode isEphemeronClassNode
							ifTrue: [ extraInfoLabel := BrLabel new
										aptitude: (BrGlamorousListLabelAptitude new
												foreground: itemElement theme button disabledTextColor);
										beMiniSize;
										text: 'ephemeron class';
										alignCenterLeft;
										hMatchParent;
										vFitContent ].

						aNode isWeakReferenceNode
							ifTrue: [ extraInfoLabel := BrLabel new
										aptitude: (BrGlamorousListLabelAptitude new
												foreground: itemElement theme button disabledTextColor);
										beMiniSize;
										text: 'weak reference';
										alignCenterLeft;
										hMatchParent;
										vFitContent ].

						aNode isEphemeronReferenceNode
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
							alignCenterLeft ] ]
]

{ #category : 'as yet unclassified' }
TTRawTreeView >> viewAddColumnValue: aHeading [

view	column: aHeading
			text: [ :anInspectorNode | (theme forInspector: anInspectorNode) displayText ]
			weight: 2
			
]

{ #category : 'accessing' }
TTRawTreeView >> viewAddDynamicItems [
	view
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
								do: [ :aMenuItem | aStream nextPut: aMenuItem ] ] ] ]
]
