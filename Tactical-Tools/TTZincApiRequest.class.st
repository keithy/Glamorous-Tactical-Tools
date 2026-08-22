Class {
	#name : 'TTZincApiRequest',
	#superclass : 'TTApiRequest',
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'as yet unclassified' }
TTZincApiRequest >> accept: mimeType [
  self error.
	guzzler request setAccept: mimeType
]

{ #category : 'as yet unclassified' }
TTZincApiRequest >> doesNotUnderstand: aMessage [

  "Creating Guzzler has taken on most/all of this classes funciton,
   roll up into TTAPiRequest?"
   
	"delegation"
	
	^ aMessage sendTo: guzzler
]

{ #category : 'as yet unclassified' }
TTZincApiRequest >> output [

	^ guzzler response
]

{ #category : 'accessing' }
TTZincApiRequest >> prepareQuery [

	self parameters ifEmpty: [ ^ self ].
	
	guzzler entity: (ZnEntity text: (STON toJsonString: self parameters));
											contentType: ZnMimeType applicationJson
											
											
	
]

{ #category : 'accessing' }
TTZincApiRequest >> withSTON: jsonable [

	super withSTON: jsonable.
	self entity: (ZnEntity text: text);
		  contentType: ZnMimeType applicationJson.

	^ text
]
