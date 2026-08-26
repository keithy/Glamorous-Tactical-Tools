Class {
	#name : 'TTApiRequest',
	#superclass : 'TTRequestAbstract',
	#instVars : [
		'guzzler',
		'scheme',
		'url'
	],
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'factory' }
TTApiRequest class >> makeHttpClientForScheme: aScheme [

	"used in #initialize"
	
	^ (#class://#ˆGuzzler) newForScheme: (aScheme ifNil: 'none').
 
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
	^ STONJSON fromString: self verifiedContents
]

{ #category : 'as yet unclassified' }
TTApiRequest >> asString [
  "convenience - replace with better"
	^ self getStdOut
]

{ #category : 'as yet unclassified' }
TTApiRequest >> begin [

  guzzler := self class makeHttpClientForScheme: scheme.
  
  guzzler url: self fullUrl.
  
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

	^ self response ifNil: [ self notify send response ].
]

{ #category : 'accessing' }
TTApiRequest >> prepare [

	guzzler url: self fullUrl.
	
	guzzler isHttpClient ifTrue: [
		
		client prepareRequest: self.
		
		guzzler method: self type.
		
		self isGET	
			ifTrue: [ guzzler queryAddAll: self parameters ]
	  	ifFalse: [ self prepareQuery ].
	].
]

{ #category : 'as yet unclassified' }
TTApiRequest >> rawContents [

	"likely coming from a ZnResponse"
	"thin client only"
	^ self outputProvider contents
]

{ #category : 'accessing' }
TTApiRequest >> response [

	^ guzzler response
	

]

{ #category : 'accessing' }
TTApiRequest >> send [

	self prepare.
 
	guzzler execute.
	
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

	^ self outputProvider status

]

{ #category : 'accessing' }
TTApiRequest >> stdout [

	^ self outputProvider contents

]

{ #category : 'as yet unclassified' }
TTApiRequest >> timeout: n [
	guzzler timeout: n
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
	^ self rawContents
]

{ #category : 'accessing' }
TTApiRequest >> withText: aText [
	
  super withText: aText.
	guzzler contents: text. 
	
	^ text
]
