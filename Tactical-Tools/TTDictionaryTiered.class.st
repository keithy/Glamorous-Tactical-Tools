Class {
	#name : 'TTDictionaryTiered',
	#superclass : 'IdentityDictionary',
	#instVars : [
		'next',
		'beCache',
		'storeKey'
	],
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'as yet unclassified' }
TTDictionaryTiered class >> newCache [
	
		^ self new 
				storeKey: #cache;
				beCache;
				yourself
				
				 
]

{ #category : 'as yet unclassified' }
TTDictionaryTiered class >> newNamed: aName [
	
		^ self new 
				tierName: aName;
				yourself
				
				 
]

{ #category : 'as yet unclassified' }
TTDictionaryTiered class >> newWithStoreKey: aSymbol [
	
		^ self new 
				storeKey: aSymbol;
				yourself
				
				 
]

{ #category : 'accessing' }
TTDictionaryTiered class >> shutDown [

	self shutDownZapCache
]

{ #category : 'accessing' }
TTDictionaryTiered class >> shutDownZapCache [

	self allInstancesDo: [ :ea | ea isCache ifTrue: [ ea reset ]]
]

{ #category : 'accessing' }
TTDictionaryTiered >> appendTier: store [

	next ifNotNil: [ ^ next appendTier: store ].
	
	next := store.
	
	^ next
	
]

{ #category : 'accessing' }
TTDictionaryTiered >> appendTier: tier named: name [

	next ifNotNil: [ ^ self appendTier: tier named: name
 ].
	
	next := tier.
	tierName := name.
]

{ #category : 'accessing' }
TTDictionaryTiered >> beCache [

	beCache := true
]

{ #category : 'as yet unclassified' }
TTDictionaryTiered >> deepAssociationAt: key ifAbsent: absentBlock [
	"Answer the value associated with the key or, if key isn't found,
	answer the result of evaluating aBlock. Bump not found to the next tier"

	self deepAssociationAt: key ifPresent: [ :val | ^ val ].

	^ absentBlock value
]

{ #category : 'as yet unclassified' }
TTDictionaryTiered >> deepAssociationAt: key ifPresent: presentBlock [
	"Lookup the given key in the receiver. If it is present, answer the
	value of evaluating the given block optionally with the value associated
	with the key.
	Otherwise, answer nil."

	(array at: (self findElementOrNil: key)) 
	    ifNotNil: [:assoc | ^ presentBlock cull: assoc cull: storeKey ].
	
	next ifNil: [ ^ nil ].
	
	^ next deepAt: key ifPresent: presentBlock
]

{ #category : 'as yet unclassified' }
TTDictionaryTiered >> deepAt: key ifAbsent: absentBlock [
	"Answer the value associated with the key or, if key isn't found,
	answer the result of evaluating aBlock. Bump not found to the next tier"

	self deepAt: key ifPresent: [ :val | ^ val ].

	^ absentBlock value
]

{ #category : 'as yet unclassified' }
TTDictionaryTiered >> deepAt: key ifPresent: presentBlock [
	"Lookup the given key in the receiver. If it is present, answer the
	value of evaluating the given block optionally with the value associated
	with the key.
	Otherwise, answer nil."

	(array at: (self findElementOrNil: key)) ifNotNil: [:assoc | ^ presentBlock cull: assoc value cull: storeKey ].
	
	next ifNil: [ ^ nil ].
	
	^ next deepAt: key ifPresent: presentBlock
]

{ #category : 'accessing' }
TTDictionaryTiered >> initialize: n [

	super initialize: n.
  beCache ifNil: [ beCache := false ].
]

{ #category : 'accessing' }
TTDictionaryTiered >> isCache [

	^ beCache
]

{ #category : 'accessing' }
TTDictionaryTiered >> next [
	^ next
]

{ #category : 'accessing' }
TTDictionaryTiered >> reset [

	^ self removeAll
]

{ #category : 'accessing' }
TTDictionaryTiered >> storeAt: name [

	name = storeKey ifTrue: [ ^ self ].
	
	next ifNotNil: [ ^ next storeAt: name ].
	
	^ nil
]

{ #category : 'accessing' }
TTDictionaryTiered >> storeKey [
	^ storeKey
]

{ #category : 'accessing' }
TTDictionaryTiered >> storeKey: anObject [
	storeKey := anObject
]

{ #category : 'accessing' }
TTDictionaryTiered >> tierAt: name [

	name = tierName ifTrue: [ ^ self ].
	
	next ifNil: [ ^ nil ].
	
	next tierAt: name.
]

{ #category : 'accessing' }
TTDictionaryTiered >> tierName [
	^ tierName
]

{ #category : 'accessing' }
TTDictionaryTiered >> tierName: anObject [
	tierName := anObject
]
