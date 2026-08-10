Class {
	#name : 'TTBareHub',
	#superclass : 'Object',
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'as yet unclassified' }
TTBareHub class >> browse [

	^ TheHub current newBrowsing: self
]
