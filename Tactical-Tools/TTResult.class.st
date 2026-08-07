Class {
	#name : 'TTResult',
	#superclass : 'Object',
	#instVars : [
		'tool',
		'stdout',
		'output',
		'stderr',
		'request',
		'thePayload',
		'payloadReducers',
		'payloadTailReducers',
		'mappers',
		'mapped'
	],
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'as yet unclassified' }
TTResult >> apply: aFixer [

	aFixer applyTo: self
]

{ #category : 'as yet unclassified' }
TTResult >> getMapped [

  ^ mapped ifNil: [ 
  
			mapped := self inject: nil into: (mappers ifNil: #getMappingStart).
		] 
]

{ #category : 'as yet unclassified' }
TTResult >> getMappingStart [
 
   "do not be tempted to refactor this method away, may be customized by subclasses"
	 ^ self getPayload
]

{ #category : 'as yet unclassified' }
TTResult >> getOutput [

	output ifNil: [ output := request 
										ifNotNil: [ :req | req output ] 
										ifNil:    [ self error: 'what a to do' ] ].
	
	^ output 
]

{ #category : 'as yet unclassified' }
TTResult >> getPayload [

  ^ thePayload ifNil: [ 
  
			self payload: payloadTailReducers.
			thePayload := self inject: nil into: (payloadReducers ifNil: #getPayloadStart).
		].
	
 
]

{ #category : 'as yet unclassified' }
TTResult >> getPayloadStart [
 
   "do not be tempted to refactor this method away, may be customized by subclasses"
	 ^ self getStdout
]

{ #category : 'as yet unclassified' }
TTResult >> getStderr [

	stderr ifNil: [ stderr := output stderr ].
	
	^ stderr 
]

{ #category : 'as yet unclassified' }
TTResult >> getStdout [

	stdout ifNil: [ stdout := self getOutput stdout ].
	
	^ output 
]

{ #category : 'accessing' }
TTResult >> inject: batch into: actionBlockSymbolArrayOrNil [ 
	
	| action |
	
	action := actionBlockSymbolArrayOrNil.
	
	action ifNil: [ ^ batch ].
	
	action isSymbol ifTrue: [ ^ self perform: actionBlockSymbolArrayOrNil withEnoughArguments: { batch } ].
	
	action isBlock ifTrue: [ ^ action cull: batch cull: self ].

	action isArray ifTrue: [ ^ action inject: batch into: [ :out :each | self inject: out into: each ] ].
	
	self error: 'someone did not plan for this option'
	

]

{ #category : 'as yet unclassified' }
TTResult >> mapEachIntoCollection: aCollection [

	"for paged data this can be called several times to fll up a results array"
	aCollection ifNil: [ ^ self ].
	"
	self client adopt: aCollection.
	"
	aCollection isArray ifTrue: [  

		self mapping: [ :paylArray | aCollection copyWithAll: paylArray ]. 
			
	] ifFalse: [  
	
		self mapping: [ :paylArray | aCollection copy addAll: paylArray; yourself ]. 
	].
]

{ #category : 'as yet unclassified' }
TTResult >> mapEachToModel: aModelPrototype [
	
	"the accepting method is rawData: for Models"
	"(could it be more generic #wrapping:/#wrap)"
	
	self mapping: [ :paylArray | paylArray collect: [ :each | aModelPrototype copy rawData: each; yourself ] ]
]

{ #category : 'as yet unclassified' }
TTResult >> mapTo: aCollection [

	aCollection ifNil: [ ^ self ].
	"
	self client adopt: aCollection.
	"
	
	aCollection isArray ifTrue: [  

		self mapping: [ :payl | aCollection copyWithAll: payl ]	.
			
	] ifFalse: [  
	
		self mapping: [ :payl | aCollection copy addAll: payl; yourself ]
	].
]

{ #category : 'as yet unclassified' }
TTResult >> mapTo: aModelCollectionPrototype as: aCollection of: aModelPrototype [

  "adoptedBy: is the reversal of #adopt"
	self mapEachToModel: (aModelPrototype adoptedBy: aModelCollectionPrototype   ).
	self mapEachIntoCollection: aCollection.
	self mapEachIntoCollection: aModelCollectionPrototype.
	
]

{ #category : 'as yet unclassified' }
TTResult >> mapTo: aModelCollectionPrototype of: aModelPrototype [

	self mapTo: aModelCollectionPrototype as: nil "no change" of: aModelPrototype

]

{ #category : 'as yet unclassified' }
TTResult >> mapping: actionBlockSymbolArrayOrNil [

			actionBlockSymbolArrayOrNil ifNil: [ ^ self ].
      mappers ifNil: [ mappers := OrderedCollection with: #getMappingStart ].
      mappers add: actionBlockSymbolArrayOrNil
]

{ #category : 'as yet unclassified' }
TTResult >> payload: actionBlockSymbolArrayOrNil [
 
 		 actionBlockSymbolArrayOrNil ifNil: [ ^ self ].
      payloadReducers ifNil: [ payloadReducers := OrderedCollection with: #getPayloadStart ].
      payloadReducers add: actionBlockSymbolArrayOrNil
]

{ #category : 'as yet unclassified' }
TTResult >> payloadAssociationsSelect: selectBlock andModify: modifyBlock [
	self
		payloadDo: [ :record | 
			record
				associationsDo: [ :assoc | 
					(selectBlock value: assoc)
						ifTrue: [ record at: assoc key put: (modifyBlock value: assoc value) ] 		.
				].
		]
]

{ #category : 'as yet unclassified' }
TTResult >> payloadDo: aBlock [
		
	"scan through record, or array of dicionaries of associations"
	
	self payload: [ :payl | 
			
		(payl isDictionary 
				ifTrue: [ Array with: payl ] 
				ifFalse: [ payl ]) do: aBlock.
		
		payl
	]
		
		
]

{ #category : 'as yet unclassified' }
TTResult >> payloadFixDateFields: keys [
	
	self payloadAssociationsSelect: [ :assoc | keys includes: assoc key ] andModify: [ :v | v asDate ]
	
]

{ #category : 'as yet unclassified' }
TTResult >> payloadFixDateFieldsAuto [
		
	self payloadAssociationsSelect: [ :assoc  | (#(name) includes: assoc key) not ] andModify: [ :v | [ v asDate  ] ifErrorDo: [ v ] ]
]

{ #category : 'as yet unclassified' }
TTResult >> payloadFixUnixEpochFieldsSelect: aBlock [

	self payloadAssociationsSelect: [ :assoc |  aBlock value: assoc key ] andModify: [  :v | TheHub unixMillisToDate: v ] 
	
]

{ #category : 'as yet unclassified' }
TTResult >> payloadTail: actionBlockSymbolArrayOrNil [

			actionBlockSymbolArrayOrNil ifNil: [ ^ self ].
      payloadTailReducers ifNil: [ payloadTailReducers := OrderedCollection new ].
      payloadTailReducers add: actionBlockSymbolArrayOrNil
]

{ #category : 'accessing' }
TTResult >> request [
	^ request
]

{ #category : 'accessing' }
TTResult >> request: anObject [
	request := anObject
]
