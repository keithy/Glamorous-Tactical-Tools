Class {
	#name : 'TTToolOutputParser',
	#superclass : 'TTResultBoltOn',
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'as yet unclassified' }
TTToolOutputParser >> parseAsSTON [
	
	result parsing: [ :streamable | STON fromString: (streamable ifNil: [ ^ #() ])]
	
	

]

{ #category : 'as yet unclassified' }
TTToolOutputParser >> parseAsXML [

	result parsing: [ :toolOutput | XMLDOMParser parse: toolOutput ]
	
	
	
]

{ #category : 'as yet unclassified' }
TTToolOutputParser >> passAsData [
	
	result parsing: [ :toolOutputStringOrData | toolOutputStringOrData asByteArray ]
]

{ #category : 'as yet unclassified' }
TTToolOutputParser >> passAsStream [
	
	result parsing: [ :streamable | streamable readStream ]
]

{ #category : 'as yet unclassified' }
TTToolOutputParser >> passAsString [
	
	result parsing: [ :toolOutputStringOrData | toolOutputStringOrData asString ]
]
