Extension { #name : 'File' }

{ #category : '*Tactical-Tools' }
File class >> // anOriginClassOrString [ 

	"File // . aka double dispatch"
	^ Hub startDoubleDispatchFromFileClass: self with:  anOriginClassOrString
]

{ #category : '*Tactical-Tools' }
File >> basename [
	^self name
]
