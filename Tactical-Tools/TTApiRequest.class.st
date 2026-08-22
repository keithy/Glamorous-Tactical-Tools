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
	^ STONJSON fromString: self getContents
]

{ #category : 'as yet unclassified' }
TTApiRequest >> asString [
  "convenience - replace with better"
	^ self getContents
]

{ #category : 'as yet unclassified' }
TTApiRequest >> begin [

  guzzler := self class makeHttpClientForScheme: scheme.
   
  super begin 
]

{ #category : 'accessing' }
TTApiRequest >> fullUrl [

	^ String streamContents: [ :stream | stream << scheme << ':' << url ]
			
		 	
]

{ #category : 'as yet unclassified' }
TTApiRequest >> getContents [
	"thin client only"
	^ self send response contents
]

{ #category : 'accessing' }
TTApiRequest >> isGET [

	^ self type == #GET
]

{ #category : 'accessing' }
TTApiRequest >> isGet [

	^ self type == #GET
]

{ #category : 'accessing' }
TTApiRequest >> prepare [

	guzzler
		method: self type;
		url: self fullUrl.
		
	self isGET	
		ifTrue: [ guzzler queryAddAll: self parameters ]
  	ifFalse: [ self prepareQuery ].
]

{ #category : 'accessing' }
TTApiRequest >> request [

	^ self
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

{ #category : 'as yet unclassified' }
TTApiRequest >> timeout: n [
	guzzler timeout: n
]

{ #category : 'accessing' }
TTApiRequest >> type [
	
		^ type ifNil: [ type := #GET ]
]

{ #category : 'accessing' }
TTApiRequest >> useDELETE [

	type := #DELETE.
	
	^ self getResult
]

{ #category : 'accessing' }
TTApiRequest >> useGET [

	type := #GET.
	
	^ self getResult
]

{ #category : 'accessing' }
TTApiRequest >> usePATCH [

	type := #PATCH.
	
	^ self getResult
]

{ #category : 'accessing' }
TTApiRequest >> usePOST [

	type := #POST.
	
	^ self getResult
]

{ #category : 'accessing' }
TTApiRequest >> usePUT [

	type := #PUT.
	
	^ self getResult
]

{ #category : 'accessing' }
TTApiRequest >> withText: aText [
	
  super withText: aText.
	guzzler contents: text. 
	
	^ text
]
