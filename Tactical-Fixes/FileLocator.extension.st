Extension { #name : 'FileLocator' }

{ #category : '*Tactical-Fixes' }
FileLocator class >> gtLocations [

 "supported origins derived from pragmas may have cached stale results"

 	^ (self supportedOrigins 
		select: [ :aSelector | (self respondsTo: aSelector) ifTrue: true ifFalse: [ Transcript crShow: 'oops'. false ] ] thenCollect: [ :aSelector | self perform: aSelector ]) asArray
]

{ #category : '*Tactical-Fixes' }
FileLocator class >> gtLocationsNew [

	| origins |
	
		origins := OrderedCollection new.
		
 	FileLocator supportedOriginsDo: [ :resolver :selector | 
		 	(resolver respondsTo: selector) 
		 		ifTrue: [ origins add: (resolver perform: selector) ]
		 		ifFalse: [  Transcript crShow: thisContext shortDebugStack ]
	 ].
	 
	^ origins

]

{ #category : '*Tactical-Fixes' }
FileLocator class >> supportedOriginsDo: aBlock [
	
	"Improved mechanism than supportedOrigins"
	
	| current |
	 
	current := Resolver.
	[current isNotNil] whileTrue:
		[ current supportedOriginsDo: aBlock.
		  current := current next].
	
]
