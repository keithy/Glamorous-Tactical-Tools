Class {
	#name : 'TTRequestAbstract',
	#superclass : 'Object',
	#instVars : [
		'client',
		'result',
		'isAuthRequired',
		'type',
		'parameters',
		'text'
	],
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'testing' }
TTRequestAbstract class >> isAbstract [

	^ self == TTRequestAbstract
]

{ #category : 'testing' }
TTRequestAbstract class >> isNamespaced [
  <namespaced>
	<namespaced:'TT'> 
	^ true
]

{ #category : 'initialization' }
TTRequestAbstract >> begin [

	^ self
	
]

{ #category : 'accessing' }
TTRequestAbstract >> client [
	^ client
]

{ #category : 'as yet unclassified' }
TTRequestAbstract >> errorHandler [

	^ self client requestErrorHandler
]

{ #category : 'as yet unclassified' }
TTRequestAbstract >> getRawContents [
	^ self getVerifiedContents
]

{ #category : 'accessing' }
TTRequestAbstract >> getResult [
	^ result ifNil: [ result := self client class makeResultForRequest: self ]
]

{ #category : 'as yet unclassified' }
TTRequestAbstract >> getVerifiedContents [

	self subclassResponsibility
]

{ #category : 'initialization' }
TTRequestAbstract >> initialize [
	"Initialise as a pair, this may not do anything now as
	the functionality has moved to #begin"
	result initialize
]

{ #category : 'accessing' }
TTRequestAbstract >> isAuthRequired [

	^ isAuthRequired
]

{ #category : 'accessing' }
TTRequestAbstract >> isAuthRequired: bool [

	isAuthRequired := bool
]

{ #category : 'accessing' }
TTRequestAbstract >> notify [

	^ (TTRequestNotification new)
		request: self;
		signal 

  
]

{ #category : 'accessing' }
TTRequestAbstract >> output [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
TTRequestAbstract >> parameterAt: key put: value [

	^ self parameters at: key put: value
]

{ #category : 'accessing' }
TTRequestAbstract >> parameters [

	^ parameters ifNil: [  parameters := Dictionary new ]
]

{ #category : 'accessing' }
TTRequestAbstract >> request [

	^ self
]

{ #category : 'as yet unclassified' }
TTRequestAbstract >> requestErrorHandler [

	^ self client requestErrorHandler
]

{ #category : 'accessing' }
TTRequestAbstract >> result [
	^ result ifNil: [ self ]
]

{ #category : 'initialization' }
TTRequestAbstract >> setClient: anObject [
	client := anObject
]

{ #category : 'initialization' }
TTRequestAbstract >> setResult: anObject [
	result := anObject.
 
]

{ #category : 'accessing' }
TTRequestAbstract >> withDict: aDictish [
	
	"for readability the input may be an array of associations"
	
	^ self withSTON: aDictish asDictionary
]

{ #category : 'accessing' }
TTRequestAbstract >> withSTON: jsonable [

  text := STON toJsonString: jsonable.
  
  ^ text
		  
]

{ #category : 'accessing' }
TTRequestAbstract >> withText [
	
	^ text
]

{ #category : 'accessing' }
TTRequestAbstract >> withText: aText [
	 
	 "multiple uses append"
	 text := (text ifNil: ''), aText.
	 
	 ^ text
]

{ #category : 'accessing' }
TTRequestAbstract >> withUsing: aBlock [
  
  "double dispatch this over to the result, 
   clients can customize the result class"
	
	result requestUsing: aBlock  
]
