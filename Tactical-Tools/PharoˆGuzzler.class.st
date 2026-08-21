Class {
	#name : 'PharoˆGuzzler',
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
PharoˆGuzzler class >> classApiRequest [

	^ TTZincApiRequest
]

{ #category : 'as yet unclassified' }
PharoˆGuzzler class >> http: aUrl [
	| url |

		url := (aUrl includesSubstring: 'http://')
			ifFalse: [ 'http://' , aUrl ]
			ifTrue: [ aUrl ].
	^ self newForUrl: aUrl

]

{ #category : 'as yet unclassified' }
PharoˆGuzzler class >> https: aUrl [
	| url |
	url := (aUrl includesSubstring: 'https://')
			ifFalse: [ 'https://' , aUrl ]
			ifTrue: [ aUrl ].
	^ self newForUrl: url
]

{ #category : 'instance creation' }
PharoˆGuzzler class >> makeZnClient [ 

  ^ (#class://#ZnClient) new
]

{ #category : 'instance creation' }
PharoˆGuzzler class >> new [ 

  "Normally we are a stand in for Zinc"
  
  ^ self error: 'Not actually ZnClient'
]

{ #category : 'instance creation' }
PharoˆGuzzler class >> newForScheme: aScheme [ 

  "In this case we have a chance to work OUR magic"
  
	^ self askFor:('new_', aScheme) asSymbol ifAbsent: [ self error: 'unknown scheme ', aScheme ]
]

{ #category : 'instance creation' }
PharoˆGuzzler class >> newForScheme: aScheme url: aUrl [ 

  "In this case we have a chance to work OUR magic"
  
	^ (self newForScheme: (aUrl copyUpTo: $:)) url: aUrl
]

{ #category : 'instance creation' }
PharoˆGuzzler class >> newForUrl: aUrl [ 

  "In this case we have a chance to work OUR magic"
  
	^ self newForScheme: (aUrl copyUpTo: $:) url: aUrl
]

{ #category : 'instance creation' }
PharoˆGuzzler class >> new_L1http [

	^ self makeZnClient logLevel: 1
]

{ #category : 'instance creation' }
PharoˆGuzzler class >> new_L2http [

	^ self makeZnClient logLevel: 2
]

{ #category : 'instance creation' }
PharoˆGuzzler class >> new_L3http [

	^ self makeZnClient logLevel: 3
]

{ #category : 'instance creation' }
PharoˆGuzzler class >> new_T1http [

	^ self makeZnClient logToTranscript; logLevel: 1
]

{ #category : 'instance creation' }
PharoˆGuzzler class >> new_T2http [

	^ self makeZnClient logToTranscript; logLevel: 2
]

{ #category : 'instance creation' }
PharoˆGuzzler class >> new_T3http [

	^ self makeZnClient logToTranscript; logLevel: 3
]

{ #category : 'instance creation' }
PharoˆGuzzler class >> new_echo [

	^ (self basicNew)
	    setHttpClient: (self makeZnClient);
			setExecuteSelector: #echo
			initialize
]

{ #category : 'instance creation' }
PharoˆGuzzler class >> new_file [

	^ self makeZnClient

]

{ #category : 'instance creation' }
PharoˆGuzzler class >> new_headers [

	^ (self basicNew)
	    setHttpClient: (self makeZnClient);
			setExecuteSelector: #executeHeaders
			initialize
]

{ #category : 'instance creation' }
PharoˆGuzzler class >> new_http [

	^ self makeZnClient loggingOff
]

{ #category : 'instance creation' }
PharoˆGuzzler class >> new_https [

	^ self makeZnClient loggingOff
]

{ #category : 'instance creation' }
PharoˆGuzzler class >> new_mock [

	^ (self basicNew)
	    setHttpClient: (self makeZnClient);
			setExecuteSelector: #executeMock
			initialize
]

{ #category : 'instance creation' }
PharoˆGuzzler class >> new_unhttps [
 
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
PharoˆGuzzler >> contents [ 

	^ contents ifNil: [ httpClient contents ]
]

{ #category : 'accessing' }
PharoˆGuzzler >> doesNotUnderstand: aMessage [

	"delegation"
	
	^ aMessage sendTo: httpClient
]

{ #category : 'accessing' }
PharoˆGuzzler >> execute [

	self perform: executeSelector
]

{ #category : 'accessing' }
PharoˆGuzzler >> executeEcho [

	contents := httpClient url readStream skipTo: $:; upToEnd. 
]

{ #category : 'accessing' }
PharoˆGuzzler >> executeHeaders [

	data := httpClient request headers headers.
	
	contents := STONJSON toString: data.
]

{ #category : 'accessing' }
PharoˆGuzzler >> executeMock [

	| classNameFromUrl aMocker urlStr methodFromUrl theRest |
	
	"mock:Faker/endpoint/etc"
	
	urlStr := httpClient url readStream.
	
	classNameFromUrl := urlStr skipTo: $:; upTo: $/.
	
	methodFromUrl := ('mock_',((urlStr upTo: $?) replaceAll: '/' with: '_'), ':') asSymbol.
	
	theRest := urlStr upToEnd.
	
	aMocker := Hub getClass: classNameFromUrl.
	
	contents :=  aMocker perform: methodFromUrl with: theRest
	
]

{ #category : 'accessing' }
PharoˆGuzzler >> setExecuteSelector: anObject [
	executeSelector := anObject
]

{ #category : 'accessing' }
PharoˆGuzzler >> setHttpClient: anObject [
	httpClient := anObject
]
