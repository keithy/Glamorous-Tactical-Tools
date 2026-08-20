Class {
	#name : 'TTZincApiRequest',
	#superclass : 'TTApiRequest',
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'as yet unclassified' }
TTZincApiRequest >> accept: mimeType [

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
