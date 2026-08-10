Class {
	#name : 'TTDictionaryTieredExamplesOld',
	#superclass : 'Object',
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#instVars : [
		'one',
		'two',
		'three',
		'cache',
		'readonly',
		'tier'
	],
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'examples' }
TTDictionaryTieredExamplesOld >> caseInsensitiveTierFoldsLookup [
	<gtExample>
	<return: #TTDictionaryTieredOld>
	tier := TTDictionaryTieredOld new
		tierKey: #ci;
		beCaseInsensitive;
		yourself.
	tier at: 'PATH' put: 1.
	self assert: (tier at: 'PATH') equals: 1.
	self assert: (tier at: 'path') equals: 1.
	self assert: (tier at: 'Path') equals: 1.
	^ tier
]

{ #category : 'examples' }
TTDictionaryTieredExamplesOld >> caseInsensitiveTierHandlesSymbols [
	<gtExample>
	<return: #TTDictionaryTieredOld>
	tier := TTDictionaryTieredOld new
		tierKey: #ci;
		beCaseInsensitive;
		yourself.
	tier at: #One put: 1.
	self assert: (tier at: #one ifAbsent: [ #absent ]) equals: 1.
	^ tier
]

{ #category : 'examples' }
TTDictionaryTieredExamplesOld >> caseInsensitiveTierIncludesAndRemove [
	<gtExample>
	<return: #TTDictionaryTieredOld>
	one := TTDictionaryTieredOld new
		tierKey: #ci;
		beCaseInsensitive;
		yourself.
	one at: 'PATH' put: 1.
	one assert: (one includesKey: 'path').
	one assert: (one includesKey: 'Path').
	one removeKey: 'PaTh'.
	self assert: (one includesKey: 'path') equals: false.
	self assert: one isEmpty.
	^ one
]

{ #category : 'examples' }
TTDictionaryTieredExamplesOld >> caseInsensitiveTierOverwritesAcrossCase [
	<gtExample>
	<return: #TTDictionaryTieredOld>
	tier := TTDictionaryTieredOld new
		tierKey: #ci;
		beCaseInsensitive;
		yourself.
	tier at: 'PATH' put: 1.
	tier at: 'path' put: 2.
	self assert: (tier at: 'PATH') equals: 2.
	self assert: tier size equals: 1.
	^ tier
]

{ #category : 'examples' }
TTDictionaryTieredExamplesOld >> caseInsensitiveTierResolvesMultiKey [
	<gtExample>
	<return: #TTDictionaryTieredOld>
	tier := TTDictionaryTieredOld new
		tierKey: #ci;
		beCaseInsensitive;
		yourself.
	tier at: 'PATH' put: 1.
	tier at: 'HOME' put: 2.
	self assert: (tier at: #('path' 'home') ifAbsent: [ #absent ]) equals: 1.
	self assert: (tier at: #('unknown' 'home') ifAbsent: [ #absent ]) equals: 2.
	self assert: (tier at: #('a' 'b') ifAbsent: [ #absent ]) equals: #absent.
	^ tier
]

{ #category : 'examples' }
TTDictionaryTieredExamplesOld >> caseInsensitiveTierStoresUppercased [
	<gtExample>
	<return: #TTDictionaryTieredOld>
	| stored |
	tier := TTDictionaryTieredOld new
		tierKey: #ci;
		beCaseInsensitive;
		yourself.
	tier at: 'Home' put: 1.
	stored := tier keys anyOne.
	self assert: stored equals: 'HOME'.
	^ tier
]

{ #category : 'examples' }
TTDictionaryTieredExamplesOld >> emptyDictionaryHasNoTiersExceptSelf [
	<gtExample>
	<return: #TTDictionaryTieredOld>
 
	 one := self emptyDictionaryHasNoValue.
	
 	self assert: one tierKeys equals: #(#one).
	
	^ one
]

{ #category : 'examples' }
TTDictionaryTieredExamplesOld >> emptyDictionaryHasNoValue [
	<gtExample>
	<return: #TTDictionaryTieredOld>
 
  one := TTDictionaryTieredOld new tierKey: #one.
	
	self assert: (one at: #missing ifAbsent: [ #absent ]) equals: #absent.
	
	^ one
]

{ #category : 'examples' }
TTDictionaryTieredExamplesOld >> initialWritesAcceptedByCacheTier [
	<gtExample>
	<return: #TTDictionaryTieredOld>
	 
	cache := TTDictionaryTieredOld new
		tierKey: #cache;
		beCache;
		yourself.
		
	cache at: #x put: 1.
	self assert: (cache at: #x) equals: 1.
	
	^ cache
]

{ #category : 'examples' }
TTDictionaryTieredExamplesOld >> initialWritesRejectedByReadOnlyTier [
	<gtExample>
	<return: #TTDictionaryTieredOld>
	 
	readonly := TTDictionaryTieredOld new
		tierKey: #readOnly;
		beReadOnly;
		yourself.
		
	self should: [ readonly at: #x put: 1 ] raise: TTReadOnlyError.
	
	^ readonly
]

{ #category : 'examples' }
TTDictionaryTieredExamplesOld >> keyInEarlierTierShadowsLaterTiers [

	<gtExample>
	<return: #TTDictionaryTieredOld>
 
	one := self threeTierEmpty.
  two := one tierAt: #two.
  three := two tierAt: #three.
  
  one at: 'shared' put: #fromOne.
  two at: 'shared' put: #fromTwo.
  three at: 'shared' put: #fromThree.
  
	self assert: (one deepAt: #shared ifAbsent: nil) equals: #fromOne.
	self assert: (two deepAt: #shared ifAbsent: nil) equals: #fromTwo.
	self assert: (three deepAt: #shared ifAbsent: nil) equals: #fromThree.
	
	^ one
	
]

{ #category : 'examples' }
TTDictionaryTieredExamplesOld >> lookUpFallsThroughToLaterTier [
	<gtExample>
	<return: #TTDictionaryTieredOld>
	 	
	one := self threeTierEmpty.
  two := one next.
  three := three next.
	
	one at: 'ONE' put: #fromOne.
  one at: 'TWO' put: #fromTwo.
  one at: 'THREE' put: #fromThree.
  
	self assert: (one deepAt: 'THREE' ifAbsent: nil) equals: #fromThree.
	self assert: (one deepAt: 'TWO' ifAbsent: nil) equals: #fromTwo.
	self assert: (one deepAt: 'ONE' ifAbsent: nil) equals: #fromOne.
	
	^ one
]

{ #category : 'examples' }
TTDictionaryTieredExamplesOld >> resetClearsEntries [
	<gtExample>
	<return: #TTDictionaryTieredOld>
	
	cache := TTDictionaryTieredOld new tierKey: #cache.
	cache at: #x put: 1.
	cache at: #y put: 2.
	cache reset.
	self assert: cache isEmpty.
	^ cache
]

{ #category : 'examples' }
TTDictionaryTieredExamplesOld >> threeTierEmpty [

	<gtExample>
	<return: #TTDictionaryTieredOld>
 
	one := TTDictionaryTieredOld new tierKey: #one.
	two := TTDictionaryTieredOld new tierKey: #two.
	three := TTDictionaryTieredOld new tierKey: #three.

	one appendTier: two.
	one appendTier: three.
	
	^ one
	
]

{ #category : 'examples' }
TTDictionaryTieredExamplesOld >> tierKeysReportsAllLinkedTiers [
	<gtExample>
	<return: #TTDictionaryTieredOld>
	
	one := self threeTierEmpty.
  two := one next.
  three := two next.
  
	self assert: one tierKeys equals: #(#one #two #three).
	
	^ one
]

{ #category : 'examples' }
TTDictionaryTieredExamplesOld >> verifyFactoryNewCache [
	<gtExample>
	<return: #TTDictionaryTieredOld>
 
	cache := TTDictionaryTieredOld newCache.
	self assert: cache tierKey equals: #cache.
	self assert: cache isCache.
	^ cache
]
