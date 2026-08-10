Class {
	#name : 'TTDictionaryTiered',
	#superclass : 'Object',
	#instVars : [
		'next',
		'tierKey',
		'dict',
		'isEnabled'
	],
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'tier management' }
TTDictionaryTiered >> appendTier: store [
  "tiers are built from the top downwards, in a list view"
  
	"double dispatch so that new tier has control
	 or can opt out if empty"

	^ store tierAppendTo: self.
]

{ #category : 'private - delegation' }
TTDictionaryTiered >> asDictionary [

	^ self associations asDictionary
			 
	
]

{ #category : 'private - delegation' }
TTDictionaryTiered >> asDictionaryWithLowercaseKeys [

	^ (self associations collect: [ :ea | ea key: ea key asLowercase ]) asDictionary
			 
	
]

{ #category : 'private - delegation' }
TTDictionaryTiered >> asDictionaryWithUppercaseKeys [

	^ (self associations collect: [ :ea | ea key: ea key asUppercase ]) asDictionary
			 
	
]

{ #category : 'private - delegation' }
TTDictionaryTiered >> associations [

	^ (self tiersReverseCollect: [ :tier | 
	
				tier isEnabled ifTrue: [ tier dict associations ] ifFalse: nil
			
			]) flatten  
]

{ #category : 'initialization' }
TTDictionaryTiered >> beDisabled [

	isEnabled := false
]

{ #category : 'initialization' }
TTDictionaryTiered >> beEnabled [

	isEnabled := true
]

{ #category : 'public - accessing' }
TTDictionaryTiered >> deepSize [
 
	^(self tiersCollect: [ :tier | tier size ] on: OrderedCollection new) sum
]

{ #category : 'accessing' }
TTDictionaryTiered >> dict [
	^ dict
]

{ #category : 'accessing' }
TTDictionaryTiered >> dict: anObject [
	dict := anObject
]

{ #category : 'views' }
TTDictionaryTiered >> gtItemsFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Items';
		priority: 1;
		items: [ self tiers collect: [ :t | t tierKey -> t ] ];
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

{ #category : 'views' }
TTDictionaryTiered >> gtTierKeysFor: aView [
	<gtView>
	^ aView list
		title: 'Tiers';
		priority: 5;
		items: [ self tierKeys ]
]

{ #category : 'initialization' }
TTDictionaryTiered >> initialize [

	dict := Dictionary new.
]

{ #category : 'testing' }
TTDictionaryTiered >> isCaseSensitive [

	^ isCaseSensitive
]

{ #category : 'testing' }
TTDictionaryTiered >> isEmpty [

	^ dict isEmpty
]

{ #category : 'testing' }
TTDictionaryTiered >> isTieredDictionary [

	^ true
]

{ #category : 'private - accessing' }
TTDictionaryTiered >> next [
	
	^ next value
]

{ #category : 'private - accessing' }
TTDictionaryTiered >> next: aTieredDictionary [
	 
	(aTieredDictionary askFor: #isTieredDictionary) ifFalse: [ self error: 'expected a ', self class name ].
	
	next := aTieredDictionary
]

{ #category : 'tier management' }
TTDictionaryTiered >> tierAppendTo: stack [

	tierKey  ifNil: [ ^ self error: 'tierKey not set' ].
	
	stack next ifNotNil: [ ^ self tierAppendTo: stack next ].
	
  stack next: self.
	
	^ self
]

{ #category : 'tier management' }
TTDictionaryTiered >> tierAt: name [

	name = tierKey ifTrue: [ ^ self ].
	
	self next ifNotNil: [ :n | ^ n tierAt: name ].
	
	^ nil
]

{ #category : 'tier management' }
TTDictionaryTiered >> tierInsertIn: stack after: key [

	tierKey ifNil: [ ^ self error: 'tierKey not set' ].

	stack ifNil: [ ^ KeyNotFound signalFor: key in: self ]. "failed"

	"search"
	stack tierKey == key ifFalse: [ ^ self tierInsertIn: stack next after: key ].

  self next: stack next.
  stack next: self.

	"success"
	^ self
]

{ #category : 'tier management' }
TTDictionaryTiered >> tierKey [
	^ tierKey
]

{ #category : 'tier management' }
TTDictionaryTiered >> tierKey: anObject [
	tierKey := anObject
]

{ #category : 'tier management' }
TTDictionaryTiered >> tierKeys [

	^ (self tiers collect: [ :t | t tierKey ]) asArray
]

{ #category : 'tier management' }
TTDictionaryTiered >> tiers [
	
	^ self tiersCollect: [ :t | t ] on: OrderedDictionary new
]

{ #category : 'tier management' }
TTDictionaryTiered >> tiersCollect: aBlock on: aCollector [
	
	"can also select or reject by returning nil"
	
	(aBlock value: self) in: [ :result | 
		
		result ifNotNil: [ aCollector add: result ]
	].

	next ifNotNil: [ 
		next tiersCollect: aBlock on: aCollector
	].
	
	^ aCollector
	
]

{ #category : 'tier management' }
TTDictionaryTiered >> tiersReverseCollect: aBlock [ 

	"can also select or reject by returning nil"
	
	^ self tiers reverse collect: aBlock thenSelect: [ :ea | ea | ea notNil ]

	 
	
]

{ #category : 'private - delegation' }
TTDictionaryTiered >> writableDictionary [
	
	"writable dictionary"
	
	^ dict
]
