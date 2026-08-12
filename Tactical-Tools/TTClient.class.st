Class {
	#name : 'TTClient',
	#superclass : 'Object',
	#instVars : [
		'vault'
	],
	#category : 'Tactical-Tools-Clients',
	#package : 'Tactical-Tools',
	#tag : 'Clients'
}

{ #category : 'accessing' }
TTClient class >> appVaultSearch [

	^ #((options #clientId) #(config))
]

{ #category : 'as yet unclassified' }
TTClient class >> clientId [

	^ (self name withoutSuffix: 'TT') asLowercase
]

{ #category : 'as yet unclassified' }
TTClient class >> makeVault [

^ TTVault newEmpty
]

{ #category : 'as yet unclassified' }
TTClient >> getUser [

^ vault user
]

{ #category : 'accessing' }
TTClient >> setVault: anObject [
	vault := anObject.
	vault setSearch: self class appVaultSearch
]

{ #category : 'accessing' }
TTClient >> vault [
	^ vault ifNil: [ vault := self class makeVault ]
]
