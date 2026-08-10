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

{ #category : 'instance creation' }
TTDictionaryTiered class >> newWithKey: aKey [

	^ self basicNew
			tierKey: aKey
			initialize
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
 
	^(self tiersCollect: [ :tier | tier writableDictionary size ] on: OrderedCollection new) sum
]

{ #category : 'views' }
TTDictionaryTiered >> gtItemsFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Items';
		priority: 1;
		items: [ self tiers collect: [ :t | t -> t writableDictionary ] ];
		children: [ :each | 
			each value isDictionary
				ifTrue: [ each value associations sort: (#key collatedBy: #asString) ]
				ifFalse: [ 
					(each value isArray and: [ each value allSatisfy: #isDictionary ])
						ifTrue: [ each value collectWithIndex: [ :x :i | i -> x ] ]
						ifFalse: [ #() ] ] ];
		column: 'Key' text: [ :assoc | 
		
			assoc key in: [ :tier |
		
				tier isEnabled 
					ifTrue: [ tier tierKey asRopedText bold ]
				  ifFalse: [ tier tierKey asRopedText
    										attribute: (BlTextDecorationAttribute lineThrough);
    										attribute: (BlTextForegroundAttribute paint: Color gray);
    										yourself ]
    	]
		];
		column: 'Value' text: [ :assoc | assoc value ] weight: 3;
		contextItemLabel: 'Inspect Tier' action: [ :anElement :anAssoc | 
			anElement phlow spawnObject: anAssoc key ];
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
TTDictionaryTiered >> tierAt: name [

	name = tierKey ifTrue: [ ^ self ].
	
	self next ifNotNil: [ :n | ^ n tierAt: name ].
	
	^ nil
]

{ #category : 'tier management' }
TTDictionaryTiered >> tierInsert: newTier [

	newTier next: self next.
  self next: newTier.
  
  ^ newTier
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
TTDictionaryTiered >> tierNewAppendWithKey: aSymbol [

	^ self tiers last tierInsert: (self class newWithKey: aSymbol)  
]

{ #category : 'tier management' }
TTDictionaryTiered >> tierNewInsertWithKey: aSymbol after: this [

	^ (self tierAt: this) tierAdd: (self class newWithKey: aSymbol)  
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
