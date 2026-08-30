Extension { #name : 'Set' }

{ #category : '*Tactical-Raw' }
Set >> add: newObject [
	"Include newObject as one of the receiver's elements, but only if
	not already present. Answer newObject."

	| index |
	index := self scanFor: newObject.
	(array at: index) ifNil: [self atNewIndex: index put: newObject asCollectionElement].
	^ newObject
]

{ #category : '*Tactical-Raw' }
Set >> ttType [

	^ #set
]
