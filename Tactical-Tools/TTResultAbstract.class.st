Class {
	#name : 'TTResultAbstract',
	#superclass : 'Object',
	#instVars : [
		'request',
		'stdout',
		'stderr',
		'handlers',
		'outputProvider'
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

^ aResult 
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
	"Each result-request pair represents an atomic query.
	
	Each result-request pair keeps a reference to the client, so that it is
	easy to make further api calls of its own"

	^ self
		configureDefault: (self basicNew
				setRequest: request;
				initialize)
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
	^ STONJSON fromString: self verifiedContents
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> asString [
  "convenience - replace with better"
	^ self verifiedContents
]

{ #category : 'accessing' }
TTResultAbstract >> client [
	"Have removed the need for an instance slot for client/parent
	 assuming that we always have a request, 
	 this may not be the case"
	^ request client
]

{ #category : 'accessing' }
TTResultAbstract >> handlers [

	^ handlers ifNil: [ handlers := IdentityDictionary new ]
]

{ #category : 'accessing' }
TTResultAbstract >> handlersGoodStatus: status [

	self handlersOnStatus: status do: [ true ]
]

{ #category : 'accessing' }
TTResultAbstract >> handlersOnStatus: sStatus do: aBlockReturningBool [

	self handlers at: sStatus put: aBlockReturningBool
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> initialize [

	stdout := nil.
	stderr := nil.
	outputProvider := nil.
	
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> outputProvider [

	outputProvider ifNotNil: [ ^ outputProvider ].
	
	outputProvider := request outputProvider.

	^ outputProvider 
]

{ #category : 'accessing' }
TTResultAbstract >> parent [
	"Have removed the need for an instance slot for client/parent
	 assuming that we always have a request, 
	 this may not be the case"
	^ request client
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> rawContents [
	"likely coming from a executables 'output'"
	^ self outputProvider stdout
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
	self resetOutputChain

]

{ #category : 'as yet unclassified' }
TTResultAbstract >> resetOutputChain [

stdout := nil.
stderr := nil.

]

{ #category : 'accessing' }
TTResultAbstract >> setRequest: aRequest [

	request := aRequest.	

]

{ #category : 'as yet unclassified' }
TTResultAbstract >> status [ 

	^ outputProvider ifNotNil: [ :out | [ out status code ] ifError: [ nil ] ]
]

{ #category : 'accessing' }
TTResultAbstract >> statusVerify [
	
	handlers ifNotNil: [  
		handlers at: self status ifPresent: [ :handlerBlock |
	
		   (handlerBlock cull: self) ifTrue: [ ^ true ] "handled"
		]	
	].
	
	^ self status == 0


]

{ #category : 'as yet unclassified' }
TTResultAbstract >> stderr [

	stderr := self outputProvider stderr.
	
	^ stderr 
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

{ #category : 'as yet unclassified' }
TTResultAbstract >> verifiedContents [
	stdout ifNotNil: [ ^ stdout ].

	stdout := [ [ self rawContents ]
			onErrorDo: [ :ex | 
				self stderrAppend: ex messageText.
				ex pass ] ] onErrorDo: self request errorHandler.

	^ stdout
]
