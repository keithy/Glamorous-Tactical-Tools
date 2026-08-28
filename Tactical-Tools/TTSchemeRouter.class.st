Class {
	#name : 'TTSchemeRouter',
	#superclass : 'Object',
	#instVars : [
		'executeSelector',
		'httpClient',
		'contents',
		'data',
		'requestErrorHandler'
	],
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'as yet unclassified' }
TTSchemeRouter class >> // aUrl [
	 
	^ self newForUrl: aUrl

]

{ #category : 'instance creation' }
TTSchemeRouter class >> classApiRequest [

	^ #class://#'ˆApiRequest'
]

{ #category : 'as yet unclassified' }
TTSchemeRouter class >> http: aUrl [
	| url |

		url := (aUrl includesSubstring: 'http://')
			ifFalse: [ 'http://' , aUrl ]
			ifTrue: [ aUrl ].
	^ self newForUrl: aUrl

]

{ #category : 'as yet unclassified' }
TTSchemeRouter class >> https: aUrl [
	| url |
	url := (aUrl includesSubstring: 'https://')
			ifFalse: [ 'https://' , aUrl ]
			ifTrue: [ aUrl ].
	^ self newForUrl: url
]

{ #category : 'instance creation' }
TTSchemeRouter class >> makeFileClient [ 

  ^ (#class://'ˆFileClient') new
]

{ #category : 'instance creation' }
TTSchemeRouter class >> makeHttpClient [ 

  ^ (#class://#'ˆHttpClient') new
]

{ #category : 'instance creation' }
TTSchemeRouter class >> new [ 

  "Normally we are a stand in for Zinc"
  
  ^ self error: 'Not actually ZnClient'
]

{ #category : 'instance creation' }
TTSchemeRouter class >> newForScheme: aScheme [ 

  "In this case we have a chance to work OUR magic"
   
  
	^ self askFor:('new_', aScheme) asSymbol ifAbsent: [ self srlForScheme: aScheme ]
]

{ #category : 'instance creation' }
TTSchemeRouter class >> newForUrl: aUrl [ 

  "In this case we have a chance to work OUR magic"
  
	^ (self newForScheme: (aUrl copyUpTo: $:)) url: aUrl
]

{ #category : 'instance creation' }
TTSchemeRouter class >> new_L1http [

	^ self makeHttpClient logLevel: 1
]

{ #category : 'instance creation' }
TTSchemeRouter class >> new_L2http [

	^ self makeHttpClient logLevel: 2
]

{ #category : 'instance creation' }
TTSchemeRouter class >> new_L3http [

	^ self makeHttpClient logLevel: 3
]

{ #category : 'instance creation' }
TTSchemeRouter class >> new_T1http [

	^ self makeHttpClient logToTranscript; logLevel: 1
]

{ #category : 'instance creation' }
TTSchemeRouter class >> new_T2http [

	^ self makeHttpClient logToTranscript; logLevel: 2
]

{ #category : 'instance creation' }
TTSchemeRouter class >> new_T3http [

	^ self makeHttpClient logToTranscript; logLevel: 3
]

{ #category : 'instance creation' }
TTSchemeRouter class >> new_echo [

	^ (self basicNew)
	    setHttpClient: (self makeHttpClient);
			setExecuteSelector: #echo
			initialize
]

{ #category : 'instance creation' }
TTSchemeRouter class >> new_headers [

	^ (self basicNew)
	    setHttpClient: (self makeHttpClient);
			setExecuteSelector: #executeHeaders
			initialize
]

{ #category : 'instance creation' }
TTSchemeRouter class >> new_http [

	^ self makeHttpClient loggingOff
]

{ #category : 'instance creation' }
TTSchemeRouter class >> new_https [

	^ self makeHttpClient loggingOff
]

{ #category : 'instance creation' }
TTSchemeRouter class >> new_mock [

	^ (self basicNew)
	    setHttpClient: (self makeHttpClient);
			setExecuteSelector: #executeMock
			initialize
]

{ #category : 'instance creation' }
TTSchemeRouter class >> new_unhttps [
 
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

{ #category : 'instance creation' }
TTSchemeRouter class >> srlForScheme: aScheme [ 

   ^ SRLRouter fromSymbol: (aScheme,':') asSymbol 

 
]

{ #category : 'accessing' }
TTSchemeRouter >> contents [ 

	^ contents ifNil: [ httpClient contents ]
]

{ #category : 'accessing' }
TTSchemeRouter >> doesNotUnderstand: aMessage [

	"delegation"
	
	^ aMessage sendTo: httpClient
]

{ #category : 'accessing' }
TTSchemeRouter >> execute [

	self perform: executeSelector
]

{ #category : 'accessing' }
TTSchemeRouter >> executeEcho [

	contents := httpClient url readStream skipTo: $:; upToEnd. 
]

{ #category : 'accessing' }
TTSchemeRouter >> executeHeaders [

	data := httpClient request headers headers.
	
	contents := STONJSON toString: data.
]

{ #category : 'accessing' }
TTSchemeRouter >> executeMock [

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
TTSchemeRouter >> response [ 

	^  httpClient response  
]

{ #category : 'accessing' }
TTSchemeRouter >> setExecuteSelector: anObject [
	executeSelector := anObject
]

{ #category : 'accessing' }
TTSchemeRouter >> setHttpClient: anObject [
	httpClient := anObject
]
