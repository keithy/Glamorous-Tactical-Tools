Class {
	#name : 'TTCloudflareStatusHandler',
	#superclass : 'Object',
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'as yet unclassified' }
TTCloudflareStatusHandler class >> value: aResult [

	aResult responseStatusCode < 400 ifTrue: [ ^false ].
	
	aResult inputProvider responseIsXML
		ifTrue: [ 
				XMLDOMParser parse: aResult responseContents
				self halt.
		].
	
	
	
	^ false 
]

{ #category : 'as yet unclassified' }
TTCloudflareStatusHandler class >> value: aResult value: code [

	code < 400 ifTrue: [ ^false ].
	
	aResult inputProvider responseIsXml
		ifTrue: [ 
			  
			 ^ self error: ((XMLDOMParser parse: aResult responseContents )// 'message') stringValue
			 
		].
	
	
	
	^ false 
]
