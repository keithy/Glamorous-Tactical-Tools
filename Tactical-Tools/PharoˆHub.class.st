Class {
	#name : 'PharoˆHub',
	#superclass : 'Hub',
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'wall' }
PharoˆHub class >> fileLocatorFrom: aString [

  <ttWall>

	"Answer a  FileLocator from the supplied string"

	^ FileLocator fromPath: (#file: // aString) path ifNone: [ self error: '?' ]
	
]

{ #category : 'wall' }
PharoˆHub class >> fileReferenceFromString: aString [

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
PharoˆHub class >> httpClientMaximumEntitySize [

	<ttWall>
	
	^ self signalAuto
		
]

{ #category : 'environment' }
PharoˆHub class >> httpClientOptions [
	
	^ self signalAuto
]

{ #category : 'environment' }
PharoˆHub class >> iceCredentialsStore [

	"Credentials (iceberg/git)"
	
	<ttSpoke>

		^ IceCredentialStore current
]

{ #category : 'environment' }
PharoˆHub class >> iceRepositories [

	^ self signalAuto

]

{ #category : 'environment' }
PharoˆHub class >> iceRepositoryIncludesPackageNamed: aPackage [

	"public interface to repositories list (testable)
		 
	TheHub current for: #iceRepositories respondWith: { ... } during: [ .. ]"
	
	^ self iceRepositories 
		detect: [ :repository | repository includesPackageNamed: aPackage name ]
		ifNone: [ nil ]
		
]

{ #category : 'environment' }
PharoˆHub class >> iceRepositoryNamed: aString [
	
	"public interface to repositories list (testable)
	
	 TheHub current for: #iceRepositories respondWith: { ... } during: [ .. ]"
	
		^ self iceRepositories 
		
		detect: [ :each | each name = aString ]
		ifNone: [ nil ]
	 
]

{ #category : 'environment' }
PharoˆHub class >> openFileBrowser [

	"Current Working Directory"
	
	<ttSpoke>
	
	^ '.' asFileReference
]

{ #category : 'environment' }
PharoˆHub class >> platform [

  "Grease Platform"
  
	<ttWall>
	
	^ GRPlatform current 
	
]

{ #category : 'as yet unclassified' }
PharoˆHub >> httpClientMaximumEntitySize [
	
	^ ZnCurrentOptions at: #maximumEntitySize
]

{ #category : 'environment' }
PharoˆHub >> namedFileLocations [
 
   "Named file locations"

   <ttSpoke>

 	^ FileLocator  namedFileLocations
	
]

{ #category : 'as yet unclassified' }
PharoˆHub >> namespacedSearchPath [

	^ #(Pharo)
]

{ #category : 'wall' }
PharoˆHub >> platform [

	^ GRPlatform current 
	
]
