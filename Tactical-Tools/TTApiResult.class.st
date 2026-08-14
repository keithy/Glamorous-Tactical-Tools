Class {
	#name : 'TTApiResult',
	#superclass : 'TTResult',
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'as yet unclassified' }
TTApiResult >> client [

	^ parent

]

{ #category : 'as yet unclassified' }
TTApiResult >> getResponse [

	^ request notify send response
]

{ #category : 'as yet unclassified' }
TTApiResult >> setRequest: aRequest [

	super setRequest: aRequest.

	^ request
]

{ #category : 'as yet unclassified' }
TTApiResult >> timeout [

 ^ 5
]
