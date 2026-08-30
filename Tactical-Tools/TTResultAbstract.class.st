Class {
	#name : 'TTResultAbstract',
	#superclass : 'Object',
	#instVars : [
		'request',
		'stdout',
		'stderr',
		'handlers',
		'inputProvider'
	],
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'as yet unclassified' }
TTResultAbstract class >> // anSRL [

	^ self newFromSRL: anSRL
]

{ #category : 'as yet unclassified' }
TTResultAbstract class >> configureDefault: aResult [

	^ aResult apply: TTToolOutputParser parseAsSTON
]

{ #category : 'as yet unclassified' }
TTResultAbstract class >> fromSRL: anSRL [
	^ anSRL getOutputProvider getResult

  
]

{ #category : 'as yet unclassified' }
TTResultAbstract class >> isAbstract [

	^ self == TTResultAbstract
]

{ #category : 'as yet unclassified' }
TTResultAbstract class >> newForRequest: request [

	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
TTResultAbstract class >> newFromSRL: anSRL [

	"if we ask the srl we get a result class 
	 from the request's nominated client"

	^ self newForRequest:anSRL 
	
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> apply: aBoltOn [

	aBoltOn applyTo: self.
	
	^ self
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> asDictionary [
  "convenience - replace with better"
	^ STONJSON fromString: self output
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> asString [
  "convenience - replace with better"
	^ self output
]

{ #category : 'accessing' }
TTResultAbstract >> client [
	"Have removed the need for an instance slot for client/parent
	 assuming that we always have a request, 
	 this may not be the case"
	^ request client
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> gtRawFor: aView [
	<gtView>
	^ self ttTheme viewRawOn: self for: aView
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> gtTreeFor: aView [

 <gtView>
 
	^ aView forward
		  title: 'Chain';
		  priority: 51;
		  object: [ self gtViewData asOrderedDictionary];
		  view: #gtTreeFor:context:
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> gtViewData [

	^ { #class -> self className. } 
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> gtViewFor: aView [
	<gtView>
	
	^ (self gtViewItems:[ self gtViewData ] for: aView)
		title: 'View';
		priority: 60;
		yourself
		
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> gtViewItems: itemsBlock for: aView [
	^ aView columnedTree
		items: itemsBlock;
		in: [ :view | 
			view
				children: [ :each | 
					each value isDictionary
						ifTrue: [ each value associations ]
						ifFalse: [ each value collectWithIndex: [ :x :i | i -> x ] ] ] ];
		column: 'Property'
			text: #key
			width: 180;
		column: 'Value' text: [ :assoc | [ assoc value ] ifError: [ '-na-' ] ];
		send: [ :each | self gtViewOnClickAt: each key value: each value ];
		column: 'Actions' translated
			stencil: [ :each | 
				each value isBlock
					ifFalse: [ BlElement new size: 0 @ 0 ]
					ifTrue: [ BrButton new
							aptitude: BrGlamorousButtonWithLabelTooltipAptitude + BrGlamorousButtonWithIconAptitude;
							icon: BrGlamorousVectorIcons play;
							label: 'Do It';
							beTinySize;
							action: [ :b | 
								each value value.
								b phlow fireToolUpdateWish ] ] ]
			width: 50;
		yourself
]

{ #category : 'accessing' }
TTResultAbstract >> handler: aHandler [

	handlers := self handlers copyWith: aHandler
]

{ #category : 'accessing' }
TTResultAbstract >> handlers [

	^ handlers ifNil: #()
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> initialize [

	stdout := nil.
	stderr := nil.
	inputProvider := nil.
	
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> inputProvider [

	inputProvider ifNotNil: [ ^ inputProvider ].
	
	inputProvider := request outputProvider.
	
	self statusVerify ifFalse: [ self error: 'Unhandled API Error' ].  
	
	^ inputProvider
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> output [

	^ self responseContentsVerified
]

{ #category : 'accessing' }
TTResultAbstract >> parent [
	"Have removed the need for an instance slot for client/parent
	 assuming that we always have a request, 
	 this may not be the case"
	^ request client
]

{ #category : 'accessing' }
TTResultAbstract >> request [
	^ request
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> requestDict: aDict [
	
	"for readability the input may be an array of associations"
	
	request withDict: aDict
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> requestErrorHandler [

	 ^ request askFor: #requestErrorHandler ifAbsent: nil
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> requestSTON: jsonable [

	request withSTON: jsonable.
		
	^ self
	
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> requestText: text [

	request withText: text.
		
	^ self
	
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> requestUsing: aBlock [

	aBlock value: request.
	
	^ self
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> reset [
	"convenience abbreviation."
	request reset.
	self resetOutputChain

]

{ #category : 'as yet unclassified' }
TTResultAbstract >> resetOutputChain [

inputProvider := nil.
stdout := nil.
stderr := nil.

]

{ #category : 'as yet unclassified' }
TTResultAbstract >> responseContents [
	"likely coming from a executables 'output'"
	^ self inputProvider responseContents
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> responseContentsVerified [
	stdout ifNotNil: [ ^ stdout ].

	stdout := [ [ self responseContents ]
			onErrorDo: [ :ex | 
				self stderrAppend: ex messageText.
				ex pass ] ] onErrorDo:[ :ex | self requestErrorHandler ifNil: [ ex pass ] ].

	^ stdout
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> responseStatusCode [

	^ inputProvider ifNotNil: [ inputProvider responseStatusCode ]
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> responseStatusMessage [

	 ^  inputProvider ifNotNil: [ inputProvider responseStatusMessage ]  
]

{ #category : 'accessing' }
TTResultAbstract >> setRequest: aRequest [

	request := aRequest.	

]

{ #category : 'as yet unclassified' }
TTResultAbstract >> statusVerify [
	^ self statusVerify: self responseStatusCode
]

{ #category : 'accessing' }
TTResultAbstract >> statusVerify: status [
	(self handlers anySatisfy: [ :handler | handler value: self value: status ])
		ifTrue: [ ^ true ].	"handled"

	^ status == 0
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> stderr [

	^ stderr := (self inputProvider stderr) ifNil: ''
	

]

{ #category : 'as yet unclassified' }
TTResultAbstract >> stderrAppend: aMessage [
	 
	 stderr := String streamContents: 
	 
	 	[ :str | (str << (stderr ifNil: '') << aMessage) cr ]
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> stdout [
	"likely coming from a executables 'output'"
	^ self outputProvider stdout
]
