Class {
	#name : 'DictionaryTiered',
	#superclass : 'IdentityDictionary',
	#instVars : [
		'next',
		'tierName',
		'beCache'
	],
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'as yet unclassified' }
DictionaryTiered class >> newNamed: aName [
	
		^ self new 
				tierName: aName;
				yourself
				
				 
]

{ #category : 'accessing' }
DictionaryTiered class >> shutDown [

	self shutDownZapCache
]

{ #category : 'accessing' }
DictionaryTiered class >> shutDownZapCache [

	self allInstancesDo: [ :ea | ea isCache ifTrue: [ ea reset ]]
]

{ #category : 'accessing' }
DictionaryTiered >> appendTier: tier named: name [

	next ifNotNil: [ ^ self appendTier: tier named: name
 ].
	
	next := tier.
	tierName := name.
]

{ #category : 'accessing' }
DictionaryTiered >> beCache [

	beCache := true
]

{ #category : 'as yet unclassified' }
DictionaryTiered >> deepAssociationAt: key ifAbsent: absentBlock [
	"Answer the value associated with the key or, if key isn't found,
	answer the result of evaluating aBlock. Bump not found to the next tier"

	self deepAssociationAt: key ifPresent: [ :val | ^ val ].

	^ absentBlock value
]

{ #category : 'as yet unclassified' }
DictionaryTiered >> deepAssociationAt: key ifPresent: presentBlock [
	"Lookup the given key in the receiver. If it is present, answer the
	value of evaluating the given block optionally with the value associated
	with the key.
	Otherwise, answer nil."

	(array at: (self findElementOrNil: key)) ifNotNil: [:assoc | ^ presentBlock cull: assoc cull: tierName ].
	
	next ifNil: [ ^ nil ].
	
	^ next deepAt: key ifPresent: presentBlock
]

{ #category : 'as yet unclassified' }
DictionaryTiered >> deepAt: key ifAbsent: absentBlock [
	"Answer the value associated with the key or, if key isn't found,
	answer the result of evaluating aBlock. Bump not found to the next tier"

	self deepAt: key ifPresent: [ :val | ^ val ].

	^ absentBlock value
]

{ #category : 'as yet unclassified' }
DictionaryTiered >> deepAt: key ifPresent: presentBlock [
	"Lookup the given key in the receiver. If it is present, answer the
	value of evaluating the given block optionally with the value associated
	with the key.
	Otherwise, answer nil."

	(array at: (self findElementOrNil: key)) ifNotNil: [:assoc | ^ presentBlock cull: assoc value cull: tierName ].
	
	next ifNil: [ ^ nil ].
	
	^ next deepAt: key ifPresent: presentBlock
]

{ #category : 'accessing' }
DictionaryTiered >> initialize: n [

	super initialize: n.
  beCache ifNil: [ beCache := false ].
]

{ #category : 'accessing' }
DictionaryTiered >> isCache [

	^ beCache
]

{ #category : 'accessing' }
DictionaryTiered >> next [
	^ next
]

{ #category : 'accessing' }
DictionaryTiered >> reset [

	^ self removeAll
]

{ #category : 'accessing' }
DictionaryTiered >> tierAt: name [

	name = tierName ifTrue: [ ^ self ].
	
	next ifNil: [ ^ nil ].
	
	next tierAt: name.
]

{ #category : 'accessing' }
DictionaryTiered >> tierName [
	^ tierName
]

{ #category : 'accessing' }
DictionaryTiered >> tierName: anObject [
	tierName := anObject
]
