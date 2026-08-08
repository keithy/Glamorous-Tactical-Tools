Extension { #name : 'Object' }

{ #category : '*Tactical-Tools' }
Object >> askFor: selector [

	<ttExtension>

	"Intended to reduce the proliferation of isMethods into Object - credit Dave Simmons"

	^ (self respondsTo: selector) ifTrue: [ self perform: selector  ] ifFalse: [ false ]
]

{ #category : '*Tactical-Tools' }
Object >> askFor: selector ifAbsent: aBlock [

	<ttExtension>
	
	"Friend of #askFor:"

	^ (self respondsTo: selector) ifTrue: [ self perform: selector  ] ifFalse: aBlock
]
