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

{ #category : 'as yet unclassified' }
TTClient class >> makeVault [

^ TTVault newEmpty
]

{ #category : 'accessing' }
TTClient >> setVault: anObject [
	vault := anObject
]

{ #category : 'accessing' }
TTClient >> vault [
	^ vault ifNil: [ vault := self class makeVault ]
]
