Class {
	#name : 'TTResultAbstract',
	#superclass : 'Object',
	#instVars : [
		'request',
		'stdout',
		'stderr',
		'output',
		'handlers'
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
TTResultAbstract class >> fromSRL: anSRL [
	^ anSRL getOutputProvider getResult

  
]

{ #category : 'as yet unclassified' }
TTResultAbstract class >> isAbstract [

	^ self == TTResultAbstract
]

{ #category : 'as yet unclassified' }
TTResultAbstract class >> newFromSRL: anSRL [
	^ anSRL output getResult

  
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> apply: aBoltOn [

	aBoltOn applyTo: self
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> asDictionary [
  "convenience - replace with better"
	^ STONJSON fromString: self getStdout
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> asString [
  "convenience - replace with better"
	^ self getStdOut
]

{ #category : 'accessing' }
TTResultAbstract >> client [
	"Have removed the need for an instance slot for client/parent
	 assuming that we always have a request, 
	 this may not be the case"
	^ request client
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> getOutputProvider [

	output ifNotNil: [ ^ output ].
	
	output := request output.

	^ output 
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> getRawContents [
	"likely coming from a executables 'output'"
	^ self getOutputProvider stdout
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> getStderr [

	stderr := self getOutputProvider stderr.
	
	^ stderr 
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> getVerifiedContents [
	stdout ifNotNil: [ ^ stdout ].

	stdout := [ [ self getRawContents ]
			onErrorDo: [ :ex | 
				self stderrAppend: ex messageText.
				ex pass ] ] onErrorDo: self client requestErrorHandler.

	^ stdout
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

{ #category : 'accessing' }
TTResultAbstract >> setRequest: aRequest [

	request := aRequest.	

]

{ #category : 'as yet unclassified' }
TTResultAbstract >> status [ 

	^ output ifNotNil: [ :out | [ out status code ] ifError: [ nil ] ]
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
TTResultAbstract >> stderrAppend: aMessage [
	 
	 stderr := String streamContents: 
	 
	 	[ :str | (str << (stderr ifNil: '') << aMessage) cr ]
]
