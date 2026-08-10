Extension { #name : 'Notification' }

{ #category : '*Tactical-Tools' }
Notification class >> collectDuring: aBlock [

	"Debugging pattern"

  <ttWall>
 
	| list |
	
	list := OrderedCollection new.
	
	aBlock on: self do: [ :ex | list add: ex. ex pass ].

	^ list asArray
]
