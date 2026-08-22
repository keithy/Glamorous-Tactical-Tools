Class {
	#name : 'SRLUrl',
	#superclass : 'SRLRequestAbstract',
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
SRLUrl class >> url: aVarName [

	"local shortcut"
	^ self new resolve: aVarName
   
    
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

	^ self getOutputProvider asDictionary
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
SRLUrl >> getOutputProvider [

	^ self clientClass // self clientArgString
	
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

	^ self getOutputProvider contents
	
]
