Class {
	#name : 'TTClientAbstract',
	#superclass : 'Object',
	#instVars : [
		'vault'
	],
	#category : 'Tactical-Tools-Clients',
	#package : 'Tactical-Tools',
	#tag : 'Clients'
}

{ #category : 'as yet unclassified' }
TTClientAbstract class >> asHub [
	
	"Any Client class can be a hub on its own resources"
	
  ^ TheHub current newBrowsing: self
]

{ #category : 'accessing' }
TTClientAbstract class >> basicNew [
   self isAbstract ifTrue: [ self error:self name, ' is abstract' ].
 ^ super basicNew
]

{ #category : 'factory' }
TTClientAbstract class >> basicNewForFactory: aFactory ifFail: fBlock [
	
	"the failblock pattern allows subclasses to inherit the whole method
	 and build upon what we have here, rather than replace it"

	(self vaultHasWhatINeed: aFactory vault) ifFalse: [ ^ fBlock value ].
	
	^ (self basicNew)
				setVault: ((aFactory vault copy) 
											appKey: self vaultAppKey;
											optionsSelect: #default;
											refresh;
											yourself);
				yourself


]

{ #category : 'as yet unclassified' }
TTClientAbstract class >> clientId [

	^ ((self name withoutPrefix: 'TT') withoutSuffix: 'Client') asLowercase
]

{ #category : 'accessing' }
TTClientAbstract class >> isAbstract [

	^ self == TTClientAbstract
]

{ #category : 'as yet unclassified' }
TTClientAbstract class >> makeVaultEmpty [

^ TTVault newEmpty
]

{ #category : 'accessing' }
TTClientAbstract class >> vaultAppKey [

	^ self clientId
]

{ #category : 'accessing' }
TTClientAbstract class >> vaultHasWhatINeed: aFactoryVault [

	^ aFactoryVault lookupHasFields: #(url)
]

{ #category : 'as yet unclassified' }
TTClientAbstract >> getUser [

^ vault user
]

{ #category : 'accessing' }
TTClientAbstract >> gtOptionsFor: aView [
	<gtView>
	^ aView forward
		title: 'Options';
		priority: 5;
		object: [ self vault ];
		view: #gtOptionsFor:
]

{ #category : 'accessing' }
TTClientAbstract >> gtVaultViewFor: aView [
	<gtView>
	^ aView forward
		title: 'Vault';
		priority: 10;
		object: [ self vault ];
		view: #gtRawFor:
]

{ #category : 'factory' }
TTClientAbstract >> initializeForFactory: aFactory ifFail: fBlock [

	^ self initialize


]

{ #category : 'accessing' }
TTClientAbstract >> setVault: aVault [
	vault := aVault  
]

{ #category : 'accessing' }
TTClientAbstract >> vault [
	^ vault ifNil: [ vault := self class makeVaultEmpty ]
]

{ #category : 'accessing' }
TTClientAbstract >> vaultAppKey [

	^ self class vaultAppKey
]
