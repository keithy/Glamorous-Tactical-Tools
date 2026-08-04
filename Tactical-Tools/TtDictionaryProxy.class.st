Class {
	#name : 'TtDictionaryProxy',
	#superclass : 'DictionaryTiered',
	#instVars : [
		'source'
	],
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'as yet unclassified' }
TtDictionaryProxy class >> newNamed: aName fromSource: aSource [
	
		^ (self newNamed: aName)
			  source: aSource;
			  readSource
]

{ #category : 'accessing' }
TtDictionaryProxy >> source [
	^ source
]

{ #category : 'accessing' }
TtDictionaryProxy >> source: anObject [
	source := anObject
]
