Class {
	#name : 'TTToolOutputParser',
	#superclass : 'TTResultBoltOn',
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'accessing' }
TTToolOutputParser class >> parseAsSTON [
	^ self newFromMessage: thisContext
]

{ #category : 'accessing' }
TTToolOutputParser class >> parseAsXML [
	^ self newFromMessage: thisContext
]

{ #category : 'accessing' }
TTToolOutputParser class >> parseFromJson [
	^ self newFromMessage: thisContext
]

{ #category : 'accessing' }
TTToolOutputParser class >> passAsData [
	^ self newFromMessage: thisContext
]

{ #category : 'accessing' }
TTToolOutputParser class >> passAsStream [
	^ self newFromMessage: thisContext
]

{ #category : 'accessing' }
TTToolOutputParser class >> passAsString [

	^ self newFromMessage: thisContext
]

{ #category : 'as yet unclassified' }
TTToolOutputParser >> parseAsSTON [
	
	result initializeParsers.
	result parsing: [ :streamable | STON fromString: (streamable ifNil: [ ^ #() ])]
	
	

]

{ #category : 'as yet unclassified' }
TTToolOutputParser >> parseAsXML [

	result initializeParsers.
	result parsing: [ :toolOutput | XMLDOMParser parse: toolOutput ]
	
	
	
]

{ #category : 'as yet unclassified' }
TTToolOutputParser >> parseFromJson [
	
	result initializeParsers.
	result parsing: [ :streamable | STON fromString: (streamable ifNil: [ ^ #() ])]
	
	

]

{ #category : 'as yet unclassified' }
TTToolOutputParser >> passAsData [
	
		result initializeParsers.
		result parsing: [ :toolOutputStringOrData | toolOutputStringOrData asByteArray ]
]

{ #category : 'as yet unclassified' }
TTToolOutputParser >> passAsStream [
	
	result initializeParsers.
	result parsing: [ :streamable | streamable readStream ]
]

{ #category : 'as yet unclassified' }
TTToolOutputParser >> passAsString [
	
		result initializeParsers.
		
		"default behaviour"
		"result parsing: [ :toolOutputStringOrData | toolOutputStringOrData asString ]"
]
