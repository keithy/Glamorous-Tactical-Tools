Extension { #name : 'File' }

{ #category : '*Tactical-Tools' }
File class >> // aClassNameOrClassOrOrigin [ 

	"File // . aka double dispatch"
	^ Hub startDoubleDispatchFromFileClass: self with:  aClassNameOrClassOrOrigin
]

{ #category : '*Tactical-Tools' }
File >> basename [
	^self name
]
