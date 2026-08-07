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
		'mapped',
		'formatted',
		'formatters',
		'parsed',
		'parsers'
	],
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'as yet unclassified' }
TTResult >> apply: aBoltOn [

	aBoltOn applyTo: self
]

{ #category : 'as yet unclassified' }
TTResult >> format: actionBlockSymbolArrayOrNil [
 
 		 actionBlockSymbolArrayOrNil ifNil: [ ^ self ].
      formatters ifNil: [ formatters := OrderedCollection with: #getFormatStart ].
      formatters add: actionBlockSymbolArrayOrNil
]

{ #category : 'as yet unclassified' }
TTResult >> getFormatStart [
 
   "do not be tempted to refactor this method away, may be customized by subclasses"
	 ^ self getMapped
]

{ #category : 'as yet unclassified' }
TTResult >> getFormatted [

  ^ formatted ifNil: [ 
  
			formatted := self inject: nil into: (formatters ifNil: #getFormatStart).
		] 
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
TTResult >> getParsingInput [
 
   "do not be tempted to refactor this method away, may be customized by subclasses"
	 ^ self getStdout
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

	stderr ifNil: [ stderr := self getOutput stderr ].
	
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
      mappers ifNil: [ mappers := OrderedCollection with: #getMappingStart ].
      mappers add: actionBlockSymbolArrayOrNil
]

{ #category : 'as yet unclassified' }
TTResult >> parser: actionBlockSymbolArrayOrNil [

			actionBlockSymbolArrayOrNil ifNil: [ ^ self ].
      parsers ifNil: [ parsers := OrderedCollection with: #getParsingInput ].
      parsers add: actionBlockSymbolArrayOrNil
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
