Class {
	#name : 'TheGlamorousHub',
	#superclass : 'TheHub',
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'environment' }
TheGlamorousHub class >> gitRepositories [
	
	"the list of repositories registered with the git tool"
	^ self signalAuto

]

{ #category : 'environment' }
TheGlamorousHub class >> gtImage [

	^ GtImage instance
]

{ #category : 'environment' }
TheGlamorousHub class >> iceCredentialsStore [
	
	^ IceCredentialStore current
]

{ #category : 'environment' }
TheGlamorousHub class >> iceRegistry [
	
	"the list of repositories registered with the git tool"
	^ self signalAuto

]

{ #category : 'environment' }
TheGlamorousHub class >> iceRepositories [
	
	"the list of repositories registered with the git tool"
	^ self signalAuto

]

{ #category : 'environment' }
TheGlamorousHub class >> iceRepositoryIncludesPackageNamed: aPackage [

	"public interface to repositories list (testable)
		 
	TheHub current for: #iceRepositories respondWith: { ... } during: [ .. ]"
	
	^ self iceRepositories 
		detect: [ :repository | repository includesPackageNamed: aPackage name ]
		ifNone: [ nil ]
		
]

{ #category : 'environment' }
TheGlamorousHub class >> iceRepositoryNamed: aString [
	
	"public interface to repositories list (testable)
	
	 TheHub current for: #iceRepositories respondWith: { ... } during: [ .. ]"
	
		^ self iceRepositories 
		
		detect: [ :each | each name = aString ]
		ifNone: [ nil ]
	 
]

{ #category : 'environment' }
TheGlamorousHub class >> icebergRegistry [
	
	"the list of repositories registered with the git tool"
	^ self signalAuto

]

{ #category : 'environment' }
TheGlamorousHub class >> lepiter [

	^ self signalAuto
]

{ #category : 'environment' }
TheGlamorousHub class >> lepiterPropertiesFile [

	"this is where duplicates may be defined"
	^ self lepiter properties localFile
]

{ #category : 'environment' }
TheGlamorousHub class >> lepiterReload [

	"re-read batabases defined in the the properties file"
	^ self lepiter reload
]

{ #category : 'environment' }
TheGlamorousHub class >> onStartUpBidToBeCurrentHubClass [
	
	(self classNamed: #GtImage ifAbsent: [ ^ 0 ]).
	
	^ 20 
]

{ #category : 'environment' }
TheGlamorousHub >> gitRepositories [
	
	"the list of repositories registered with the git tool"
	^ IceRepository gtGitRepositories
]

{ #category : 'environment' }
TheGlamorousHub >> iceRegistry [
	
	"the Ice Repository manager"
	^ IceRepository 
]

{ #category : 'environment' }
TheGlamorousHub >> iceRepositories [
	
	 "the list of repositories registered with the git tool"
	^ IceRepository repositories
]

{ #category : 'environment' }
TheGlamorousHub >> lepiter [

	^ LeDatabasesRegistry defaultLogicalDatabase
]
