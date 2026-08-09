Class {
	#name : 'TTDictionaryTiered',
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
TTDictionaryTiered class >> newCache [
	
		^ self new 
				tierKey: #cache;
				beCache;
				yourself
				
				 
]

{ #category : 'instance creation' }
TTDictionaryTiered class >> newLocal [
	
		^ self new 
				tierKey: #local;
				yourself
				
				 
]

{ #category : 'startup - shutdown' }
TTDictionaryTiered class >> shutDown [

	self shutDownZapCache
]

{ #category : 'startup - shutdown' }
TTDictionaryTiered class >> shutDownZapCache [

	self allInstancesDo: [ :ea | ea isCache ifTrue: [ ea reset ]]
]

{ #category : 'private - delegation' }
TTDictionaryTiered >> add: assoc [

	self isReadOnly ifTrue: [ self error: 'designated read only' ].
	
	^ dict add: assoc

]

{ #category : 'tier management' }
TTDictionaryTiered >> appendTier: store [
  "tiers are built from the top downwards, in a list view"
  
	"double dispatch so that new tier has control
	 or can opt out if empty"

	^ store tierAppendTo: self.
]

{ #category : 'private - delegation' }
TTDictionaryTiered >> at: key [
	 
	 ^ dict at: key
	 
]

{ #category : 'private - delegation' }
TTDictionaryTiered >> at: key forcePut: inputValue [

	"bypass readonly block for initial data loading"

	^ self isCaseSensitive 
				ifTrue: [ dict at: key put: inputValue ]
				ifFalse: [ dict at: key asUppercase put: inputValue ]

]

{ #category : 'private - delegation' }
TTDictionaryTiered >> at: key ifAbsent: aBlock [
	 
	 ^ dict at: key ifAbsent: aBlock
	 
]

{ #category : 'private - delegation' }
TTDictionaryTiered >> at: key ifAbsentPut: aBlock [
	"Return the value at the given key.
	If the key is not included in the receiver store and return the result
	of evaluating aBlock as the new value."

	| k |
	
	k := self isCaseSensitive 
				ifTrue: [ key ]
				ifFalse: [ key asUppercase ].
	
	^ dict at: key ifAbsent: [self at: key put: aBlock value]
]

{ #category : 'private - delegation' }
TTDictionaryTiered >> at: key put: inputValue [

	self isReadOnly ifTrue: [ TTReadOnlyError signal: tierKey  ].
	
	^ self at: key forcePut: inputValue

]

{ #category : 'private - delegation' }
TTDictionaryTiered >> at: key write: inputValue [

	^ self valueWriter fromAnyAt: key put: inputValue
]

{ #category : 'initialization' }
TTDictionaryTiered >> beCache [

	mode := #cache
]

{ #category : 'initialization' }
TTDictionaryTiered >> beCaseInsensitive [

	isCaseSensitive := false
]

{ #category : 'initialization' }
TTDictionaryTiered >> beCaseSensitive [

	isCaseSensitive := true
]

{ #category : 'initialization' }
TTDictionaryTiered >> beReadOnly [

	mode := #readOnly
]

{ #category : 'public access' }
TTDictionaryTiered >> deepAssociationAt: oneOrMoreKeys ifPresentAssocAndTierDo: presentBlock [
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

{ #category : 'public access' }
TTDictionaryTiered >> deepAssociationsDo: aBlock [
 
  dict associationsDo: aBlock.
	
	self next ifNil: [ ^ self ].
	
	^ self next deepAssociationsDo: aBlock
	
]

{ #category : 'public access' }
TTDictionaryTiered >> deepAssociationsSelect: aBlock [
 
   ^ self deepOn: OrderedCollection new associationsSelect: aBlock
	
]

{ #category : 'public access' }
TTDictionaryTiered >> deepAt: oneOrMoreKeys ifAbsent: absentBlock [
	"Answer the value associated with the key or, if key isn't found,
	answer the result of evaluating aBlock. Bump not found to the next tier"

	self deepAt: oneOrMoreKeys ifPresentValueKeyAndTierDo: [ :val | ^ val ].

	^ absentBlock value
]

{ #category : 'public access' }
TTDictionaryTiered >> deepAt: key ifAbsentPut: absentBlock [
	"Answer the value associated with the key or, if key isn't found,
	put the result of evaluating aBlock."

	self deepAt: key ifPresentValueKeyAndTierDo: [ :val | ^ val ].

	^ self at: key ifAbsentPut: absentBlock
]

{ #category : 'public access' }
TTDictionaryTiered >> deepAt: oneOrMoreKeys ifPresent: presentBlock ifAbsent: absentBlock [
	"Answer the value associated with the key or, if key isn't found,
	answer the result of evaluating aBlock. Bump not found to the next tier"

	self deepAt: oneOrMoreKeys ifPresentValueKeyAndTierDo: presentBlock.

	^ absentBlock value
]

{ #category : 'public access' }
TTDictionaryTiered >> deepAt: key ifPresent: presentBlock ifAbsentPut: absentBlock [
	"Answer the value associated with the key or, if key isn't found,
	answer the result of evaluating aBlock. Bump not found to the next tier"

	self deepAt: key ifPresentValueKeyAndTierDo: presentBlock.

		
	^ self at: key put: absentBlock value
]

{ #category : 'public access' }
TTDictionaryTiered >> deepAt: oneOrMoreKeys ifPresentValueKeyAndTierDo: presentBlock [
	"Lookup the given key in the receiver. If it is present, answer the
	value of evaluating the given block optionally with the value associated
	with the key.
	Otherwise, answer nil."

	^ self	deepAssociationAt: oneOrMoreKeys 
					ifPresentAssocAndTierDo: [ :assoc :tier | presentBlock cull: (assoc value) 
					                                           cull: (assoc key)
					                                           cull: tierKey ]
]

{ #category : 'public access' }
TTDictionaryTiered >> deepOn: aCollection associationsSelect: aBlock [
 
  aCollection add: (#tierKey -> tierKey).
  aCollection addAll: (dict associationsSelect: aBlock).
	
	self next ifNil: [ ^ aCollection ].
	
	^ self next deepOn: aCollection associationsSelect: aBlock
	
]

{ #category : 'views' }
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

{ #category : 'views' }
TTDictionaryTiered >> gtKeysFor: aView [
	<gtView>
	^ aView list
		title: 'Tiers';
		priority: 5;
		items: [ self tierKeys ]
]

{ #category : 'initialization' }
TTDictionaryTiered >> initialize [

	dict := Dictionary new.
	isCaseSensitive := true.
]

{ #category : 'testing' }
TTDictionaryTiered >> isCache [

	^ mode == #cache
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
TTDictionaryTiered >> isReadOnly [

	^ mode == #readOnly
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

{ #category : 'copying' }
TTDictionaryTiered >> postCopy [

	"Must copy the associations, or later store will affect both the
	original and the copy .... which is desireable for a read only copy"

"	self isReadOnly ifTrue: [
	  array := array collect: [ :association |
			association ifNotNil: [ association copy ] ]
]."

  next := next copy.
]

{ #category : 'startup - shutdown' }
TTDictionaryTiered >> reset [

	^ dict removeAll
]

{ #category : 'tier management' }
TTDictionaryTiered >> tierAppendTo: stack [

	tierKey  ifNil: [ ^ self error: 'tierKey not set' ].
	
	stack next ifNotNil: [ ^ self tierAppendTo: stack next ].
	
	(valueWriter isNil and: [ stack valueWriter notNil ])
		ifTrue: [ self valueWriter: stack valueWriter copy ].
  
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

	"found"
	valueWriter ifNil: [ self valueWriter: stack valueWriter copy ].
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

	^ self tiers collect: [ :ea | ea key ]
]

{ #category : 'tier management' }
TTDictionaryTiered >> tiers [

	"as a flat collection of associations"

	| tiers store |

	tiers := OrderedCollection new.
	store := self.

	[ store isNotNil ]
	         whileTrue:
	         [ tiers add: (store tierKey -> store).
         	store := store next ].

	^ tiers asArray
]

{ #category : 'private - accessing' }
TTDictionaryTiered >> valueWriter [ 

^ valueWriter.

]

{ #category : 'initialization' }
TTDictionaryTiered >> valueWriter: aValueWriter [
	
	aValueWriter dict: self.
	valueWriter := aValueWriter.

]
