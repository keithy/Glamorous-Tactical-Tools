Class {
	#name : 'TTDictionaryTiered',
	#superclass : 'Dictionary',
	#instVars : [
		'next',
		'tierKey',
		'valueWriter',
		'mode'
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
TTDictionaryTiered class >> newLocal [
	
		^ self new 
				tierKey: #local;
				beCache;
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
TTDictionaryTiered >> add: assoc [

	self isReadOnly ifTrue: [ self error: 'designated read only' ].
	
	^ super add: assoc

]

{ #category : 'accessing' }
TTDictionaryTiered >> appendTier: store [

	"double dispatch so that new tier has control
	 or can opt out if empty"

	^ store tierAppendTo: self.
]

{ #category : 'accessing' }
TTDictionaryTiered >> at: key put: inputValue [

	self isReadOnly ifTrue: [ self error: 'designated read only' ].
	
	^ super at: key put: inputValue

]

{ #category : 'accessing' }
TTDictionaryTiered >> at: key putReading: inputValue [

	"bypass readonly block for initial reading"

	^ super at: key put: inputValue
]

{ #category : 'accessing' }
TTDictionaryTiered >> at: key write: inputValue [

	^ self valueWriter fromAnyAt: key put: inputValue
]

{ #category : 'accessing' }
TTDictionaryTiered >> beCache [

	mode := #cache
]

{ #category : 'accessing' }
TTDictionaryTiered >> beReadOnly [

	mode := #readOnly
]

{ #category : 'accessing' }
TTDictionaryTiered >> deepAssociationAt: oneOrMoreKeys ifPresent: presentBlock [
	"Lookup the given key in the receiver. If it is present, answer the
	value of evaluating the given block optionally with the value associated
	with the key.
	Otherwise, answer nil."

	(array at: (self findElementOrNil: oneOrMoreKeys))
	    ifNotNil: [:assoc | ^ presentBlock cull: assoc cull: tierKey ].

	self next ifNil: [ ^ nil ].

	^ self next deepAssociationAt: oneOrMoreKeys ifPresent: presentBlock
]

{ #category : 'as yet unclassified' }
TTDictionaryTiered >> deepAssociationsDo: aBlock [
 
  self associationsDo: aBlock.
	
	self next ifNil: [ ^ self ].
	
	^ self next deepAssociationsDo: aBlock
	
]

{ #category : 'as yet unclassified' }
TTDictionaryTiered >> deepAssociationsSelect: aBlock [
 
   ^ self deepOn: OrderedCollection new associationsSelect: aBlock
	
]

{ #category : 'accessing' }
TTDictionaryTiered >> deepAt: oneOrMoreKeys ifAbsent: absentBlock [
	"Answer the value associated with the key or, if key isn't found,
	answer the result of evaluating aBlock. Bump not found to the next tier"

	self deepAt: oneOrMoreKeys ifPresent: [ :val | ^ val ].

	^ absentBlock value
]

{ #category : 'accessing' }
TTDictionaryTiered >> deepAt: key ifAbsentPut: absentBlock [
	"Answer the value associated with the key or, if key isn't found,
	put the result of evaluating aBlock."

	self deepAt: key ifPresent: [ :val | ^ val ].

	^ self at: key ifAbsentPut:absentBlock
]

{ #category : 'as yet unclassified' }
TTDictionaryTiered >> deepAt: oneOrMoreKeys ifPresent: presentBlock [
	"Lookup the given key in the receiver. If it is present, answer the
	value of evaluating the given block optionally with the value associated
	with the key.
	Otherwise, answer nil."

	^ self deepAssociationAt: oneOrMoreKeys ifPresent: [ :assoc :tier | presentBlock cull: (assoc value) cull: (assoc key) cull: tierKey ]
]

{ #category : 'accessing' }
TTDictionaryTiered >> deepAt: oneOrMoreKeys ifPresent: presentBlock ifAbsent: absentBlock [
	"Answer the value associated with the key or, if key isn't found,
	answer the result of evaluating aBlock. Bump not found to the next tier"

	self deepAt: oneOrMoreKeys ifPresent: presentBlock.

	^ absentBlock value
]

{ #category : 'accessing' }
TTDictionaryTiered >> deepAt: key ifPresent: presentBlock ifAbsentPut: absentBlock [
	"Answer the value associated with the key or, if key isn't found,
	answer the result of evaluating aBlock. Bump not found to the next tier"

	self deepAt: key ifPresent: presentBlock.

	^ self at: key put: absentBlock value
]

{ #category : 'accessing' }
TTDictionaryTiered >> deepCopy [

	^ super deepCopy
]

{ #category : 'as yet unclassified' }
TTDictionaryTiered >> deepOn: aCollection associationsSelect: aBlock [
 
  aCollection add: (#tierKey -> tierKey).
  aCollection addAll: (self associationsSelect: aBlock).
	
	self next ifNil: [ ^ aCollection ].
	
	^ self next deepOn: aCollection associationsSelect: aBlock
	
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

	^ mode == #cache
]

{ #category : 'accessing' }
TTDictionaryTiered >> isReadOnly [

	^ mode == #readOnly
]

{ #category : 'as yet unclassified' }
TTDictionaryTiered >> isTieredDictionary [

	^ true
]

{ #category : 'accessing' }
TTDictionaryTiered >> next [
	
	^ next value
]

{ #category : 'accessing' }
TTDictionaryTiered >> next: aTieredDictionary [
	 
	(aTieredDictionary askFor: #isTieredDictionary) ifFalse: [ self error: 'expected a ', self class name ].
	
	next := aTieredDictionary
]

{ #category : 'copying' }
TTDictionaryTiered >> postCopy [

	"Must copy the associations, or later store will affect both the
	original and the copy .... which is desireable for a read only copy"

	self isReadOnly ifTrue: [
	  array := array collect: [ :association |
			association ifNotNil: [ association copy ] ]
].

  next := next copy.
]

{ #category : 'accessing' }
TTDictionaryTiered >> reset [

	^ self removeAll
]

{ #category : 'accessing' }
TTDictionaryTiered >> scanFor: oneOrMoreKeys [

  "modified to support multiple key matching"

	"Scan the key array for the first slot containing either a nil (indicating an empty slot) or an element that matches anObject. Answer the index of that slot or zero if no slot is found. This method will be overridden in various subclasses that have different interpretations for matching elements."
	| element start finish keys |

	keys:= oneOrMoreKeys isArray ifFalse: [ Array with: oneOrMoreKeys ] ifTrue: [ oneOrMoreKeys ].

	finish := array size.
	start := (keys first hash \\ finish) + 1.

	"Search from (hash mod size) to the end."
	start to: finish do:
		[:index | ((element := array at: index) == nil or: [ keys includes: element key ])
			ifTrue: [^ index ]].

	"Search from 1 to where we started."
	1 to: start-1 do:
		[:index | ((element := array at: index) == nil or: [keys includes: element key ])
			ifTrue: [^ index ]].

	^ 0  "No match AND no empty slot"
]

{ #category : 'accessing' }
TTDictionaryTiered >> storeAt: name [

	name = tierKey ifTrue: [ ^ self ].
	
	self next ifNotNil: [ :n | ^ n storeAt: name ].
	
	^ nil
]

{ #category : 'accessing' }
TTDictionaryTiered >> tierAppendTo: stack [

	tierKey  ifNil: [ ^ self error: 'tierKey not set' ].
	
	stack next ifNotNil: [ ^ self tierAppendTo: stack next ].
	
	valueWriter ifNil: [ self valueWriter: stack valueWriter copy ].
  stack next: self.
	
	^ self
]

{ #category : 'accessing' }
TTDictionaryTiered >> tierAt: name [

	name = tierKey ifTrue: [ ^ self ].
	
	self next ifNotNil: [ :n | ^ n tierAt: name ].
	
	^ nil
]

{ #category : 'accessing' }
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

{ #category : 'accessing' }
TTDictionaryTiered >> tieredCopy [

	^ self copy
 
]

{ #category : 'accessing' }
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

{ #category : 'accessing' }
TTDictionaryTiered >> valueWriter [ 

^ valueWriter.

]

{ #category : 'accessing' }
TTDictionaryTiered >> valueWriter: aValueWriter [
	
	aValueWriter dict: self.
	valueWriter := aValueWriter.

]
