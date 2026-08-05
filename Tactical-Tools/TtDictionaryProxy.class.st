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
TTDictionaryProxy class >> valueAsCyphered: aString [

	self notYetImplemented.
	
	^ (TTStringEncoded newFrom: aString) beBase64
 
]

{ #category : 'as yet unclassified' }
TTDictionaryProxy class >> valueAsEncoded: aString [

	^ (TTStringEncoded newFrom: aString) beBase64
 
]

{ #category : 'as yet unclassified' }
TTDictionaryProxy class >> valueAsObfuscated: aString [

	^ TTStringObfuscated newFrom: aString
 
]

{ #category : 'as yet unclassified' }
TTDictionaryProxy class >> valueAsString: aString [

	^ aString
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
