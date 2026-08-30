Extension { #name : 'Object' }

{ #category : '*Tactical-Raw' }
Object >> ttRawThemedFor: aView [
 
	^ aView columnedTree
		title: 'Raw™';
		importantFutureExecutionConfiguration;
		priority: 100;
		items: [ | variableNodes |
			variableNodes := OrderedCollection new: self class allSlots size.
			variableNodes add: (GtInspectorSelfNode hostObject: self).
			self gtInspectorVariableNodesIn: variableNodes.
			variableNodes ];
		children: [ :anInspectorNode | (self ttTheme forInspector: anInspectorNode) childrenNodes value ];
		column: 'Variable'
			do: [ :aColumn | 
				aColumn
					dataBinder: [ :itemElement :anInspectorNode | 
						| variableLabel classNameLabel extraInfoLabel |
						itemElement
							removeChildren;
							addChild: (self ttTheme forInspector: anInspectorNode) beDebug asElementInTreeRow value.

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
							creator selfObject: self.
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
