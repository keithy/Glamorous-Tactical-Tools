Extension { #name : 'False' }

{ #category : '*Tactical-Raw' }
False >> or: alternativeBlock [
	"Nonevaluating disjunction -- answer value of alternativeBlock."
	"(false or: [true]) >>> true"
	"(false or: [3]) >>> 3"

	^alternativeBlock value
]
