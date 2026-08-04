Class {
	#name : 'TtVault',
	#superclass : 'Object',
	#instVars : [
		'kvStore'
	],
	#classInstVars : [
		'currentVault'
	],
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'instance creation' }
TtVault class >> currentVault [

^ currentVault ifNil: [ currentVault := self new ]
]
