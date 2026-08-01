Extension { #name : 'GtPhlowProtoView' }

{ #category : '*Tactical-Tools' }
GtPhlowProtoView >> gtSoon: aBlock ifPending: initial ifError: errBlock [

	<ttExtension>
	
	^ [ :ea |  
	
	BrFromFuture new
		fitContent;
		future: [ aBlock value: ea ]
			initialValue: initial;
		stencil: [ BrLabel new
			aptitude: BrGlamorousLabelAptitude ];
		dataBinder: [ :aLabel :aDataSnapshot |
			aDataSnapshot
				ifSuccess: [ :aName | aLabel text: aName asString ]
				ifError: [ :anError | 
					
					| errText |
					
					errBlock isString ifTrue: [ errText := errBlock ].
 					errBlock ifNil: [ errText := anError description ].
					errBlock isBlock ifTrue: [ errText := errBlock value: anError ].
					
					aLabel text: (errText asRopedText foreground: Color red).
				]
				ifPending: [ :anInitialValue | aLabel text: anInitialValue ] ]
	] 
]
