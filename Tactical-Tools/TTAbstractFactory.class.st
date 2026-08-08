Class {
	#name : 'TTAbstractFactory',
	#superclass : 'Object',
	#instVars : [
		'vault'
	],
	#category : 'Tactical-Tools-Result',
	#package : 'Tactical-Tools',
	#tag : 'Result'
}

{ #category : 'as yet unclassified' }
TTAbstractFactory class >> factoryId [

^ self name withoutSuffix: 'TT'
]

{ #category : 'as yet unclassified' }
TTAbstractFactory class >> makeVault [
]
