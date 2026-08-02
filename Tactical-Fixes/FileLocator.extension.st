Extension { #name : 'FileLocator' }

{ #category : '*Tactical-Fixes' }
FileLocator class >> gtLocations [

 "supported origins derived from pragmas may have cached stale results"

 	^ (self supportedOrigins 
		select: [ :aSelector | self respondsTo: aSelector ] thenCollect: [ :aSelector | self perform: aSelector ]) asArray
]
