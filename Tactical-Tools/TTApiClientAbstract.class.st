Class {
	#name : 'TTApiClientAbstract',
	#superclass : 'TTClientAbstract',
	#category : 'Tactical-Tools-Clients',
	#package : 'Tactical-Tools',
	#tag : 'Clients'
}

{ #category : 'as yet unclassified' }
TTApiClientAbstract class >> basicNewForFactory: aFactory ifFail: failBlock [

	(self vaultHasWhatINeed: (aFactory vault)) ifFalse: [ ^ failBlock value ].
	
	"set things that are needed prior to initialization"
	^ (self basicNew)
					setVault: aFactory vault;
					yourself
]

{ #category : 'as yet unclassified' }
TTApiClientAbstract class >> makeGuzzler [

	^ ZnClient new
	
]

{ #category : 'as yet unclassified' }
TTApiClientAbstract class >> makeOpenApiBrowser: aStreamable [

	^ (#GtOpenApiParser asClassIfAbsent: [ ^ nil ])  
			readString: aStreamable
			yourself
	
]

{ #category : 'as yet unclassified' }
TTApiClientAbstract class >> vaultHasWhatINeed: aFactoryVault [

	^ aFactoryVault lookupHasFields: #(url)
]

{ #category : 'openapi' }
TTApiClientAbstract >> getIsAliveCheck [ 
	
	^ false
]

{ #category : 'openapi' }
TTApiClientAbstract >> getMyself [ 

	^ nil
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
  url ifNotNil: [ ^ self class makeGuzzler get: url ].
  
  ^ ''
]
