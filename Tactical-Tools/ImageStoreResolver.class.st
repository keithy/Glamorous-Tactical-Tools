Class {
	#name : 'ImageStoreResolver',
	#superclass : 'FileSystemResolver',
	#category : 'Tactical-Tools-Image-Store',
	#package : 'Tactical-Tools',
	#tag : 'Image-Store'
}

{ #category : 'resolving' }
ImageStoreResolver class >> initialize [
	"FileLocator is needed to initialize SystemSettingsPersistence (call to FileLocator>>#preferences),
	and could be useful for other classes.
	Let initialize FileLocator before other standard system classes."
	SessionManager default
		registerSystemClassNamed: self name atPriority: 91.
	self startUp: true
]

{ #category : 'resolving' }
ImageStoreResolver class >> startUp: resuming [
	resuming
		ifFalse: [ ^ self ].
 
	FileLocator addResolver: self new.
]

{ #category : 'resolving' }
ImageStoreResolver >> addResolver: aResolver [

	"We only need ImageStoreResolver once"
	aResolver class == self class ifTrue: [ ^ self ].
	
  super addResolver: aResolver.
	
	
]

{ #category : 'resolving' }
ImageStoreResolver >> resolve: aSymbol [
	
	self supportedOriginsDo: [ :storeClass :selector |
			
			selector == aSymbol ifTrue: [ ^ storeClass perform: selector ]
	
	].
					
	^ self unknownOrigin: aSymbol
	
]

{ #category : 'resolving' }
ImageStoreResolver >> supportedOrigins [
	^ ImageStore withAllSubclasses collect: [ :c | c name ]
	 
]
