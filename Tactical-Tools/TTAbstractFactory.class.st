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
TTAbstractFactory class >> makeVault [
]

{ #category : 'as yet unclassified' }
TTAbstractFactory >> configName [

^ self name
]

{ #category : 'as yet unclassified' }
TTAbstractFactory >> name [

^ self subclassResponsibility
]
