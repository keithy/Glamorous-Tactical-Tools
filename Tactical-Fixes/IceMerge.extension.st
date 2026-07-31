Extension { #name : 'IceMerge' }

{ #category : '*Tactical-Fixes' }
IceMerge >> gtViewInspectorDiffFor: aView [
	<gtView>
	^ aView tree
		title: 'Changes';
		items: [ self treeToShow children ];
		children: #children;
		expandAll;
		updateWhen: GtIceMergeConflictResolved in: [ Iceberg announcer ];
		stencil: [ :anIceNode | 
			| element |
			element := BlElement new
					layout: BlLinearLayout horizontal;
					constraintsDo: [ :c | 
						c horizontal matchParent.
						c vertical fitContent ];
					margin: (BlInsets all: 3);
					constraintsDo: [ :c | c vertical fitContent ];
					addChild: (anIceNode value icon asElement
							constraintsDo: [ :c | c linear vertical alignCenter ]);
					addChild: (BrLabel new
							text: anIceNode key asString;
							aptitude: BrGlamorousLabelAptitude;
							padding: (BlInsets
									top: 3
									left: 6
									bottom: 0
									right: 3);
							constraintsDo: [ :c | c linear horizontal alignCenter ]).	"aptitude:
					(BrGlamorousWithContextMenuAptitude
						content: [ BrGlamorousSimpleContextMenuContent new
								display:
									{('Revert changes' -> [ self revertChanges: anIceNode ])};
								yourself ]);"
			Iceberg announcer
				when: GtIceMergeConflictResolved
				do: [ element phlow fireToolUpdateWish ]
				for: self.

			anIceNode value isUnresolvedConflict
				ifTrue: [ element
						addChild: (BrGlamorousVectorIcons debug asElement
								constraintsDo: [ :c | c linear vertical alignCenter ]) ].
			element ]
]
