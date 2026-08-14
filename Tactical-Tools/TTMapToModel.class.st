Class {
	#name : 'TTMapToModel',
	#superclass : 'TTResultTalent',
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'as yet unclassified' }
TTMapToModel >> mapEachIntoCollection: aCollection [

	"for paged data this can be called several times to fll up a results array"
	aCollection ifNil: [ ^ self ].
	"
	self client adopt: aCollection.
	"
	aCollection isArray ifTrue: [  

		result mapping: [ :paylArray | aCollection copyWithAll: paylArray ]. 
			
	] ifFalse: [  
	
		result mapping: [ :paylArray | aCollection copy addAll: paylArray; yourself ]. 
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
