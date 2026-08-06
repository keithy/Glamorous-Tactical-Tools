Extension { #name : 'FileLocator' }

{ #category : '*Tactical-Fixes' }
FileLocator class >> gtLocations [
	^ self supportedOrigins 
		collect: [ :aSelector | self origin: aSelector ]
		as: Array
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
FileLocator class >> gtLocationsOld [

 "supported origins derived from pragmas may have cached stale results"

 	^ (self supportedOrigins 
		select: [ :aSelector | (self respondsTo: aSelector) ifTrue: true ifFalse: [ Transcript crShow: ('FileLocator ', aSelector). Transcript crShow: thisContext shortDebugStack.
		 false ] ] thenCollect: [ :aSelector | self perform: aSelector ]) asArray
]

{ #category : '*Tactical-Fixes' }
FileLocator >> storeOn: aStream [
	aStream
		nextPut: $(;
		nextPutAll: self class name;
		nextPutAll: ' origin: ''';
		nextPutAll: origin;
		nextPutAll: ''')'.
		
	path
		do: [ :item | 
			aStream
				nextPutAll: ' / ''';
				nextPutAll: item;
				nextPut: $' ]
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
