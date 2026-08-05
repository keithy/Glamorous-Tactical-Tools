Class {
	#name : 'TTDictionaryTiered',
	#superclass : 'Dictionary',
	#instVars : [
		'next',
		'beCache',
		'tierKey'
	],
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'as yet unclassified' }
TTDictionaryTiered class >> newCache [
	
		^ self new 
				tierKey: #cache;
				beCache;
				yourself
				
				 
]

{ #category : 'as yet unclassified' }
TTDictionaryTiered class >> newWithTierKey: aSymbol [
	
		^ self new 
				tierKey: aSymbol;
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

	"double dispatch so that new tier has control 
	 or can opt out if empty"
	 
	^ store appendTierTo: self.
	
	 
]

{ #category : 'accessing' }
TTDictionaryTiered >> appendTierTo: stack [

	tierKey  ifNil: [ ^ self error: 'tierKey not set' ].
	
	stack next ifNotNil: [ ^ self appendTierTo: stack next ].
	
  stack next: self.
	
	^ self
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
	    ifNotNil: [:assoc | ^ presentBlock cull: assoc cull: tierKey ].
	
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
TTDictionaryTiered >> deepAt: key ifAbsentPut: absentBlock [
	"Answer the value associated with the key or, if key isn't found,
	put the result of evaluating aBlock."

	self deepAt: key ifPresent: [ :val | ^ val ].

	^ self at: key ifAbsentPut:absentBlock
]

{ #category : 'as yet unclassified' }
TTDictionaryTiered >> deepAt: key ifPresent: presentBlock [
	"Lookup the given key in the receiver. If it is present, answer the
	value of evaluating the given block optionally with the value associated
	with the key.
	Otherwise, answer nil."

	(array at: (self findElementOrNil: key)) ifNotNil: [:assoc | ^ presentBlock cull: assoc value cull: tierKey ].
	
	next ifNil: [ ^ nil ].
	
	^ next deepAt: key ifPresent: presentBlock
]

{ #category : 'as yet unclassified' }
TTDictionaryTiered >> gtItemsFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Items';
		priority: 1;
		items: [ self tiers];
		children: [ :each | 
			each value isDictionary
				ifTrue: [ each value associations sort: (#key collatedBy: #asString) ]
				ifFalse: [ 
					(each value isArray and: [ each value allSatisfy: #isDictionary ])
						ifTrue: [ each value collectWithIndex: [ :x :i | i -> x ] ]
						ifFalse: [ #() ] ] ];
		column: 'Key' text: [ :assoc | assoc key ];
		column: 'Value' text: [ :assoc | assoc value ] weight: 3;
		contextItemLabel: 'Inspect key' action: [ :anElement :anAssoc | 
			anElement phlow spawnObject: anAssoc key ];
		contextItemLabel: 'Inspect value' action: [ :anElement :anAssoc | 
			anElement phlow spawnObject: anAssoc value ];
		contextItemLabel: 'Inspect association' action: [ :anElement :anAssoc | 
			anElement phlow spawnObject: anAssoc ];
		contextItemLabel: 'Remove key and value' action: [ :anElement :anAssoc | 
			self removeKey: anAssoc key ifAbsent: [ "ignore" ].
			anElement phlow contextMenuUpdateViewContent ];
		send: [ :assoc | assoc value ].
		
	"Implementation note: association sorting uses #collatedBy: to avoid a 'Symbol DNU value: value: error'"
]

{ #category : 'as yet unclassified' }
TTDictionaryTiered >> gtKeysFor: aView [
	<gtView>
	^ aView list
		title: 'Tiers';
		priority: 5;
		items: [ self tierKeys ]
]

{ #category : 'as yet unclassified' }
TTDictionaryTiered >> initialize: size [

	super initialize: size.
	self initialize.
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
TTDictionaryTiered >> next: anObject [
	next := anObject
]

{ #category : 'accessing' }
TTDictionaryTiered >> reset [

	^ self removeAll
]

{ #category : 'accessing' }
TTDictionaryTiered >> storeAt: name [

	name = tierKey ifTrue: [ ^ self ].
	
	next ifNotNil: [ ^ next storeAt: name ].
	
	^ nil
]

{ #category : 'accessing' }
TTDictionaryTiered >> tierAt: name [

	name = tierKey ifTrue: [ ^ self ].
	
	next ifNotNil: [ ^ next tierAt: name ].
	
	^ nil
]

{ #category : 'accessing' }
TTDictionaryTiered >> tierKey [
	^ tierKey
]

{ #category : 'accessing' }
TTDictionaryTiered >> tierKey: anObject [
	tierKey := anObject
]

{ #category : 'as yet unclassified' }
TTDictionaryTiered >> tierKeys [

	^ self tiers collect: [ :ea | ea key ]
]

{ #category : 'as yet unclassified' }
TTDictionaryTiered >> tiers [

	"as a flat collection of associations"
	
	| tiers store |
	
	tiers := OrderedCollection new.
	store := self.
	
	[ store isNotNil ] 
	         whileTrue: 
	         [ tiers add: (store tierKey -> store). 
	         	store := store next ].
	
	^ tiers 
]
