Extension { #name : 'Class' }

{ #category : '*Tactical-Tools' }
Class class >> * aStringable [

	"experiment"

	^ Hub getClass: aStringable
]

{ #category : '*Tactical-Tools' }
Class class >> ** aStringable [

	^ Hub getClass: aStringable
]

{ #category : '*Tactical-Tools' }
Class class >> / aStringable [

	"experiment"

	^ (Hub getClass: aStringable) new / aStringable
]

{ #category : '*Tactical-Tools' }
Class class >> // aStringable [

	"experiment"

	^ Hub getClass: aStringable
]
