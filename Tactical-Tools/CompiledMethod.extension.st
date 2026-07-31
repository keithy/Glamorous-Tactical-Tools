Extension { #name : 'CompiledMethod' }

{ #category : '*Tactical-Tools' }
CompiledMethod class >> ttItemsWithActionFor: aView context: theContext [
	<ttViewInCollection>
	
		^ aView columnedList
		title: 'Executable';
		priority: 5;
		items: [ theContext optionAt: #theCollection ifAbsent: #() ] ;
		actionUpdateButtonTooltip: 'Update item list';
		column: '#' 
			text: [ :eachItem :eachIndex | 
				eachIndex asRopedText foreground: Color gray ]
			width: 45;
		column: 'Item'
			text: [ :eachItem | eachItem gtDisplayText ];
			
		column: 'Execute' translated
			stencil: [ :each | 
			
			  each numArgs == 0 ifFalse: [ BlElement new ] ifTrue: [
				BrButton new
						aptitude: BrGlamorousButtonWithLabelTooltipAptitude2 + BrGlamorousButtonWithIconAptitude;
						icon: BrGlamorousVectorIcons playinspect;
						label: each selector asString;
							beTinySize;
							action: [ :b | 
									(each valueWithReceiver: each methodClass soleInstance arguments:#())
								   ifNotNil: [ :result | b phlow spawnObject: result ]
								  
							
     ] ]]
			width: 50.
	

]
