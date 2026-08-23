Class {
	#name : 'TTResult',
	#superclass : 'TTResultAbstract',
	#instVars : [
		'thePayload',
		'formatted',
		'formatters',
		'mapped',
		'mappers',
		'payloadTailReducers',
		'payloadReducers',
		'parsers'
	],
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'as yet unclassified' }
TTResult >> format: actionBlockSymbolArrayOrNil [

	"synonym"
	self formatting: actionBlockSymbolArrayOrNil
]

{ #category : 'as yet unclassified' }
TTResult >> formatting: actionBlockSymbolArrayOrNil [
 
 		 actionBlockSymbolArrayOrNil ifNil: [ ^ self ].
      formatters ifNil: [ formatters := Array with: #getFormatStart ].
      formatters := formatters copyWith: actionBlockSymbolArrayOrNil
]

{ #category : 'as yet unclassified' }
TTResult >> getFormatStart [
 
   "do not be tempted to refactor this method away, 
    it may be customized by subclasses"
   
	 ^ self getMapped
]

{ #category : 'as yet unclassified' }
TTResult >> getFormatted [

  formatted ifNil: [ ^ formatted ].
  
	formatted := self inject: nil into: (formatters ifNil: #getFormatStart).
	
	^ formatted 
]

{ #category : 'as yet unclassified' }
TTResult >> getMapped [

  mapped ifNotNil: [ ^ mapped ]. 
  
	mapped := self inject: nil into: (mappers ifNil: #getMappingInput).
	
	^ mapped
]

{ #category : 'as yet unclassified' }
TTResult >> getMappingInput [
 
   "do not be tempted to refactor this method away, 
    it may be customized by subclasses"

   ^ self getPayload
]

{ #category : 'as yet unclassified' }
TTResult >> getParsingInput [
 
   "do not be tempted to refactor this method away, 
    it may be customized by subclasses"

  ^ self getVerifiedContents
]

{ #category : 'as yet unclassified' }
TTResult >> getPayload [

	thePayload ifNotNil: [ ^ thePayload ].
  
	self payload: payloadTailReducers.
	thePayload := self inject: nil into: (payloadReducers ifNil: #getPayloadStart).
	
 ^ thePayload
]

{ #category : 'as yet unclassified' }
TTResult >> getPayloadStart [
 
   "do not be tempted to refactor this method away, 
    it may be customized by subclasses"

   ^ self getVerifiedContents
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
TTResult >> map: actionBlockSymbolArrayOrNil [

	"synonym"
	self mapping: actionBlockSymbolArrayOrNil
]

{ #category : 'as yet unclassified' }
TTResult >> mapTo: aModelCollectionPrototype of: aModelPrototype [

	self mapTo: aModelCollectionPrototype as: nil "no change" of: aModelPrototype

]

{ #category : 'as yet unclassified' }
TTResult >> mapping: actionBlockSymbolArrayOrNil [

			actionBlockSymbolArrayOrNil ifNil: [ ^ self ].
      mappers ifNil: [ mappers := Array with: #getMappingInput ].
      mappers := mappers copyWith: actionBlockSymbolArrayOrNil
]

{ #category : 'as yet unclassified' }
TTResult >> parse: actionBlockSymbolArrayOrNil [

	"synonym"
	self parsing: actionBlockSymbolArrayOrNil
]

{ #category : 'as yet unclassified' }
TTResult >> parsing: actionBlockSymbolArrayOrNil [

			actionBlockSymbolArrayOrNil ifNil: [ ^ self ].
      parsers ifNil: [ parsers := Array with: #getParsingInput ].
      parsers := parsers copyWith: actionBlockSymbolArrayOrNil
]

{ #category : 'as yet unclassified' }
TTResult >> payload: actionBlockSymbolArrayOrNil [
 
 		 actionBlockSymbolArrayOrNil ifNil: [ ^ self ].
      payloadReducers ifNil: [ payloadReducers := Array with: #getPayloadStart ].
      payloadReducers := payloadReducers copyWith: actionBlockSymbolArrayOrNil
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
TTResult >> payloadFinalize: actionBlockSymbolArrayOrNil [

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
