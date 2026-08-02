Class {
	#name : 'ImageStore',
	#superclass : 'MemoryStore',
	#classInstVars : [
		'imageStoreFS'
	],
	#category : 'Tactical-Tools-Image-Store',
	#package : 'Tactical-Tools',
	#tag : 'Image-Store'
}

{ #category : 'as yet unclassified' }
ImageStore class >> currentFileSystem [
	^ imageStoreFS ifNil: [ imageStoreFS := FileSystem store: self new ]
]

{ #category : 'as yet unclassified' }
ImageStore class >> imageFileSystemsInfo [
	
	"Filesystems persisted in-image (all)"
	
	<ttSpoke>

	^ (self withAllSubclasses collect: [ :c |
			(c name, ' currentFileSystem') -> c imageStoreFS
	]) asDictionary at: 'MemoryStore currentFileSystem' put: CurrentFS; yourself 
]

{ #category : 'as yet unclassified' }
ImageStore class >> imageStoreFS [

	^ imageStoreFS
]

{ #category : 'as yet unclassified' }
ImageStore class >> reset [
	imageStoreFS := nil
]

{ #category : 'as yet unclassified' }
ImageStore class >> resetIfEmpty [
	
	imageStoreFS ifNil: [ ^ self ].
	
	imageStoreFS root entries ifEmpty: [ imageStoreFS := nil ]

]

{ #category : 'as yet unclassified' }
ImageStore class >> shutDown [

	self resetIfEmpty
]

{ #category : 'as yet unclassified' }
ImageStore >> origin [

	^ self name 
]

{ #category : 'as yet unclassified' }
ImageStore >> startUp [
	"dont self reset"
]
