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
TTResultAbstract class >> isAbstract [

	^ self == TTResultAbstract
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> apply: aBoltOn [

	aBoltOn applyTo: self
]

{ #category : 'accessing' }
TTResultAbstract >> client [
	"Have removed the need for an instance slot for client/parent
	 assuming that we always have a request, 
	 this may not be the case"
	^ request client
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> getContents [
	^ self getOutput stdout
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> getOutput [

	output ifNotNil: [ ^ output ].
	
	output := request output.
		
	self statusVerify ifFalse: [ self error: 'Unhandled Exit Status' ].  

	^ output 
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> getStderr [

	stderr := self getOutput stderr.
	
	^ stderr 
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> getStdout [
	stdout ifNotNil: [ ^ stdout ].

	stdout := [ [ self getContents ]
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
  request setResult: self.
	 
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
