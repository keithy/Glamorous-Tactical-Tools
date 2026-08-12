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
TTDictionaryTiered class >> newTest [
 
  <gtExample>
  
	| test |
	
	test := self newWithKey: #test.
	
	self assert: test wrappedDictionary isDictionary.
	self assert: test isEnabled.
	
]

{ #category : 'instance creation' }
TTDictionaryTiered class >> newWithKey: aKey [

	^ self basicNew
			tierKey: aKey
			yourself
]

{ #category : 'public - accessing' }
TTDictionaryTiered >> asDictionary [
	
	"flat dictionary"
	
	^ self associations asDictionary
			 
	
]

{ #category : 'public - accessing' }
TTDictionaryTiered >> associations [

	^ (self tiersReverseCollect: [ :tier | 
	
				tier isEnabled ifTrue: [ tier wrappedDictionary associations ] ifFalse: nil
			
			]) flatten  
]

{ #category : 'public - accessing' }
TTDictionaryTiered >> at: aKey [  

	"convenience"
  ^ self at: aKey ifPresent:[ :v | ^ v ]
]

{ #category : 'public - accessing' }
TTDictionaryTiered >> at: aKey  ifAbsent: aBlock [
	
	"convenience"
 ^ (self at: aKey ifPresent: [ :v | ^ v ]) ifNil: aBlock
 
]

{ #category : 'public - accessing' }
TTDictionaryTiered >> at: aKey ifPresent: pBlock [
	
	"bottleneck method that allows us to act as a dictionary, for lookup at least"
	
	^ self tiersCollect: [ :t | t wrappedDictionary at: aKey ifPresent: [ :v | ^v ]
	] on: OrderedCollection new

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
 
	^(self tiersCollect: [ :tier | tier wrappedDictionary size ] on: OrderedCollection new) sum
]

{ #category : 'views' }
TTDictionaryTiered >> gtItemsFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Items';
		priority: 1;
		items: [ self tiers collect: [ :t | t -> t wrappedDictionary ] ];
		children: [ :each | 
			each value isDictionary
				ifTrue: [ each value associations sort: (#key collatedBy: #asString) ]
				ifFalse: [ 
					(each value isArray and: [ each value allSatisfy: #isDictionary ])
						ifTrue: [ each value collectWithIndex: [ :x :i | i -> x ] ]
						ifFalse: [ #() ] ] ];
		column: 'Key' text: [ :assoc | 
		 
		 			(assoc key askFor: #isDictionaryTiered) ifTrue: [
							
							assoc key in: [ :tier  |
					
								tier isEnabled 
									ifTrue: [ tier tierKey asRopedText bold ]
								  ifFalse: [ tier tierKey asRopedText
				    										attribute: (BlTextDecorationAttribute new lineThrough);
				    										attribute: (BlTextForegroundAttribute new paint: Color gray);
				    										yourself ]
			    	]]
			    	ifFalse: [
			    			assoc key
			    	].
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
 
  "we, the top tier are initialised once, but we cascade
  this twice in order to give some tiers the chance to 
  know their peers after all of the other tiers have been
  initialised"
  
  self initializeOne: self.
  self initializeTwo: self.
  
]

{ #category : 'initialization' }
TTDictionaryTiered >> initializeOne: topTier [

	"cascade initializeOne: return the last tier initialized"
	
	(dict respondsTo: #initializeOne:) ifTrue: [ dict initializeOne: topTier ].
	
	^ next ifNil: [ self ] ifNotNil: [ self initializeOne: topTier ]
]

{ #category : 'initialization' }
TTDictionaryTiered >> initializeTwo: topTier [

	"cascade initializeTwo: return the last tier initialized"
	
	(dict respondsTo: #initializeTwo:) ifTrue: [ dict initializeTwo: topTier ].
		
	^ next ifNil: [ self ] ifNotNil: [ self initializeTwo: topTier ]
]

{ #category : 'testing' }
TTDictionaryTiered >> isDictionaryTiered [

	^ true
]

{ #category : 'initialization' }
TTDictionaryTiered >> isEnabled [

	^ isEnabled ifNil: [ isEnabled := true ]
]

{ #category : 'initialization' }
TTDictionaryTiered >> isReady [
 
	^ dict notNil and: [ dict notEmpty and: [ self beEnabled ] ]
]

{ #category : 'private - accessing' }
TTDictionaryTiered >> next [
	
	^ next
]

{ #category : 'private - accessing' }
TTDictionaryTiered >> next: aTieredDictionary [
	 
	 aTieredDictionary ifNil: [ ^ self ].
	 
	(aTieredDictionary askFor: #isDictionaryTiered) ifFalse: [ self error: 'expected a ', self class name ].
	
	next := aTieredDictionary
]

{ #category : 'copying' }
TTDictionaryTiered >> postCopy [

	(dict askFor: #isBacked) ifFalse: [
		dict ifNotNil: [ dict := dict copy ]
	].
	next ifNotNil: [ next := next copy ].
	
]

{ #category : 'initialization' }
TTDictionaryTiered >> setDictionary: aDictionary [
	
	"writable dictionary"
	
	dict := aDictionary
]

{ #category : 'tier management' }
TTDictionaryTiered >> tierAppend: aTier [

	"It is safer to use this to build a stack from the top end
	 because we can check for circular refences"
	 
	 ^ self tierInsert: aTier after: nil
]

{ #category : 'tier management' }
TTDictionaryTiered >> tierAt: name [

	name = tierKey ifTrue: [ ^ self ].
	
	self next ifNotNil: [ :n | ^ n tierAt: name ].
	
	^ nil
]

{ #category : 'tier management' }
TTDictionaryTiered >> tierInsert: newTier [

	"unsafe private, inserting in the middle means that 
	 we can not protect against circular references"
	 
	newTier next: self next.
  self next: newTier.
  
  ^ newTier
]

{ #category : 'tier management' }
TTDictionaryTiered >> tierInsert: aTier after: thisTierKey [

	"It is safer to use this to build a stack from the top end
	 because we can check for circular refences"
	 
	 | last |
	 
	 self tiers do: [ :tier | 
	 
	 	tier == aTier ifTrue: [ self error: 'Circular linked lists are a bad idea' ].
	 	
	 	tier tierKey = thisTierKey ifTrue: [ ^ tier tierInsert: aTier   ].
	 	
	 	last := tier.
	 ].
	  
	  thisTierKey ifNotNil: [ KeyNotFound signalFor: thisTierKey ].
	  
	  "appending"
	 ^ last tierInsert: aTier 
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

	^ self tierAppend: (self class newWithKey: aSymbol)  
]

{ #category : 'tier management' }
TTDictionaryTiered >> tierNewInsertWithKey: aSymbol after: this [

	^ self  tierInsert: (self class newWithKey: aSymbol) after: this  
]

{ #category : 'tier management' }
TTDictionaryTiered >> tiers [
	
	^ self tiersCollect: [ :t | t ] on: OrderedCollection new
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
	
	^ self tiers reverse collect: aBlock thenSelect: #notNil 

	 
	
]

{ #category : 'private - accessing' }
TTDictionaryTiered >> wrappedDictionary [
	
	"writable dictionary"
	
	^ dict ifNil: [ dict := Dictionary new ]
]
