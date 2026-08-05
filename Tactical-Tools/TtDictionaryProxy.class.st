Class {
	#name : 'TTDictionaryProxy',
	#superclass : 'TTDictionaryTiered',
	#instVars : [
		'source'
	],
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'as yet unclassified' }
TTDictionaryProxy class >> newNamed: aName fromSource: aSource [
	
		^ (self newNamed: aName)
			  source: aSource;
			  readSource
]

{ #category : 'accessing' }
TTDictionaryProxy >> source [
	^ source
]

{ #category : 'accessing' }
TTDictionaryProxy >> source: anObject [
	source := anObject
]
