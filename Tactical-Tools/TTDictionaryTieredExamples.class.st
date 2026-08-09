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
		'readonly'
	],
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

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
