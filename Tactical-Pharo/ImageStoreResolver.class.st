Class {
	#name : 'ImageStoreResolver',
	#superclass : 'FileSystemResolver',
	#category : 'Tactical-Pharo-Image-Store',
	#package : 'Tactical-Pharo',
	#tag : 'Image-Store'
}

{ #category : 'resolving' }
ImageStoreResolver class >> initialize [

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
			
			selector = aSymbol ifTrue: [ ^ storeClass perform: selector ]
	
	].
					
	^ self unknownOrigin: aSymbol
	
]

{ #category : 'resolving' }
ImageStoreResolver >> supportedOrigins [

	| origins |
	
	origins := OrderedCollection new.
	
	ImageStore withAllSubclassesDo: [ :c | 
	
				(Pragma allNamed: #origin in: c class) do: [:pragma | 
		
					"class pragma"
					origins add: pragma methodSelector
				]
  	].

  ^ origins asArray
	 
]

{ #category : 'resolving' }
ImageStoreResolver >> supportedOriginsDo: aBlock [

		ImageStore withAllSubclassesDo: [ :c | 
	
				(Pragma allNamed: #origin in: c class) do: [:pragma | 
		
				"class pragma"
				aBlock value: c value: pragma methodSelector ]
  	].


]
