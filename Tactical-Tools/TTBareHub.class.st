Class {
	#name : 'TTBareHub',
	#superclass : 'Object',
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'as yet unclassified' }
TTBareHub class >> openBrowser [

	^ TheHub current newBrowsing: self
]
