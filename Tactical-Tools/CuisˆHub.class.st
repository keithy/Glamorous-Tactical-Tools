Class {
	#name : 'CuisˆHub',
	#superclass : 'Hub',
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'as yet unclassified' }
CuisˆHub >> namespacedSearchPath [

	^ #(Cuis) copyWithAll: (super namespacedSearchPath)
]
