Class {
	#name : 'Guzzler',
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

{ #category : 'as yet unclassified' }
Guzzler class >> // aUrl [
	 
	^ self newForUrl: aUrl

]

{ #category : 'instance creation' }
Guzzler class >> classApiRequest [

	^ #class://#'ˆApiRequest'
]

{ #category : 'as yet unclassified' }
Guzzler class >> http: aUrl [
	| url |

		url := (aUrl includesSubstring: 'http://')
			ifFalse: [ 'http://' , aUrl ]
			ifTrue: [ aUrl ].
	^ self newForUrl: aUrl

]

{ #category : 'as yet unclassified' }
Guzzler class >> https: aUrl [
	| url |
	url := (aUrl includesSubstring: 'https://')
			ifFalse: [ 'https://' , aUrl ]
			ifTrue: [ aUrl ].
	^ self newForUrl: url
]

{ #category : 'instance creation' }
Guzzler class >> makeFileClient [ 

  ^ (#class://'ˆFileClient') new
]

{ #category : 'instance creation' }
Guzzler class >> makeHttpClient [ 

  ^ (#class://#'ˆHttpClient') new
]

{ #category : 'instance creation' }
Guzzler class >> new [ 

  "Normally we are a stand in for Zinc"
  
  ^ self error: 'Not actually ZnClient'
]

{ #category : 'instance creation' }
Guzzler class >> newForScheme: aScheme [ 

  "In this case we have a chance to work OUR magic"
  
	^ self askFor:('new_', aScheme) asSymbol ifAbsent: [ self error: 'unknown scheme ', aScheme ]
]

{ #category : 'instance creation' }
Guzzler class >> newForUrl: aUrl [ 

  "In this case we have a chance to work OUR magic"
  
	^ (self newForScheme: (aUrl copyUpTo: $:)) url: aUrl
]

{ #category : 'instance creation' }
Guzzler class >> new_L1http [

	^ self makeHttpClient logLevel: 1
]

{ #category : 'instance creation' }
Guzzler class >> new_L2http [

	^ self makeHttpClient logLevel: 2
]

{ #category : 'instance creation' }
Guzzler class >> new_L3http [

	^ self makeHttpClient logLevel: 3
]

{ #category : 'instance creation' }
Guzzler class >> new_T1http [

	^ self makeHttpClient logToTranscript; logLevel: 1
]

{ #category : 'instance creation' }
Guzzler class >> new_T2http [

	^ self makeHttpClient logToTranscript; logLevel: 2
]

{ #category : 'instance creation' }
Guzzler class >> new_T3http [

	^ self makeHttpClient logToTranscript; logLevel: 3
]

{ #category : 'instance creation' }
Guzzler class >> new_echo [

	^ (self basicNew)
	    setHttpClient: (self makeHttpClient);
			setExecuteSelector: #echo
			initialize
]

{ #category : 'instance creation' }
Guzzler class >> new_file [

	^ self makeHttpClient

]

{ #category : 'instance creation' }
Guzzler class >> new_headers [

	^ (self basicNew)
	    setHttpClient: (self makeHttpClient);
			setExecuteSelector: #executeHeaders
			initialize
]

{ #category : 'instance creation' }
Guzzler class >> new_http [

	^ self makeHttpClient loggingOff
]

{ #category : 'instance creation' }
Guzzler class >> new_https [

	^ self makeHttpClient loggingOff
]

{ #category : 'instance creation' }
Guzzler class >> new_mock [

	^ (self basicNew)
	    setHttpClient: (self makeHttpClient);
			setExecuteSelector: #executeMock
			initialize
]

{ #category : 'instance creation' }
Guzzler class >> new_unhttps [
 
"todo:
	Unified Http(s)
	
	Performs an https request, but merges the response headers into the return json payload
	if some clients might find that useful.
	
	The merged payload concept may also be useful when adopting non http transports.
"
	^ (self basicNew)
	    setHttpClient: (self makeHttpClient);
			setExecuteSelector: #executeUnified
			initialize
]

{ #category : 'accessing' }
Guzzler >> contents [ 

	^ contents ifNil: [ httpClient contents ]
]

{ #category : 'accessing' }
Guzzler >> doesNotUnderstand: aMessage [

	"delegation"
	
	^ aMessage sendTo: httpClient
]

{ #category : 'accessing' }
Guzzler >> execute [

	self perform: executeSelector
]

{ #category : 'accessing' }
Guzzler >> executeEcho [

	contents := httpClient url readStream skipTo: $:; upToEnd. 
]

{ #category : 'accessing' }
Guzzler >> executeHeaders [

	data := httpClient request headers headers.
	
	contents := STONJSON toString: data.
]

{ #category : 'accessing' }
Guzzler >> executeMock [

	| classNameFromUrl aMocker urlStr methodFromUrl theRest |
	
	"mock:Faker/endpoint/etc"
	
	urlStr := httpClient url readStream.
	
	classNameFromUrl := urlStr skipTo: $:; upTo: $/.
	
	methodFromUrl := ('mock_',((urlStr upTo: $?) replaceAll: '/' with: '_'), ':') asSymbol.
	
	theRest := urlStr upToEnd.
	
	aMocker := #class:// classNameFromUrl.
	
	contents :=  aMocker perform: methodFromUrl with: theRest
	
]

{ #category : 'accessing' }
Guzzler >> response [ 

	^  httpClient response  
]

{ #category : 'accessing' }
Guzzler >> setExecuteSelector: anObject [
	executeSelector := anObject
]

{ #category : 'accessing' }
Guzzler >> setHttpClient: anObject [
	httpClient := anObject
]
