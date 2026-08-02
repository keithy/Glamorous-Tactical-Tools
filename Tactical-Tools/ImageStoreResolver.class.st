Class {
	#name : 'ImageStoreResolver',
	#superclass : 'FileSystemResolver',
	#category : 'Tactical-Tools-Image-Store',
	#package : 'Tactical-Tools',
	#tag : 'Image-Store'
}

{ #category : 'as yet unclassified' }
ImageStoreResolver >> resolve: aSymbol [
	
	self class withAllSubclassesDo: [ :c | 
	
					c name == aSymbol ifTrue: [ ^ c currentFileSystem ]
					
	].
					
	^ self unknownOrigin: aSymbol
	
]

{ #category : 'resolving' }
ImageStoreResolver >> supportedOrigins [
	^ self class withAllSubclasses collect: [ :c | c name ]
	 
]
