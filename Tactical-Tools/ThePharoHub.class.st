Class {
	#name : 'ThePharoHub',
	#superclass : 'TheHub',
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'wall' }
ThePharoHub class >> fileLocatorFrom: aString [

  <ttWall>

	"Answer a  FileLocator from the supplied string"

	^ FileLocator fromPath: (self fileReferenceFrom: aString) path ifNone: [ self error: '?' ]
	
]

{ #category : 'wall' }
ThePharoHub class >> fileReferenceFrom: aString [

  <ttWall>

	"Answer a FileReference or FileLocator from the supplied string.
	FileLocator origins are available as formatted strings, e.g.
		{home}/lepiter
	is the equivalent of
		FileLocator home / 'lepiter'"

	| namedDirectories regex dirName path |

	namedDirectories := self namedFileLocations. 
	
	regex := '\{([a-zA-Z]+)\}(.*)' asRegex.
	
	^ (regex matches: aString) 
			ifFalse: [ aString asFileReference ]
			ifTrue: [ 
				dirName := regex subexpression: 2.
				path := regex subexpression: 3.
				namedDirectories at: dirName
					ifPresent: [ :locator | path ifEmpty: [ locator resolve ] ifNotEmpty: [ locator resolve resolve: path allButFirst ] ]
					ifAbsent: [ self error: 'Unknown directory: ', dirName printString ] ]
	
]

{ #category : 'wall' }
ThePharoHub class >> httpClientMaximumEntitySize [

	<ttWall>
	
	^ self signalAuto
		
]

{ #category : 'environment' }
ThePharoHub class >> httpClientOptions [
	
	^ self signalAuto
]

{ #category : 'environment' }
ThePharoHub class >> iceCredentialsStore [

	"Credentials (iceberg/git)"
	
	<ttSpoke>

		^ IceCredentialStore current
]

{ #category : 'environment' }
ThePharoHub class >> iceRepositories [

	^ self signalAuto

]

{ #category : 'environment' }
ThePharoHub class >> iceRepositoryIncludesPackageNamed: aPackage [

	"public interface to repositories list (testable)
		 
	TheHub current for: #iceRepositories respondWith: { ... } during: [ .. ]"
	
	^ self iceRepositories 
		detect: [ :repository | repository includesPackageNamed: aPackage name ]
		ifNone: [ nil ]
		
]

{ #category : 'environment' }
ThePharoHub class >> iceRepositoryNamed: aString [
	
	"public interface to repositories list (testable)
	
	 TheHub current for: #iceRepositories respondWith: { ... } during: [ .. ]"
	
		^ self iceRepositories 
		
		detect: [ :each | each name = aString ]
		ifNone: [ nil ]
	 
]

{ #category : 'environment' }
ThePharoHub class >> openFileBrowser [

	"Current Working Directory"
	
	<ttSpoke>
	
	^ '.' asFileReference
]

{ #category : 'environment' }
ThePharoHub class >> platform [

  "Grease Platform"
  
	<ttWall>
	
	^ GRPlatform current 
	
]

{ #category : 'as yet unclassified' }
ThePharoHub >> getClassNamespaceSearchPath [

	^ #(Pharo)
]

{ #category : 'as yet unclassified' }
ThePharoHub >> httpClientMaximumEntitySize [
	
	^ ZnCurrentOptions at: #maximumEntitySize
]

{ #category : 'environment' }
ThePharoHub >> namedFileLocations [
 
   "Named file locations"

   <ttSpoke>

 	^ FileLocator  namedFileLocations
	
]

{ #category : 'wall' }
ThePharoHub >> platform [

	^ GRPlatform current 
	
]
