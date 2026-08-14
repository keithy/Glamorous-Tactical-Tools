Class {
	#name : 'TTGuzzlerPharo',
	#superclass : 'Object',
	#instVars : [
		'executeSelector',
		'httpClient',
		'contents',
		'data'
	],
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'instance creation' }
TTGuzzlerPharo class >> makeZnClient [ 

  ^ (TheHub classNamed: #ZnClient) new
]

{ #category : 'instance creation' }
TTGuzzlerPharo class >> new [ 

  "Normally we are a stand in for Zinc"
  
  ^ self error: 'Not actually ZnClient'
]

{ #category : 'instance creation' }
TTGuzzlerPharo class >> newForScheme: aScheme [ 

  "In this case we have a chance to work OUR magic"
  
	^ self askFor:('new_', aScheme) asSymbol ifAbsent: [ self error: 'unknown scheme ', aScheme ]
]

{ #category : 'instance creation' }
TTGuzzlerPharo class >> newForUrl: aUrl [ 

  "In this case we have a chance to work OUR magic"
  
	^ (self newForScheme: (aUrl copyUpTo: $:)) url: aUrl
]

{ #category : 'instance creation' }
TTGuzzlerPharo class >> new_L1http [

	^ self makeZnClient logLevel: 1
]

{ #category : 'instance creation' }
TTGuzzlerPharo class >> new_L2http [

	^ self makeZnClient logLevel: 2
]

{ #category : 'instance creation' }
TTGuzzlerPharo class >> new_L3http [

	^ self makeZnClient logLevel: 3
]

{ #category : 'instance creation' }
TTGuzzlerPharo class >> new_T1http [

	^ self makeZnClient logToTranscript; logLevel: 1
]

{ #category : 'instance creation' }
TTGuzzlerPharo class >> new_T2http [

	^ self makeZnClient logToTranscript; logLevel: 2
]

{ #category : 'instance creation' }
TTGuzzlerPharo class >> new_T3http [

	^ self makeZnClient logToTranscript; logLevel: 3
]

{ #category : 'instance creation' }
TTGuzzlerPharo class >> new_echo [

	^ (self basicNew)
	    setHttpClient: (self makeZnClient);
			setExecuteSelector: #echo
			initialize
]

{ #category : 'instance creation' }
TTGuzzlerPharo class >> new_file [

	^ self makeZnClient

]

{ #category : 'instance creation' }
TTGuzzlerPharo class >> new_headers [

	^ (self basicNew)
	    setHttpClient: (self makeZnClient);
			setExecuteSelector: #executeHeaders
			initialize
]

{ #category : 'instance creation' }
TTGuzzlerPharo class >> new_http [

	^ self makeZnClient loggingOff
]

{ #category : 'instance creation' }
TTGuzzlerPharo class >> new_https [

	^ self makeZnClient loggingOff
]

{ #category : 'instance creation' }
TTGuzzlerPharo class >> new_mock [

	^ (self basicNew)
	    setHttpClient: (self makeZnClient);
			setExecuteSelector: #executeMock
			initialize
]

{ #category : 'instance creation' }
TTGuzzlerPharo class >> new_unhttps [
 
"todo:
	Unified Http(s)
	
	Performs an https request, but merges the response headers into the return json payload
	if some clients might find that useful.
	
	The merged payload concept may also be useful when adopting non http transports.
"
	^ (self basicNew)
	    setHttpClient: (self makeZnClient);
			setExecuteSelector: #executeUnified
			initialize
]

{ #category : 'accessing' }
TTGuzzlerPharo >> contents [ 

	^ contents ifNil: [ httpClient contents ]
]

{ #category : 'accessing' }
TTGuzzlerPharo >> doesNotUnderstand: aMessage [

	"delegation"
	
	^ aMessage sendTo: httpClient
]

{ #category : 'accessing' }
TTGuzzlerPharo >> execute [

	self perform: executeSelector
]

{ #category : 'accessing' }
TTGuzzlerPharo >> executeEcho [

	contents := httpClient url readStream skipTo: $:; upToEnd. 
]

{ #category : 'accessing' }
TTGuzzlerPharo >> executeHeaders [

	data := httpClient request headers headers.
	
	contents := STONJSON toString: data.
]

{ #category : 'accessing' }
TTGuzzlerPharo >> executeMock [

	| classNameFromUrl aMocker urlStr methodFromUrl theRest |
	
	"mock:Faker/endpoint/etc"
	
	urlStr := httpClient url readStream.
	classNameFromUrl := urlStr skipTo: $:; upTo: $/.
	
	methodFromUrl := ('mock_',((urlStr upTo: $?) replaceAll: '/' with: '_'), ':') asSymbol.
	
	theRest := urlStr upToEnd.
	
	aMocker := TheHub classNamed: classNameFromUrl.
	
	contents :=  aMocker perform: methodFromUrl with: theRest
	
]

{ #category : 'accessing' }
TTGuzzlerPharo >> setExecuteSelector: anObject [
	executeSelector := anObject
]

{ #category : 'accessing' }
TTGuzzlerPharo >> setHttpClient: anObject [
	httpClient := anObject
]
