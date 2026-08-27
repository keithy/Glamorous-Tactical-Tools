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

{ #category : 'as yet unclassified' }
PharoˆHub class >> namespacedSearchPath [

	^ #(Pharo) copyWithAll: (super namespacedSearchPath)
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

{ #category : 'wall' }
PharoˆHub class >> secretUUID [

^ GlobalIdentifier uniqueInstance secretUUID
]

{ #category : 'as yet unclassified' }
PharoˆHub >> httpClientMaximumEntitySize [
	
	^ ZnCurrentOptions at: #maximumEntitySize
]

{ #category : 'wall' }
PharoˆHub >> platform [

	^ GRPlatform current 
	
]
