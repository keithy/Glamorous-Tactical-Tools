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
	
	^ (TheHub classHttpClient) newForScheme: (aScheme ifNil: 'none').
 
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
	
	self uri: uri
]

{ #category : 'accessing' }
TTApiRequest >> fullUrl [

	^ String streamContents: [ :stream | stream << scheme << ':' << url ]
			
		 	
]

{ #category : 'as yet unclassified' }
TTApiRequest >> initialize [

  guzzler := self class makeHttpClientForScheme: scheme.
   
  super initialize 
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
TTApiRequest >> prepareQuery [

	self parameters ifEmpty: [ ^ self ].
	
	guzzler entity: (ZnEntity text: (STON toJsonString: self parameters));
											contentType: ZnMimeType applicationJson
											
											
	
]

{ #category : 'accessing' }
TTApiRequest >> send [

	self prepare.
 
	^ guzzler execute 
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
TTApiRequest >> type [
	
		^ type ifNil: [ type := #GET ]
]

{ #category : 'accessing' }
TTApiRequest >> uri: aUri [

	"scheme was given at the earliest opportunity,
	we should already have it, there is some opportunity
	for confusion between then and now."

	url := aUri copyAfter: $:
]

{ #category : 'accessing' }
TTApiRequest >> useDELETE [

	type := #DELETE.
	
	^ result
]

{ #category : 'accessing' }
TTApiRequest >> useGET [

	type := #GET.
	
	^ result
]

{ #category : 'accessing' }
TTApiRequest >> usePATCH [

	type := #PATCH.
	
	^ result
]

{ #category : 'accessing' }
TTApiRequest >> usePOST [

	type := #POST.
	
	^ result
]

{ #category : 'accessing' }
TTApiRequest >> usePUT [

	type := #PUT.
	
	^ result
]

{ #category : 'accessing' }
TTApiRequest >> withSTON: jsonable [

	super withSTON: jsonable.
	self entity: (ZnEntity text: text);
		  contentType: ZnMimeType applicationJson.

	^ text
]

{ #category : 'accessing' }
TTApiRequest >> withText: aText [
	
  super withText: aText.
	guzzler contents: text. 
	
	^ text
]
