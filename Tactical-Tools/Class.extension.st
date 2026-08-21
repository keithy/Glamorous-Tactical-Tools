Extension { #name : 'Class' }

{ #category : '*Tactical-Tools' }
Class class >> // aClassNameOrClass [
	"Class // . aka double dispatch"

	^ Hub current startDoubleSlashFromClassClass: self with: aClassNameOrClass
]
