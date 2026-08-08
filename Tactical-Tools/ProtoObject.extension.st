Extension { #name : 'ProtoObject' }

{ #category : '*Tactical-Tools' }
ProtoObject >> askFor: selector ifNo: aBlock [

	<ttExtension>
	
	"Friend of #askFor:"

	^ (self respondsTo: selector) ifTrue: [ self perform: selector  ] ifFalse: aBlock
]
