Class {
	#name : 'TTDictionaryTieredExamples',
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
TTDictionaryTieredExamples >> caseInsensitiveTierFoldsLookup [
	<gtExample>
	<return: #TTDictionaryTiered>
	tier := TTDictionaryTiered new
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
TTDictionaryTieredExamples >> caseInsensitiveTierHandlesSymbols [
	<gtExample>
	<return: #TTDictionaryTiered>
	tier := TTDictionaryTiered new
		tierKey: #ci;
		beCaseInsensitive;
		yourself.
	tier at: #One put: 1.
	self assert: (tier at: #one ifAbsent: [ #absent ]) equals: 1.
	^ tier
]

{ #category : 'examples' }
TTDictionaryTieredExamples >> caseInsensitiveTierIncludesAndRemove [
	<gtExample>
	<return: #TTDictionaryTiered>
	tier := TTDictionaryTiered new
		tierKey: #ci;
		beCaseInsensitive;
		yourself.
	tier at: 'PATH' put: 1.
	self assert: (tier includesKey: 'path').
	self assert: (tier includesKey: 'Path').
	tier removeKey: 'PaTh'.
	self assert: (tier includesKey: 'path') equals: false.
	self assert: tier isEmpty.
	^ tier
]

{ #category : 'examples' }
TTDictionaryTieredExamples >> caseInsensitiveTierOverwritesAcrossCase [
	<gtExample>
	<return: #TTDictionaryTiered>
	tier := TTDictionaryTiered new
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
TTDictionaryTieredExamples >> caseInsensitiveTierResolvesMultiKey [
	<gtExample>
	<return: #TTDictionaryTiered>
	tier := TTDictionaryTiered new
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
TTDictionaryTieredExamples >> caseInsensitiveTierStoresUppercased [
	<gtExample>
	<return: #TTDictionaryTiered>
	| stored |
	tier := TTDictionaryTiered new
		tierKey: #ci;
		beCaseInsensitive;
		yourself.
	tier at: 'Home' put: 1.
	stored := tier keys anyOne.
	self assert: stored equals: 'HOME'.
	^ tier
]

{ #category : 'examples' }
TTDictionaryTieredExamples >> emptyDictionaryHasNoTiersExceptSelf [
	<gtExample>
	<return: #TTDictionaryTiered>
 
	 one := self emptyDictionaryHasNoValue.
	
 	self assert: one tierKeys equals: #(#one).
	
	^ one
]

{ #category : 'examples' }
TTDictionaryTieredExamples >> emptyDictionaryHasNoValue [
	<gtExample>
	<return: #TTDictionaryTiered>
 
  one := TTDictionaryTiered new tierKey: #one.
	
	self assert: (one at: #missing ifAbsent: [ #absent ]) equals: #absent.
	
	^ one
]

{ #category : 'examples' }
TTDictionaryTieredExamples >> initialWritesAcceptedByCacheTier [
	<gtExample>
	<return: #TTDictionaryTiered>
	 
	cache := TTDictionaryTiered new
		tierKey: #cache;
		beCache;
		yourself.
		
	cache at: #x put: 1.
	self assert: (cache at: #x) equals: 1.
	
	^ cache
]

{ #category : 'examples' }
TTDictionaryTieredExamples >> initialWritesRejectedByReadOnlyTier [
	<gtExample>
	<return: #TTDictionaryTiered>
	 
	readonly := TTDictionaryTiered new
		tierKey: #readOnly;
		beReadOnly;
		yourself.
		
	self should: [ readonly at: #x put: 1 ] raise: TTReadOnlyError.
	
	^ readonly
]

{ #category : 'examples' }
TTDictionaryTieredExamples >> keyInEarlierTierShadowsLaterTiers [

	<gtExample>
	<return: #TTDictionaryTiered>
 
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
TTDictionaryTieredExamples >> lookUpFallsThroughToLaterTier [
	<gtExample>
	<return: #TTDictionaryTiered>
	 	
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
TTDictionaryTieredExamples >> resetClearsEntries [
	<gtExample>
	<return: #TTDictionaryTiered>
	
	cache := TTDictionaryTiered new tierKey: #cache.
	cache at: #x put: 1.
	cache at: #y put: 2.
	cache reset.
	self assert: cache isEmpty.
	^ cache
]

{ #category : 'examples' }
TTDictionaryTieredExamples >> threeTierEmpty [

	<gtExample>
	<return: #TTDictionaryTiered>
 
	one := TTDictionaryTiered new tierKey: #one.
	two := TTDictionaryTiered new tierKey: #two.
	three := TTDictionaryTiered new tierKey: #three.

	one appendTier: two.
	one appendTier: three.
	
	^ one
	
]

{ #category : 'examples' }
TTDictionaryTieredExamples >> tierKeysReportsAllLinkedTiers [
	<gtExample>
	<return: #TTDictionaryTiered>
	
	one := self threeTierEmpty.
  two := one next.
  three := two next.
  
	self assert: one tierKeys equals: #(#one #two #three).
	
	^ one
]

{ #category : 'examples' }
TTDictionaryTieredExamples >> verifyFactoryNewCache [
	<gtExample>
	<return: #TTDictionaryTiered>
 
	cache := TTDictionaryTiered newCache.
	self assert: cache tierKey equals: #cache.
	self assert: cache isCache.
	^ cache
]
