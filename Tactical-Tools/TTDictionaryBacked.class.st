Class {
	#name : 'TTDictionaryBacked',
	#superclass : 'Dictionary',
	#instVars : [
		'source',
		'valueWriter'
	],
	#classInstVars : [
		'suffixReaderMap'
	],
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'accessing' }
TTDictionaryBacked >> at: key write: value [

	^ valueWriter dict: self at: key write: value
]

{ #category : 'accessing' }
TTDictionaryBacked >> isBacked [

	^ true
]

{ #category : 'accessing' }
TTDictionaryBacked >> readSource [

	^ self subclassResponsibility

]

{ #category : 'accessing' }
TTDictionaryBacked >> readSource: aSource [
	
	self removeAll.
	self source: aSource.
	self readSource. 
]

{ #category : 'accessing' }
TTDictionaryBacked >> source [
	^ source
]

{ #category : 'accessing' }
TTDictionaryBacked >> source: anObject [
	source := anObject
]

{ #category : 'accessing' }
TTDictionaryBacked >> valueWriter [
	^ valueWriter
]

{ #category : 'accessing' }
TTDictionaryBacked >> valueWriter: anObject [
  
	valueWriter := anObject
]
