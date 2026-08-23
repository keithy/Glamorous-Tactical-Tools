Class {
	#name : 'SRLUrl',
	#superclass : 'SRLRouter',
	#category : 'Tactical-SRL-Schemes',
	#package : 'Tactical-SRL',
	#tag : 'Schemes'
}

{ #category : 'as yet unclassified' }
SRLUrl class >> canRoute: aSymbol [
 
	^ #(url: http: https: #client:) includes: aSymbol
]

{ #category : 'as yet unclassified' }
SRLUrl class >> example [
	<gtExample>
	
	| unresolved resolved output contents parsed|
	unresolved :=  #url: //  'https://httpbin.org/json'. 
	resolved := unresolved resolve.
	
	"it doesnt resolve untl used"
	self assert: [ resolved == unresolved ].
	
	output := resolved output.
	
	"SRLUrl is its own output object"
	self assert: [ output == resolved ].
	
	contents := resolved getVerifiedContents.
	
	self assert: [ contents first == ${ ].
	parsed := resolved asDictionary.
	
	self assert: [ parsed size = 1 ].
]

{ #category : 'as yet unclassified' }
SRLUrl class >> exampleWithResult [
	<gtExample>
		
	| srl request result |
	srl :=  #url: //  'https://httpbin.org/json'. 
	
	result := 	srl getResult.
	
	self assert: [ (srl getRawContents) = (result getRawContents) ].
 
]

{ #category : 'as yet unclassified' }
SRLUrl class >> makeResult [

	^ TTApiResult new
]

{ #category : 'accessing' }
SRLUrl >> +/ anEndpoint [
	
	"deferred #url:// ClientClass / anEndpoint"
	^ (self clientClass // self clientArgString) / anEndpoint 
	
]

{ #category : 'accessing' }
SRLUrl >> +// aHostUrl [
 	
 	"deferred #url:// ClientClass // anEndpoint"
	^ self clientClass// aHostUrl 
	
]

{ #category : 'accessing' }
SRLUrl >> asDictionary [

	^ Dictionary // self 
	
]

{ #category : 'accessing' }
SRLUrl >> asResult [

	^ TTResult // self
	
]

{ #category : 'accessing' }
SRLUrl >> clientArgString [

	^ resolved value
]

{ #category : 'accessing' }
SRLUrl >> clientClass [

	^ resolved key
]

{ #category : 'accessing' }
SRLUrl >> contents [

	^ self stdout
	
]

{ #category : 'accessing' }
SRLUrl >> output [
	"the object responsible for providing output"
	^ (self clientClass) // (self clientArgString)
	
]

{ #category : 'accessing' }
SRLUrl >> resolve [

	resolved := self resolve: thing.
	
	"returns self for deferred action"
	^ self 
]

{ #category : 'accessing' }
SRLUrl >> resolve: aThing [

	"returns class and string for #resolve"
	
	(aThing isClass or: [ aThing isSymbol ])
		ifTrue: [ 
			^ (SRLClass class: aThing) -> ''
		].	
	
	^ (SRLClass class: #TTApiClient) -> aThing

]

{ #category : 'accessing' }
SRLUrl >> stdout [

	^ self output  stdout
	
]
