Class {
	#name : 'TTZincApiRequest',
	#superclass : 'TTApiRequest',
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'as yet unclassified' }
TTZincApiRequest >> doesNotUnderstand: aMessage [

	"delegation"
	
	^ aMessage sendTo: guzzler
]
