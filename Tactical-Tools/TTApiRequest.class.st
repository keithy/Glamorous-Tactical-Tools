Class {
	#name : 'TTApiRequest',
	#superclass : 'TTRequestAbstract',
	#instVars : [
		'scheme',
		'url',
		'httpClient'
	],
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'factory' }
TTApiRequest class >> makeHttpClientForScheme: aScheme [

	"used in #initialize"
	
	^ TTSchemeRouter newForScheme: (aScheme ifNil: 'none').
 
]

{ #category : 'construction' }
TTApiRequest >> , appendage [
	
	appendage ifNil: [ ^ self ].

	url := url , appendage asString
]

{ #category : 'construction' }
TTApiRequest >> / aPath [
	
	| path |
	
	aPath ifNil: [ ^ self ].
	
	path := aPath asString.
	
	url := (path first = $/) ifTrue: [ url, path ] ifFalse: [ url, '/' , path ].
	
	^ self
]

{ #category : 'construction' }
TTApiRequest >> // uri [
	
	(self setUri: uri) begin
	
	
]

{ #category : 'as yet unclassified' }
TTApiRequest >> asDictionary [
  "convenience - replace with better"
	^ STONJSON fromString: self responseContentsVerified
]

{ #category : 'as yet unclassified' }
TTApiRequest >> asString [
  "convenience - replace with better"
	^ self getStdOut
]

{ #category : 'as yet unclassified' }
TTApiRequest >> begin [

  httpClient := self class makeHttpClientForScheme: scheme.
  
  httpClient url: self fullUrl.
  
	super begin
]

{ #category : 'accessing' }
TTApiRequest >> fullUrl [

	^ String streamContents: [ :stream | stream << scheme << ':' << url ]
			
		 	
]

{ #category : 'accessing' }
TTApiRequest >> isGET [

	^ self type == #GET
]

{ #category : 'as yet unclassified' }
TTApiRequest >> outputProvider [

	self response ifNil: [ self notify send response ].
	
	^ self
]

{ #category : 'accessing' }
TTApiRequest >> prepare [

	httpClient url: self fullUrl.
	
	httpClient isHttpClient ifTrue: [
		
		client prepareRequest: self.
		
		httpClient method: self type.
		
		self isGET	
			ifTrue: [ httpClient queryAddAll: self parameters ]
	  	ifFalse: [ self prepareQuery ].
	].
]

{ #category : 'accessing' }
TTApiRequest >> prepareQuery [
]

{ #category : 'accessing' }
TTApiRequest >> response [

	^ httpClient response
	

]

{ #category : 'as yet unclassified' }
TTApiRequest >> responseContents [

	^ self response contents
]

{ #category : 'as yet unclassified' }
TTApiRequest >> responseContentsVerified [
  "thin client only, we are our own result"
	^ self responseContents
]

{ #category : 'accessing' }
TTApiRequest >> send [

	self prepare.
 
	httpClient execute.
	
	^ self
]

{ #category : 'initialization' }
TTApiRequest >> setScheme: httpEtc [

	scheme := httpEtc
]

{ #category : 'accessing' }
TTApiRequest >> setUri: aUri [
	
	"explicitly set both on initialization"
	
	scheme := aUri copyUpTo: $:.
	url := aUri copyAfter: $:
]

{ #category : 'accessing' }
TTApiRequest >> stderr [

	^ self outputProvider responseStatus

]

{ #category : 'accessing' }
TTApiRequest >> stdout [

	^ self outputProvider responseContentsVerified

]

{ #category : 'as yet unclassified' }
TTApiRequest >> timeout: n [
	httpClient timeout: n
]

{ #category : 'accessing' }
TTApiRequest >> type [
	
		^ type ifNil: [ type := #GET ]
]

{ #category : 'accessing' }
TTApiRequest >> use: aType [

	type := aType.
	
	^ self getResult
]

{ #category : 'accessing' }
TTApiRequest >> useDELETE [

	^ (self use: #DELETE) getResult
]

{ #category : 'accessing' }
TTApiRequest >> useGET [

		^ self use: #GET
]

{ #category : 'accessing' }
TTApiRequest >> usePATCH [

		^ (self use: #PATCH) getResult
]

{ #category : 'accessing' }
TTApiRequest >> usePOST [

		^ (self use: #POST) getResult
]

{ #category : 'accessing' }
TTApiRequest >> usePUT [

		^ (self use: #PUT) getResult
]

{ #category : 'as yet unclassified' }
TTApiRequest >> verifiedContents [
	"likely coming from a ZnResponse"
	"thin client only"
	^ self responseContents
]

{ #category : 'accessing' }
TTApiRequest >> withText: aText [
	
  super withText: aText.
	httpClient contents: text. 
	
	^ text
]
