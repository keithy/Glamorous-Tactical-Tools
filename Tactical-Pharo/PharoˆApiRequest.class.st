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
PharoˆApiRequest >> withSTON: jsonable [

	super withSTON: jsonable.
	self entity: (ZnEntity text: text);
		  contentType: ZnMimeType applicationJson.

	^ text
]
