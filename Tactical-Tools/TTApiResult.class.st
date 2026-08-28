Class {
	#name : 'TTApiResult',
	#superclass : 'TTResult',
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'as yet unclassified' }
TTApiResult >> error: aMessage [
	
	self stderrAppend: aMessage.

	^ super error: aMessage
]

{ #category : 'as yet unclassified' }
TTApiResult >> setRequest: aRequest [

	super setRequest: aRequest.
	handlers := aRequest askFor: #responseHandlers ifAbsent: nil.

	 
]

{ #category : 'as yet unclassified' }
TTApiResult >> statusVerify: status [
		
	"returning true/false allows for subclasses to override and add to the behaviour"
 
	(super statusVerify: status) ifTrue: [ ^ true ].
	
  status == 204 ifTrue: [ stdout := ''. stderr := '204 success, but no content' ].

	(#(200 201 202 204) includes: status) ifTrue: [ ^ true ].
	
	self error: self responseStatusMessage.
	"
	status == 400 ifTrue: [ self error: '400 Bad Request' ].
  status == 401 ifTrue: [ self error: '401 Bad Credentials' ].
	status == 403 ifTrue: [ self error: '403 Authorization Failed' ].
	status == 404 ifTrue: [ self error: '404 Not Found' ].
	status == 405 ifTrue: [ self error: '405 Method Not Allowed (was using ', request httpMethod, ')'  ].
	status == 409 ifTrue: [ self error: '409 Conflict'  ].
	status == 500 ifTrue: [ self error: '500 Server Error'  ].
	status == 501 ifTrue: [ self error: '501 Not Implemented'  ].
	status == 502 ifTrue: [ self error: '502 Bad Gateway'  ].
	status == 503 ifTrue: [ self error: '503 Service Unavailable'  ].
	status == 504 ifTrue: [ self error: '504 Gateway Timeout'  ].
	"
	^false
	

]

{ #category : 'as yet unclassified' }
TTApiResult >> stderrX [

	^ stderr ifNil: ''
]
