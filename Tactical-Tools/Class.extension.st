Extension { #name : 'Class' }

{ #category : '*Tactical-Tools' }
Class class >> / aStringable [

	"#class:/ #Person "

	^ (#class://aStringable ) new 
]

{ #category : '*Tactical-Tools' }
Class >> / this [

	^ (TTHoldem newStart: this) applySlashTo: self
]

{ #category : '*Tactical-Tools' }
Class class >> // aClassNameOrClass [
	"Class // . aka double dispatch"

	^ Hub current startDoubleSlashFromClassClass: self with: aClassNameOrClass
]
