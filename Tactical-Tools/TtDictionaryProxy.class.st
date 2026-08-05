Class {
	#name : 'TTDictionaryProxy',
	#superclass : 'TTDictionaryTiered',
	#instVars : [
		'source'
	],
	#classInstVars : [
		'suffixReaderMap'
	],
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'accessing' }
TTDictionaryProxy >> at: key putReading: value [

	^ valueWriter fromProxyAt: key put: value
]

{ #category : 'accessing' }
TTDictionaryProxy >> readSource [

	^ self subclassResponsibility

]

{ #category : 'accessing' }
TTDictionaryProxy >> readSource: aSource [

	self source: aSource.
	self readSource. 
]

{ #category : 'accessing' }
TTDictionaryProxy >> source [
	^ source
]

{ #category : 'accessing' }
TTDictionaryProxy >> source: anObject [
	source := anObject
]
