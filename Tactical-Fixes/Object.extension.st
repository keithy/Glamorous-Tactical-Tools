Extension { #name : 'Object' }

{ #category : '*Tactical-Fixes' }
Object >> gtDisplayOn: stream [
	"This offers a means to customize how the object is shown in the GlamorousToolkit UI"
	^ self printOn: stream
]
