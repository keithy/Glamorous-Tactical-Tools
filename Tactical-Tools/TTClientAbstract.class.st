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

{ #category : 'accessing' }
TTClientAbstract class >> appVaultSearch [

	^ #((options #clientId) #(config))
]

{ #category : 'accessing' }
TTClientAbstract class >> basicNew [
   self isAbstract ifTrue: [ self error:self name, ' is abstract' ].
 ^ super basicNew
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
TTClientAbstract class >> makeVault [

^ TTVault newEmpty
]

{ #category : 'accessing' }
TTClientAbstract class >> vaultAppKey [

	^ self clientId
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

{ #category : 'accessing' }
TTClientAbstract >> setVault: anObject [
	vault := anObject.
	vault appKey: self class vaultAppKey.
	vault refresh.
]

{ #category : 'accessing' }
TTClientAbstract >> vault [
	^ vault ifNil: [ vault := self class makeVault ]
]
