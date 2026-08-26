Class {
	#name : 'TTCloudflareStatusHandler',
	#superclass : 'Object',
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'as yet unclassified' }
TTCloudflareStatusHandler class >> value: aResult [

	aResult inputProvider responseStatus < 400 ifTrue: [ ^false ].
	
	((aResult inputProvider responseSubType) = 'xml')
		ifTrue: [ 
				XMLDOMParser parse: aResult inputProvider responseContents
				self halt.
		].
	
	
	
	^ false 
]
