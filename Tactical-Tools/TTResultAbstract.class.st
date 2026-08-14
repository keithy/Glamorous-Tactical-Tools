Class {
	#name : 'TTResultAbstract',
	#superclass : 'Object',
	#instVars : [
		'parent',
		'request'
	],
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'as yet unclassified' }
TTResultAbstract class >> isAbstract [

	^ self == TTResultAbstract
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> apply: aBoltOn [

	aBoltOn applyTo: self
]

{ #category : 'accessing' }
TTResultAbstract >> basicSetupForClient: aClient [

	parent := aClient
]

{ #category : 'accessing' }
TTResultAbstract >> basicSetupForModel: aModel [

	parent := aModel
]

{ #category : 'accessing' }
TTResultAbstract >> basicSetupForResult: aResult [

	parent := aResult
]

{ #category : 'accessing' }
TTResultAbstract >> newRequest [

	^ (self setRequest: (parent makeBasicRequestFor: self)) initialize

]

{ #category : 'accessing' }
TTResultAbstract >> parent [
	^ parent
]

{ #category : 'accessing' }
TTResultAbstract >> request [
	^ request
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> requestDict: aDict [
	
	"for readability the input may be an array of associations"
	
	request withDict: aDict
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> requestSTON: jsonable [

	request withSTON: jsonable.
		
	^ self
	
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> requestText: text [

	request withText: text.
		
	^ self
	
]

{ #category : 'as yet unclassified' }
TTResultAbstract >> requestUsing: aBlock [

	aBlock value: request.
	
	^ self
]

{ #category : 'accessing' }
TTResultAbstract >> setRequest: aRequest [

	request := aRequest.	
	request setResult: self.
	
	^ request
]
