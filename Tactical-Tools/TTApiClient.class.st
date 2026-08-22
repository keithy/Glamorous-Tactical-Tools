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
TTApiClient class >> > selector [ 

^ self perform: selector
]

{ #category : 'as yet unclassified' }
TTApiClient class >> basicNewFor: aVaultable [  

	| basicNewClient |
	
	basicNewClient := (super basicNewFor: aVaultable) ifNil: [ ^nil ].  
	 
	^ basicNewClient
			setClassTool: #class://#ˆGuzzler;
			setRequestErrorHandler: Hub makeNetworkErrorHandler;
			yourself

]

{ #category : 'as yet unclassified' }
TTApiClient class >> makeOpenApiBrowser: aStreamable [

	^ (#GtOpenApiParser asClassIfAbsent: [ ^ nil ])  
			readString: aStreamable
			yourself
	
]

{ #category : 'as yet unclassified' }
TTApiClient class >> makeResult [

	^ TTApiResult new
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
TTApiClient >> applyAcceptTo: anApiRequest [

	accept ifNotNil: [ anApiRequest accept:  accept ]
]

{ #category : 'accessing' }
TTApiClient >> applyAuthApiKeyTo: anApiRequest [

	(vault at: #api_key) ifNotNil: [ :apiKey | 
			
			anApiRequest headerAt: 'Authorization' put: ('Bearer ', apiKey asString) 
	]

]

{ #category : 'accessing' }
TTApiClient >> applyAuthBasicTo: anApiRequest [

	anApiRequest username: (vault at: #user) password: (vault at: #pass)
	
]

{ #category : 'accessing' }
TTApiClient >> applyAuthTo: anApiRequest [

	(vault at: #api_key)	
			ifNotNil: [ self applyAuthApiKeyTo: anApiRequest ]
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

	"not sure if this will do the right thing"
	hostUrl := hostUrl copyWithoutFirst: $s

]

{ #category : 'accessing' }
TTApiClient >> beginRequest: aRequest [
	
	super beginRequest: aRequest.
	
	self applyHeadersTo: aRequest
	
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

	^ hostUrl ifNil: [ hostUrl := vault url ]
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
TTApiClient >> useDELETE: endpoint [  

	^ (self / endpoint) useDELETE request
]

{ #category : 'accessing' }
TTApiClient >> useEndpoint: anEndpoint [

	^ self // self hostUrl / anEndpoint
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
TTApiClient >> useUrl: aUrl [

	^ self // aUrl 
]

{ #category : 'accessing' }
TTApiClient >> vLatest [

	^ self // self hostUrl / 'api'
]
