Class {
	#name : 'TTDictionaryTieredOld',
	#superclass : 'Object',
	#instVars : [
		'next',
		'tierKey',
		'valueWriter',
		'mode',
		'isCaseSensitive',
		'dict'
	],
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'instance creation' }
TTDictionaryTieredOld class >> newCache [
	
		^ self new 
				tierKey: #cache;
				beCache;
				yourself
				
				 
]

{ #category : 'instance creation' }
TTDictionaryTieredOld class >> newLocal [
	
		^ self new 
				tierKey: #local;
				yourself
				
				 
]

{ #category : 'startup - shutdown' }
TTDictionaryTieredOld class >> shutDown [

	self shutDownZapCache
]

{ #category : 'startup - shutdown' }
TTDictionaryTieredOld class >> shutDownZapCache [

	self allInstancesDo: [ :ea | ea isCache ifTrue: [ ea reset ]]
]

{ #category : 'private - delegation' }
TTDictionaryTieredOld >> add: assoc [

	self isReadOnly ifTrue: [ TTReadOnlyError signal: 'designated read only' ].
	
	^ dict add: assoc

]

{ #category : 'tier management' }
TTDictionaryTieredOld >> appendTier: store [
  "tiers are built from the top downwards, in a list view"
  
	"double dispatch so that new tier has control
	 or can opt out if empty"

	^ store tierAppendTo: self.
]

{ #category : 'private - delegation' }
TTDictionaryTieredOld >> associationAt: oneOrMoreKeys ifPresent: pBlock [

	oneOrMoreKeys isArray
		ifTrue: [ 
		
				oneOrMoreKeys do: [ :key | 
							dict associationAt: key ifPresent: [ :v | ^ pBlock value: v ] ]
		]
    ifFalse: [ 
    		dict associationAt: oneOrMoreKeys ifPresent: [ :v | ^ pBlock value: v ]
    ]
]

{ #category : 'private - delegation' }
TTDictionaryTieredOld >> at: key [
	"Answer the value associated with the key."
	^ self at: key ifAbsent: [ dict errorKeyNotFound: key ]
	 
]

{ #category : 'private - delegation' }
TTDictionaryTieredOld >> at: key forcePut: inputValue [

	"bypass readonly block for initial data loading"

	^ self isCaseSensitive 
				ifTrue: [ dict at: key put: inputValue ]
				ifFalse: [ dict at: key asUppercase put: inputValue ]

]

{ #category : 'private - delegation' }
TTDictionaryTieredOld >> at: key ifAbsent: aBlock [
	 	
	"delegation bottleneck method"
	
	| keyToStore |
	
	keyToStore := self isCaseSensitive 
				ifTrue: [ key ]
				ifFalse: [ key asUppercase ].
	
	^ dict at: keyToStore ifAbsent: [ self at: key put: aBlock value ]
]

{ #category : 'private - delegation' }
TTDictionaryTieredOld >> at: key ifAbsentPut: aBlock [
	"Return the value at the given key.
	If the key is not included in the receiver store and return the result
	of evaluating aBlock as the new value."

	| keyToStore |
	
	keyToStore := self isCaseSensitive 
				ifTrue: [ key ]
				ifFalse: [ key asUppercase ].
	
	^ dict at: keyToStore ifAbsent: [self at: keyToStore put: aBlock value]
]

{ #category : 'private - delegation' }
TTDictionaryTieredOld >> at: key put: inputValue [

	self isReadOnly ifTrue: [ TTReadOnlyError signal: tierKey  ].
	
	^ self at: key forcePut: inputValue

]

{ #category : 'private - delegation' }
TTDictionaryTieredOld >> at: key write: inputValue [

	^ self valueWriter fromAnyAt: key put: inputValue
]

{ #category : 'initialization' }
TTDictionaryTieredOld >> beCache [

	mode := #cache
]

{ #category : 'initialization' }
TTDictionaryTieredOld >> beCaseInsensitive [

	isCaseSensitive := false
]

{ #category : 'initialization' }
TTDictionaryTieredOld >> beCaseSensitive [

	isCaseSensitive := true
]

{ #category : 'initialization' }
TTDictionaryTieredOld >> beReadOnly [

	mode := #readOnly
]

{ #category : 'public - accessing' }
TTDictionaryTieredOld >> deepAssociationAt: oneOrMoreKeys ifPresentAssocAndTierDo: presentBlock [
	"Lookup the given key in the receiver. If it is present, answer the
	value of evaluating the given block optionally with the value associated
	with the key.
	Otherwise, answer nil."

	dict associationAt: oneOrMoreKeys ifPresent: [ :assoc |
	
		^ presentBlock cull: assoc cull: tierKey
	
	].

	self next ifNil: [ ^ nil ].

	^ self next deepAssociationAt: oneOrMoreKeys ifPresentAssocAndTierDo: presentBlock
]

{ #category : 'public - accessing' }
TTDictionaryTieredOld >> deepAssociationsDo: aBlock [
 
  dict associationsDo: aBlock.
	
	self next ifNil: [ ^ self ].
	
	^ self next deepAssociationsDo: aBlock
	
]

{ #category : 'public - accessing' }
TTDictionaryTieredOld >> deepAssociationsSelect: aBlock [
 
   ^ self deepOn: OrderedCollection new associationsSelect: aBlock
	
]

{ #category : 'public - accessing' }
TTDictionaryTieredOld >> deepAt: oneOrMoreKeys ifAbsent: absentBlock [
	"Answer the value associated with the key or, if key isn't found,
	answer the result of evaluating aBlock. Bump not found to the next tier"

	self deepAt: oneOrMoreKeys ifPresentValueKeyAndTierDo: [ :val | ^ val ].

	^ absentBlock value
]

{ #category : 'public - accessing' }
TTDictionaryTieredOld >> deepAt: key ifAbsentPut: absentBlock [
	"Answer the value associated with the key or, if key isn't found,
	put the result of evaluating aBlock."

	self deepAt: key ifPresentValueKeyAndTierDo: [ :val | ^ val ].

	^ self at: key ifAbsentPut: absentBlock
]

{ #category : 'public - accessing' }
TTDictionaryTieredOld >> deepAt: oneOrMoreKeys ifPresent: presentBlock ifAbsent: absentBlock [
	"Answer the value associated with the key or, if key isn't found,
	answer the result of evaluating aBlock. Bump not found to the next tier"

	self deepAt: oneOrMoreKeys ifPresentValueKeyAndTierDo: presentBlock.

	^ absentBlock value
]

{ #category : 'public - accessing' }
TTDictionaryTieredOld >> deepAt: key ifPresent: presentBlock ifAbsentPut: absentBlock [
	"Answer the value associated with the key or, if key isn't found,
	answer the result of evaluating aBlock. Bump not found to the next tier"

	self deepAt: key ifPresentValueKeyAndTierDo: presentBlock.

		
	^ self at: key put: absentBlock value
]

{ #category : 'public - accessing' }
TTDictionaryTieredOld >> deepAt: oneOrMoreKeys ifPresentValueKeyAndTierDo: presentBlock [
	"Lookup the given key in the receiver. If it is present, answer the
	value of evaluating the given block optionally with the value associated
	with the key.
	Otherwise, answer nil."

	^ self	deepAssociationAt: oneOrMoreKeys 
					ifPresentAssocAndTierDo: [ :assoc :tier | presentBlock cull: (assoc value) 
					                                           cull: (assoc key)
					                                           cull: tierKey ]
]

{ #category : 'tier management' }
TTDictionaryTieredOld >> deepKeys [

	^ (self tiersCollectAll: [ :tier | tier keys ] on: OrderedCollection) asArray
]

{ #category : 'public - accessing' }
TTDictionaryTieredOld >> deepOn: aCollection associationsSelect: aBlock [
 
  aCollection add: (#tierKey -> tierKey).
  aCollection addAll: (dict associationsSelect: aBlock).
	
	self next ifNil: [ ^ aCollection ].
	
	^ self next deepOn: aCollection associationsSelect: aBlock
	
]

{ #category : 'public - accessing' }
TTDictionaryTieredOld >> deepSize [
 
	^(self tiersCollectAll: [ :tier | tier size ] on: OrderedCollection new) sum
]

{ #category : 'views' }
TTDictionaryTieredOld >> gtItemsFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Items';
		priority: 1;
		items: [ self tiersAssociations];
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
TTDictionaryTieredOld >> gtTierKeysFor: aView [
	<gtView>
	^ aView list
		title: 'Tiers';
		priority: 5;
		items: [ self tierKeys ]
]

{ #category : 'private - delegation' }
TTDictionaryTieredOld >> includesKey: key [

	^ dict includesKey: key
]

{ #category : 'initialization' }
TTDictionaryTieredOld >> initialize [

	dict := Dictionary new.
	isCaseSensitive := true.
]

{ #category : 'testing' }
TTDictionaryTieredOld >> isCache [

	^ mode == #cache
]

{ #category : 'testing' }
TTDictionaryTieredOld >> isCaseSensitive [

	^ isCaseSensitive
]

{ #category : 'testing' }
TTDictionaryTieredOld >> isDictionaryTiered [

	^ true
]

{ #category : 'testing' }
TTDictionaryTieredOld >> isEmpty [

	^ dict isEmpty
]

{ #category : 'testing' }
TTDictionaryTieredOld >> isReadOnly [

	^ mode == #readOnly
]

{ #category : 'private - delegation' }
TTDictionaryTieredOld >> keys [
	 
	 ^ dict keys
	 
]

{ #category : 'private - accessing' }
TTDictionaryTieredOld >> next [
	
	^ next value
]

{ #category : 'private - accessing' }
TTDictionaryTieredOld >> next: aTieredDictionary [
	 
	(aTieredDictionary askFor: #isDictionaryTiered) ifFalse: [ self error: 'expected a ', self class name ].
	
	next := aTieredDictionary
]

{ #category : 'copying' }
TTDictionaryTieredOld >> postCopy [

	"Must copy the associations, or later store will affect both the
	original and the copy .... which is desireable for a read only copy"

"	self isReadOnly ifTrue: [
	  array := array collect: [ :association |
			association ifNotNil: [ association copy ] ]
]."
	
	self isReadOnly ifFalse: [ dict := dict copy ].
	valueWriter ifNotNil: [ valueWriter dict: dict ].
  next := next copy.
  

]

{ #category : 'startup - shutdown' }
TTDictionaryTieredOld >> reset [

	^ dict removeAll
]

{ #category : 'private - delegation' }
TTDictionaryTieredOld >> size [ 

	^ dict size
]

{ #category : 'tier management' }
TTDictionaryTieredOld >> tierAppendTo: stack [

	tierKey  ifNil: [ ^ self error: 'tierKey not set' ].
	
	stack next ifNotNil: [ ^ self tierAppendTo: stack next ].
	
	(valueWriter isNil and: [ stack valueWriter notNil ])
		ifTrue: [ self valueWriter: stack valueWriter copy ].
  
  stack next: self.
	
	^ self
]

{ #category : 'tier management' }
TTDictionaryTieredOld >> tierAt: name [

	name = tierKey ifTrue: [ ^ self ].
	
	self next ifNotNil: [ :n | ^ n tierAt: name ].
	
	^ nil
]

{ #category : 'tier management' }
TTDictionaryTieredOld >> tierInsertIn: stack after: key [

	tierKey ifNil: [ ^ self error: 'tierKey not set' ].

	stack ifNil: [ ^ KeyNotFound signalFor: key in: self ]. "failed"

	"search"
	stack tierKey == key ifFalse: [ ^ self tierInsertIn: stack next after: key ].

	"found"
	valueWriter ifNil: [ self valueWriter: stack valueWriter copy ].
  self next: stack next.
  stack next: self.

	"success"
	^ self
]

{ #category : 'tier management' }
TTDictionaryTieredOld >> tierKey [
	^ tierKey
]

{ #category : 'tier management' }
TTDictionaryTieredOld >> tierKey: anObject [
	tierKey := anObject
]

{ #category : 'tier management' }
TTDictionaryTieredOld >> tierKeys [

	^ (self tiersCollectAll: [ :tier | Array with: tier tierKey ] on: OrderedCollection) asArray
]

{ #category : 'tier management' }
TTDictionaryTieredOld >> tiersAssociations [

	^ (self tiersCollectAll: [ :tier | tier tierKey -> tier ] on: OrderedCollection) asArray
]

{ #category : 'tier management' }
TTDictionaryTieredOld >> tiersCollectAll: aBlock on: aCollector [
	
	aCollector addAll: (aBlock value: self). 

	next ifNotNil: [ 
		next tiersCollectAll: aBlock on: aCollector
	].
	
	^ aCollector
	
]

{ #category : 'tier management' }
TTDictionaryTieredOld >> tiersDo: aBlock [

	^ self tiersCollectAll: aBlock on: OrderedCollection new
]

{ #category : 'private - accessing' }
TTDictionaryTieredOld >> valueWriter [ 

^ valueWriter.

]

{ #category : 'initialization' }
TTDictionaryTieredOld >> valueWriter: aValueWriter [
	
	aValueWriter dict: self.
	valueWriter := aValueWriter.

]
