Class {
	#name : 'TTApiClientAbstract',
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
TTApiClientAbstract class >> basicNewForVault: aFactory ifFail: failBlock [

	| basicNewClient |
	
	basicNewClient := super basicNewForVault: aFactory ifFail: [ ^ failBlock value ].
	
	^ basicNewClient
			setClassTool: TheHub classHttpClient;
			setRequestErrorHandler: aFactory class makeNetworkErrorHandler;
			yourself

]

{ #category : 'as yet unclassified' }
TTApiClientAbstract class >> makeBasicResult [

	^ TTApiResult basicNew
]

{ #category : 'as yet unclassified' }
TTApiClientAbstract class >> makeOpenApiBrowser: aStreamable [

	^ (#GtOpenApiParser asClassIfAbsent: [ ^ nil ])  
			readString: aStreamable
			yourself
	
]

{ #category : 'accessing' }
TTApiClientAbstract class >> suitableOptions: appOptions [

  ^ appOptions associationsSelect: [ :assoc | self suitsOption: assoc value ]
]

{ #category : 'accessing' }
TTApiClientAbstract class >> suitableOptionsInVault: aVault [

	| appOptions |
	
	appOptions := aVault apps at: self vaultAppKey ifAbsent: [ ^ #() ]. 
	
	^ self suitableOptions: appOptions

]

{ #category : 'accessing' }
TTApiClientAbstract class >> suitsOption: appConfig [

	 ^ appConfig at: #url ifPresent: [ :url | url = self urlHostApi ] ifAbsent: false
 
]

{ #category : 'as yet unclassified' }
TTApiClientAbstract class >> suitsVault: aVault [

	^ aVault lookupHasFields: #(url)
]

{ #category : 'accessing' }
TTApiClientAbstract class >> urlHostApi [

   ^ 'nemo://'
]

{ #category : 'accessing' }
TTApiClientAbstract >> / anEndpoint [

	^ self // self hostUrl / anEndpoint
]

{ #category : 'accessing' }
TTApiClientAbstract >> // aUrl [

	^ self newRequest //  aUrl
]

{ #category : 'accessing' }
TTApiClientAbstract >> applyAcceptTo: anApiRequest [

	anApiRequest accept: accept  
]

{ #category : 'accessing' }
TTApiClientAbstract >> applyAuthApiKeyTo: anApiRequest [

	(vault at: #api_key) ifNotNil: [ :apiKey | 
			
			anApiRequest headerAt: 'Authorization' put: ('Bearer ', apiKey asString) 
	]

]

{ #category : 'accessing' }
TTApiClientAbstract >> applyAuthBasicTo: anApiRequest [

	anApiRequest username: (vault at: #user) password: (vault at: #pass)
	
]

{ #category : 'accessing' }
TTApiClientAbstract >> applyAuthTo: anApiRequest [

	(vault at: #api_key)	
			ifNotNil: [ self applyAuthApiKeyTo: anApiRequest ]
			ifNil: [ self applyAuthBasicTo: anApiRequest ]
]

{ #category : 'accessing' }
TTApiClientAbstract >> applyContentType: anApiRequest [
	anApiRequest headerAt: 'Content-Type' put: self contentType
]

{ #category : 'accessing' }
TTApiClientAbstract >> applyHeadersTo: request [
	
	self applyContentType: request.
	self applyAcceptTo: request.
	
	request isAuthRequired ifTrue: [ self applyAuthTo: request ].
]

{ #category : 'accessing' }
TTApiClientAbstract >> contentType [

	^ contentType ifNil: 'application/json'
]

{ #category : 'accessing' }
TTApiClientAbstract >> delete: endpoint [  

	^ (self /endpoint) useDELETE request
]

{ #category : 'accessing' }
TTApiClientAbstract >> get: endpoint [  

	^ (self / endpoint) useGET request
]

{ #category : 'openapi' }
TTApiClientAbstract >> getIsAliveCheck [ 
	
	^ false
]

{ #category : 'openapi' }
TTApiClientAbstract >> getMyself [ 

	^ nil
]

{ #category : 'accessing' }
TTApiClientAbstract >> hostScheme [

	^ self hostUrl copyUpTo: $:
]

{ #category : 'accessing' }
TTApiClientAbstract >> hostUrl [

	^ hostUrl ifNil: [ hostUrl := vault url ]
]

{ #category : 'openapi' }
TTApiClientAbstract >> makeBasicRequestFor: aResult [

	^ (super makeBasicRequestFor: aResult)
				setScheme: self hostScheme;
				yourself

]

{ #category : 'accessing' }
TTApiClientAbstract >> makeInitializeRequest: aRequest [
	
	super makeInitializeRequest: aRequest.
	
	self applyHeadersTo: aRequest
	
]

{ #category : 'openapi' }
TTApiClientAbstract >> openApiBrowser [

   
  	^ self class makeOpenApiBrowser:self openApiFile

]

{ #category : 'openapi' }
TTApiClientAbstract >> openApiJson [

  | jsonFile url |
  
  jsonFile := self class askFor: #fileOpenApiSpec ifAbsent: nil. 
  jsonFile ifNotNil: [ ^ jsonFile asFileReference ].
  
  url := (vault at: #url_openapi) ifNil: [ self class askFor: #urlOpenApiSpec ifAbsent: nil ].
  url ifNotNil: [ ^ classTool new get: url ].
  
  ^ ''
]

{ #category : 'accessing' }
TTApiClientAbstract >> useDELETE: endpoint [  

	^ (self / endpoint) useDELETE request
]

{ #category : 'accessing' }
TTApiClientAbstract >> useEndpoint: anEndpoint [

	^ self // self hostUrl / anEndpoint
]

{ #category : 'accessing' }
TTApiClientAbstract >> useGET: endpoint [  

	^ (self / endpoint) useGET request
]

{ #category : 'accessing' }
TTApiClientAbstract >> usePATCH: endpoint [  

	^ (self /endpoint) usePATCH request
]

{ #category : 'accessing' }
TTApiClientAbstract >> usePOST: endpoint [  

	^ (self /endpoint) usePOST request
]

{ #category : 'accessing' }
TTApiClientAbstract >> usePUT: endpoint [  

	^ (self /endpoint) usePUT request
]

{ #category : 'accessing' }
TTApiClientAbstract >> useUrl: aUrl [

	^ self // aUrl 
]

{ #category : 'accessing' }
TTApiClientAbstract >> vLatest [

	^ self // self hostUrl / 'api'
]
