Class {
	#name : 'TTMapToModel',
	#superclass : 'TTResultBoltOn',
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'as yet unclassified' }
TTMapToModel class >> mapEachIntoCollection: aCollection [
	^ self newFromMessage: thisContext
]

{ #category : 'as yet unclassified' }
TTMapToModel class >> mapEachToModel: aModelPrototype [
		^ self newFromMessage: thisContext
]

{ #category : 'as yet unclassified' }
TTMapToModel class >> mapTo: aCollection [
	^ self newFromMessage: thisContext
]

{ #category : 'as yet unclassified' }
TTMapToModel class >> mapTo: aModelCollectionPrototype as: aCollection of: aModelPrototype [

	^ self newFromMessage: thisContext
]

{ #category : 'as yet unclassified' }
TTMapToModel class >> mapTo: aModelCollectionPrototype of: aModelPrototype [

	^ self newFromMessage: thisContext
]

{ #category : 'as yet unclassified' }
TTMapToModel >> mapEachIntoCollection: aCollection [

	aCollection ifNil: [ ^ self ].
	"
	self client adopt: aCollection.
	"
	
	aCollection isArray ifTrue: [  

		result mapping: [ :payl | aCollection copyWithAll: payl ]	.
			
	] ifFalse: [  
	
		result mapping: [ :payl | aCollection copy addAll: payl; yourself ]
	].
]

{ #category : 'as yet unclassified' }
TTMapToModel >> mapEachToModel: aModelPrototype [
	
	"the accepting method is rawData: for Models"
	"(could it be more generic #wrapping:/#wrap)"
	
	result mapping: [ :paylArray | paylArray collect: [ :each | aModelPrototype copy rawData: each; yourself ] ]
]

{ #category : 'as yet unclassified' }
TTMapToModel >> mapTo: aCollection [

	aCollection ifNil: [ ^ self ].
	"
	self client adopt: aCollection.
	"
	
	aCollection isArray ifTrue: [  

		result mapping: [ :payl | aCollection copyWithAll: payl ]	.
			
	] ifFalse: [  
	
		result mapping: [ :payl | aCollection copy addAll: payl; yourself ]
	].
]

{ #category : 'as yet unclassified' }
TTMapToModel >> mapTo: aModelCollectionPrototype as: aCollection of: aModelPrototype [

  "adoptedBy: is the reversal of #adopt"
	self mapEachToModel: (aModelPrototype adoptedBy: aModelCollectionPrototype   ).
	self mapEachIntoCollection: aCollection.
	self mapEachIntoCollection: aModelCollectionPrototype.
	
]

{ #category : 'as yet unclassified' }
TTMapToModel >> mapTo: aModelCollectionPrototype of: aModelPrototype [

	self mapTo: aModelCollectionPrototype as: nil "no change" of: aModelPrototype

]
