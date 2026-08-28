Class {
	#name : 'TTApiClient',
	#superclass : 'TTClientAbstract',
	#instVars : [
		'accept',
		'contentType',
		'hostUrl'
	],
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'as yet unclassified' }
TTApiClient class >> / endPoint [

	^ (self basicNewFor: Hub current) /  endPoint
]

{ #category : 'as yet unclassified' }
TTApiClient class >> // aUrl [

	^ (self basicNewFor: Hub current) //  aUrl
]

{ #category : 'as yet unclassified' }
TTApiClient class >> basicNewFor: aVaultable [  

	| basicNewClient |
	
	basicNewClient := (super basicNewFor: aVaultable) ifNil: [ ^nil ].  
	 
	^ basicNewClient
			setRequestErrorHandler: Hub makeNetworkErrorHandler;
			yourself

]

{ #category : 'as yet unclassified' }
TTApiClient class >> classTool [

	^ Guzzler
]

{ #category : 'as yet unclassified' }
TTApiClient class >> makeOpenApiBrowser: aStreamable [

	^ (#GtOpenApiParser asClassIfAbsent: [ ^ nil ])  
			readString: aStreamable
			yourself
	
]

{ #category : 'as yet unclassified' }
TTApiClient class >> makeRequestForClient: aClient [

	^ (#class://#'ˆApiRequest') newForClient: aClient

]

{ #category : 'as yet unclassified' }
TTApiClient class >> makeResultForRequest: request [
	
	"Each result-request pair represents a query round trip"
	
	"Each result-request pair keeps a reference to the client,
	so that it can make further api calls of its own"

	^ (TTApiResult newForRequest: request) apply: TTToolOutputParser parseAsSTON
]

{ #category : 'accessing' }
TTApiClient >> / anEndpoint [

	^ self // self hostUrl / anEndpoint
]

{ #category : 'accessing' }
TTApiClient >> // aUrl [

	^ self makeRequest //  aUrl
]

{ #category : 'accessing' }
TTApiClient >> apiKey [

	^ vault at: #apikey
]

{ #category : 'accessing' }
TTApiClient >> applyAcceptTo: anApiRequest [

	accept ifNotNil: [ anApiRequest accept:  accept ]
]

{ #category : 'accessing' }
TTApiClient >> applyAuth: apiKey to: anApiRequest [

	anApiRequest headerAt: 'Authorization' put: ('Bearer ', apiKey asString) 
	
]

{ #category : 'accessing' }
TTApiClient >> applyAuthBasicTo: anApiRequest [
	anApiRequest
		username: (vault at: #user) asString
		password: (vault at: #pass) asString
]

{ #category : 'accessing' }
TTApiClient >> applyAuthTo: anApiRequest [

	(self apiKey)	
			ifNotNil: [ :apiKey | self applyAuth: apiKey to: anApiRequest ]
			ifNil: [ self applyAuthBasicTo: anApiRequest ]
]

{ #category : 'accessing' }
TTApiClient >> applyContentType: anApiRequest [
	anApiRequest headerAt: 'Content-Type' put: self contentType
]

{ #category : 'accessing' }
TTApiClient >> applyHeadersTo: request [
	
	self applyContentType: request.
	self applyAcceptTo: request.
	
	request isAuthRequired ifTrue: [ self applyAuthTo: request ].
]

{ #category : 'accessing' }
TTApiClient >> beHttp [

	hostUrl := hostUrl copyWithoutFirst: $s

]

{ #category : 'accessing' }
TTApiClient >> contentType [

	^ contentType ifNil: 'application/json'
]

{ #category : 'accessing' }
TTApiClient >> delete: endpoint [  

	^ (self /endpoint) useDELETE request
]

{ #category : 'accessing' }
TTApiClient >> get: endpoint [  

	^ (self / endpoint) useGET request
]

{ #category : 'openapi' }
TTApiClient >> getIsAliveCheck [ 
	
	^ false
]

{ #category : 'openapi' }
TTApiClient >> getMyself [ 

	^ nil
]

{ #category : 'accessing' }
TTApiClient >> handlers [

^ nil
]

{ #category : 'accessing' }
TTApiClient >> hostScheme [

	^ self hostUrl copyUpTo: $:
]

{ #category : 'accessing' }
TTApiClient >> hostUrl [

	hostUrl ifNotNil: [ ^ hostUrl ].
	
	hostUrl := vault at: #url.
	
	^ hostUrl
]

{ #category : 'openapi' }
TTApiClient >> openApiBrowser [

   
  	^ self class makeOpenApiBrowser:self openApiFile

]

{ #category : 'openapi' }
TTApiClient >> openApiJson [

  | jsonFile url |
  
  jsonFile := self class askFor: #fileOpenApiSpec ifAbsent: nil. 
  jsonFile ifNotNil: [ ^ jsonFile asFileReference ].
  
  url := (vault at: #url_openapi) ifNil: [ self class askFor: #urlOpenApiSpec ifAbsent: nil ].
  url ifNotNil: [ ^ classTool new get: url ].
  
  ^ ''
]

{ #category : 'accessing' }
TTApiClient >> prepareRequest: aRequest [
	
	super prepareRequest: aRequest.
	
	self applyHeadersTo: aRequest
	
]

{ #category : 'accessing' }
TTApiClient >> use: method withEndpoint: endpoint [  

	^ ((self / endpoint) use: method) request
]

{ #category : 'accessing' }
TTApiClient >> useDELETE: endpoint [  

	^ (self / endpoint) useDELETE request
]

{ #category : 'accessing' }
TTApiClient >> useGET: endpoint [  

	^ (self / endpoint) useGET request
]

{ #category : 'accessing' }
TTApiClient >> usePATCH: endpoint [  

	^ (self /endpoint) usePATCH request
]

{ #category : 'accessing' }
TTApiClient >> usePOST: endpoint [  

	^ (self /endpoint) usePOST request
]

{ #category : 'accessing' }
TTApiClient >> usePUT: endpoint [  

	^ (self /endpoint) usePUT request
]

{ #category : 'accessing' }
TTApiClient >> vLatest [

	^ self // self hostUrl / 'api'
]

{ #category : 'accessing' }
TTApiClient >> withEndpoint: anEndpoint [

	^ self // self hostUrl / anEndpoint
]

{ #category : 'accessing' }
TTApiClient >> withUrl: aUrl [

	^ self // aUrl 
]
