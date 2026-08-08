Class {
	#name : 'TTAbstractFactory',
	#superclass : 'Object',
	#instVars : [
		'vault'
	],
	#category : 'Tactical-Tools-Clients',
	#package : 'Tactical-Tools',
	#tag : 'Clients'
}

{ #category : 'as yet unclassified' }
TTAbstractFactory class >> factoryId [

^ self name withoutSuffix: 'TT'
]

{ #category : 'as yet unclassified' }
TTAbstractFactory class >> makeVault [
]
