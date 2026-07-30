Extension { #name : 'Pragma' }

{ #category : '*Tactical-Tools-GT' }
Pragma class >> ttItemsWithActionFor: aView context: theContext [
	<ttViewInCollection>
	
		^ aView columnedList
		title: '[each]';
		priority: 5;
		items: [ theContext optionAt: #theCollection ifAbsent: #() ] ;
		actionUpdateButtonTooltip: 'Update item list';
		column: '#' 
			text: [ :eachItem :eachIndex | 
				eachIndex asRopedText foreground: Color gray ]
			width: 45;
		column: 'Item'
			text: [ :eachItem | eachItem gtDisplayText ];
		column: 'Comment'
			text: [ :eachItem | eachItem method comment ifNil: '' ];
			
		column: 'Execute' translated
			stencil: [ :each | 
		 
			  each method numArgs == 0 ifFalse: [ BlElement new ] ifTrue: [
				BrButton new
						aptitude: BrGlamorousButtonWithLabelTooltipAptitude2 + BrGlamorousButtonWithIconAptitude;
						icon: BrGlamorousVectorIcons playinspect;
						label: each method selector asString;
							beTinySize;
							action: [ :b | 
							
							(each method valueWithReceiver: each method methodClass soleInstance arguments:#())
								   ifNotNil: [ :result | b phlow spawnObject: result ]
								  
     ] ]]
			width: 50;
			
		 

		dynamicContextItems: [ :anElement :aCollection | 
			aCollection size = 1
				ifTrue: [ GtPhlowObjectContextMenuTarget
						menuItemsForObject: aCollection first
						hostElement: anElement ]
				ifFalse: [ GtPhlowObjectContextMenuTarget
						menuItemsForObject: aCollection
						hostElement: anElement ] ]
	

]
