Extension { #name : 'BlElement' }

{ #category : '*Tactical-Fixes' }
BlElement class >> newEmpty [
	"Create a new element that is invisible and does not participate in layout,
	taking effectively no space. Useful as a null/placeholder element in
	layouts such as lists where `BlElement new` would still reserve space."

	^ self new
		visibility: BlVisibility gone;
		yourself
]
