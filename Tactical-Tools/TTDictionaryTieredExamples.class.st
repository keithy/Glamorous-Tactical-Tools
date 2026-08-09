Class {
	#name : 'TTDictionaryTieredExamples',
	#superclass : 'Object',
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'examples' }
TTDictionaryTieredExamples >> cacheTierIgnoresMutations [
	<gtExample>
	<return: #TTDictionaryTiered>
	| cache |
	cache := TTDictionaryTiered new
		tierKey: #cache;
		beCache;
		yourself.
	cache at: #x put: 1.
	self assert: (cache at: #x) equals: 1.
	^ cache
]

{ #category : 'examples' }
TTDictionaryTieredExamples >> emptyDictionaryHasNoTiersExceptSelf [
	<gtExample>
	<return: #TTDictionaryTiered>
	| dict |
	dict := TTDictionaryTiered new tierKey: #root.
	self assert: dict tierKeys equals: #(#root).
	^ dict
]

{ #category : 'examples' }
TTDictionaryTieredExamples >> emptyDictionaryHasNoValue [
	<gtExample>
	<return: #TTDictionaryTiered>
	| dict |
	dict := TTDictionaryTiered new tierKey: #root.
	self assert: (dict at: #missing ifAbsent: [ #absent ]) equals: #absent.
	^ dict
]

{ #category : 'examples' }
TTDictionaryTieredExamples >> keyInTopTierShadowsLowerTier [
	<gtExample>
	<return: #TTDictionaryTiered>
	| root middle top |
	root := TTDictionaryTiered new tierKey: #root.
	middle := TTDictionaryTiered new tierKey: #middle.
	top := TTDictionaryTiered new tierKey: #top.
	root at: #shared put: #fromRoot.
	root appendTier: middle.
	middle at: #shared put: #fromMiddle.
	middle appendTier: top.
	top at: #shared put: #fromTop.
	self assert: (top deepAt: #shared) equals: #fromTop.
	^ top
]

{ #category : 'examples' }
TTDictionaryTieredExamples >> lookUpFallsThroughToLowerTier [
	<gtExample>
	<return: #TTDictionaryTiered>
	| root middle top |
	root := TTDictionaryTiered new tierKey: #root.
	middle := TTDictionaryTiered new tierKey: #middle.
	top := TTDictionaryTiered new tierKey: #top.
	root at: #a put: #rootA.
	root at: #b put: #rootB.
	root appendTier: middle.
	middle at: #b put: #middleB.
	middle appendTier: top.
	top at: #c put: #topC.
	self assert: (top deepAt: #a) equals: #rootA.
	self assert: (top deepAt: #b) equals: #middleB.
	self assert: (top deepAt: #c) equals: #topC.
	^ top
]

{ #category : 'examples' }
TTDictionaryTieredExamples >> newCacheFactoryProducesCacheModeTier [
	<gtExample>
	<return: #TTDictionaryTiered>
	| cache |
	cache := TTDictionaryTiered newCache.
	self assert: cache tierKey equals: #cache.
	self assert: cache isCache.
	^ cache
]

{ #category : 'examples' }
TTDictionaryTieredExamples >> readOnlyTierRejectsMutations [
	<gtExample>
	<return: #TTDictionaryTiered>
	| tier |
	tier := TTDictionaryTiered new
		tierKey: #ro;
		beReadOnly;
		yourself.
	self assert: tier isReadOnly.
	self should: [ tier at: #x put: 1 ] raise: Error.
	^ tier
]

{ #category : 'examples' }
TTDictionaryTieredExamples >> resetClearsEntries [
	<gtExample>
	<return: #TTDictionaryTiered>
	| tier |
	tier := TTDictionaryTiered new tierKey: #cache.
	tier at: #x put: 1.
	tier at: #y put: 2.
	tier reset.
	self assert: tier isEmpty.
	^ tier
]

{ #category : 'examples' }
TTDictionaryTieredExamples >> tierKeysReportsAllLinkedTiers [
	<gtExample>
	<return: #TTDictionaryTiered>
	| root middle top |
	root := TTDictionaryTiered new tierKey: #root.
	middle := TTDictionaryTiered new tierKey: #middle.
	top := TTDictionaryTiered new tierKey: #top.
	root appendTier: middle.
	middle appendTier: top.
	self assert: top tierKeys equals: #(#top #middle #root).
	^ top
]

{ #category : 'examples' }
TTDictionaryTieredExamples >> tieredChainIsBuiltByAppendTier [
	<gtExample>
	<return: #TTDictionaryTiered>
	| root middle top tiers |
	root := TTDictionaryTiered new tierKey: #root.
	middle := TTDictionaryTiered new tierKey: #middle.
	top := TTDictionaryTiered new tierKey: #top.
	root appendTier: middle.
	middle appendTier: top.
	tiers := top tiers collect: [ :ea | ea key ].
	self assert: tiers equals: #(#top #middle #root).
	self assert: top next tierKey equals: #middle.
	self assert: top next next tierKey equals: #root.
	^ top
]
