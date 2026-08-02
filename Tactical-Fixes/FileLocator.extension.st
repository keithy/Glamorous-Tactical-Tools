Extension { #name : 'FileLocator' }

{ #category : '*Tactical-Fixes' }
FileLocator class >> gtLocations [

 "supported origins derived from pragmas may have cached stale results"

 	^ (self supportedOrigins 
		select: [ :aSelector | (self respondsTo: aSelector) ifTrue: true ifFalse: [ Transcript crShow: 'oops'. false ] ] thenCollect: [ :aSelector | self perform: aSelector ]) asArray
]
