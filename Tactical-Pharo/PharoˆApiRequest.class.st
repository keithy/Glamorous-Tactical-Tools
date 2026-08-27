Class {
	#name : 'PharoˆApiRequest',
	#superclass : 'TTApiRequest',
	#category : 'Tactical-Pharo-Guzzler',
	#package : 'Tactical-Pharo',
	#tag : 'Guzzler'
}

{ #category : 'as yet unclassified' }
PharoˆApiRequest >> accept: mimeType [
  self error.
	guzzler request setAccept: mimeType
]

{ #category : 'accessing' }
PharoˆApiRequest >> contentType: aZnMimeType [
	"although dnu would handle this the code parsers prefer it to be real"
	guzzler contentType: aZnMimeType
]

{ #category : 'as yet unclassified' }
PharoˆApiRequest >> doesNotUnderstand: aMessage [

  "Creating Guzzler has taken on most/all of this classes funciton,
   roll up into TTAPiRequest?"
   
	"delegation"
	
	^ aMessage sendTo: guzzler
]

{ #category : 'accessing' }
PharoˆApiRequest >> entity: anEntity [
	"although dnu would handle this the code parsers prefer it to be real"
	guzzler entity: anEntity
]

{ #category : 'accessing' }
PharoˆApiRequest >> prepareQuery [

	self parameters ifEmpty: [ ^ self ].
	
	guzzler entity: (ZnEntity text: (STON toJsonString: self parameters));
											contentType: ZnMimeType applicationJson
											
											
	
]

{ #category : 'accessing' }
PharoˆApiRequest >> responseContentType [

	^ self outputProvider contentType  
]

{ #category : 'accessing' }
PharoˆApiRequest >> responseIsHtml [

	^ self outputProvider contentType sub = 'html'
]

{ #category : 'accessing' }
PharoˆApiRequest >> responseIsJson [

	^ self outputProvider contentType sub = 'json'
]

{ #category : 'accessing' }
PharoˆApiRequest >> responseIsText [

	^ self outputProvider contentType sub = 'plain'
]

{ #category : 'accessing' }
PharoˆApiRequest >> responseIsXml [

	^ self response contentType sub = 'xml'
]

{ #category : 'as yet unclassified' }
PharoˆApiRequest >> responseStatusCode [

	^ [ self response status ] ifError: [ nil ]
]

{ #category : 'as yet unclassified' }
PharoˆApiRequest >> responseStatusMessage [

	"likely coming from a ZnResponse"
 
	^ (String streamContents: [ :out | self response statusLine writeOn: out ]) 
]

{ #category : 'accessing' }
PharoˆApiRequest >> stderr [
	^ String streamContents: [ :out | self response statusLine writeOn: out ] 
	 

]

{ #category : 'accessing' }
PharoˆApiRequest >> withSTON: jsonable [

	super withSTON: jsonable.
	self entity: (ZnEntity text: text);
		  contentType: ZnMimeType applicationJson.

	^ text
]
