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
	^ (#url: //  'https://httpbin.org/json') asDictionary
]

{ #category : 'as yet unclassified' }
SRLUrl class >> url: aVarName [

	"local shortcut"
	^ self new resolve: aVarName
   
    
]

{ #category : 'accessing' }
SRLUrl >> +/ anEndpoint [
	
	"deferred #url:// ClientClass / anEndpoint"
	^ self clientClass/ anEndpoint 
	
]

{ #category : 'accessing' }
SRLUrl >> +// aHostUrl [
 	
 	"deferred #url:// ClientClass // anEndpoint"
	^ self clientClass// aHostUrl 
	
]

{ #category : 'accessing' }
SRLUrl >> asDictionary [

	^ (self clientClass // self clientArgString) asDictionary
	
]

{ #category : 'accessing' }
SRLUrl >> asString [

	^ (self clientClass // self clientArgString) asString
	
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
	
	^ (SRLClass class: #TTApiThinClient) -> aThing

]
