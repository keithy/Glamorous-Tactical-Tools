Class {
	#name : 'TTResult',
	#superclass : 'TTResultAbstract',
	#instVars : [
		'formatted',
		'formatters',
		'mapped',
		'mappers',
		'payloadTailReducers',
		'payloadReducers',
		'parsers',
		'parsed',
		'payload'
	],
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'accessing' }
TTResult class >> configureDefault: aResult [
		aResult apply: TTToolOutputParser passAsString.
^ aResult 
]

{ #category : 'as yet unclassified' }
TTResult >> format: actionBlockSymbolArrayOrNil [

	"synonym"
	self formatting: actionBlockSymbolArrayOrNil
]

{ #category : 'as yet unclassified' }
TTResult >> formatted [

  formatted ifNotNil: [ ^ formatted ].
  
	formatted := self inject: nil into: (formatters ifNil: #formatStart).
	
	^ formatted 
]

{ #category : 'as yet unclassified' }
TTResult >> formatting: actionBlockSymbolArrayOrNil [
 
 		 actionBlockSymbolArrayOrNil ifNil: [ ^ self ].
      formatters ifNil: [ formatters := Array with: #formatStart ].
      formatters := formatters copyWith: actionBlockSymbolArrayOrNil
]

{ #category : 'as yet unclassified' }
TTResult >> initialize [
	
	super initialize.
	payloadReducers := nil.
	payloadTailReducers := nil.
	payload := nil.
  mappers := nil.	
  mapped := nil.
	formatters := nil.
	formatted := nil.
	self initializeParsers.
   
	
]

{ #category : 'as yet unclassified' }
TTResult >> initializeParsers [
	
	parsers := nil.
	parsed := nil.
   
	
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
TTResult >> mapped [

  mapped ifNotNil: [ ^ mapped ]. 
  
	mapped := self inject: nil into: (mappers ifNil: #getMappingInput).
	
	^ mapped
]

{ #category : 'as yet unclassified' }
TTResult >> mapping: actionBlockSymbolArrayOrNil [

			actionBlockSymbolArrayOrNil ifNil: [ ^ self ].
      mappers ifNil: [ mappers := Array with: #getMappingInput ].
      mappers := mappers copyWith: actionBlockSymbolArrayOrNil
]

{ #category : 'as yet unclassified' }
TTResult >> mappingInput [
 
   "do not be tempted to refactor this method away, 
    it may be customized by subclasses"

   ^ self payload
]

{ #category : 'as yet unclassified' }
TTResult >> output [

	^ self formatted 
]

{ #category : 'as yet unclassified' }
TTResult >> parse: actionBlockSymbolArrayOrNil [

	"synonym"
	self parsing: actionBlockSymbolArrayOrNil
]

{ #category : 'as yet unclassified' }
TTResult >> parsed [

	parsed ifNotNil: [ ^ parsed ].

	parsed := self inject: (self parsingInput) into: parsers .
	
 ^ parsed
]

{ #category : 'as yet unclassified' }
TTResult >> parsing: actionBlockSymbolArrayOrNil [

			actionBlockSymbolArrayOrNil ifNil: [ ^ self ].
      parsers ifNil: [ parsers := Array new ].
      parsers := parsers copyWith: actionBlockSymbolArrayOrNil
]

{ #category : 'as yet unclassified' }
TTResult >> parsingInput [
 
   "do not be tempted to refactor this method away, 
    it may be customized by subclasses"

  ^ self verifiedContents
]

{ #category : 'as yet unclassified' }
TTResult >> payload [

	payload ifNotNil: [ ^ payload ].
  
	self payload: payloadTailReducers.
	payload := self inject: (self payloadStart) into: payloadReducers.
	
 ^ payload
]

{ #category : 'as yet unclassified' }
TTResult >> payload: actionBlockSymbolArrayOrNil [
 
 		 actionBlockSymbolArrayOrNil ifNil: [ ^ self ].
      payloadReducers ifNil: [ payloadReducers := Array new ].
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
      payloadTailReducers ifNil: [ payloadTailReducers := Array new ].
      payloadTailReducers := payloadTailReducers copyWith: actionBlockSymbolArrayOrNil
]

{ #category : 'as yet unclassified' }
TTResult >> payloadStart [
 
   "do not be tempted to refactor this method away, 
    it may be customized by subclasses"

   ^ self getParsed
]

{ #category : 'accessing' }
TTResult >> request [
	^ request
]

{ #category : 'accessing' }
TTResult >> request: anObject [
	request := anObject
]

{ #category : 'as yet unclassified' }
TTResult >> resetOutputChain [

	super resetOutputChain.
	payload := nil.
	formatted := nil.
	mapped := nil.
]
