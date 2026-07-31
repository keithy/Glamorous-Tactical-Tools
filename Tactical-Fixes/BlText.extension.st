Extension { #name : 'BlText' }

{ #category : '*Tactical-Fixes' }
BlText >> << aText [
	self append: aText asRopedText
]

{ #category : '*Tactical-Fixes' }
BlText >> space [
	self << ' '
]
