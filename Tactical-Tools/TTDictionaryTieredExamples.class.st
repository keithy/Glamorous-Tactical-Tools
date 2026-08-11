Class {
	#name : 'TTDictionaryTieredExamples',
	#superclass : 'Object',
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#instVars : [
		'one',
		'two',
		'three',
		'head'
	],
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'examples' }
TTDictionaryTieredExamples >> deepSizeReportsAllEnabledTiersCombined [
	<gtExample>
	<return: #TTDictionaryTiered>

	one := TTDictionaryTiered newWithKey: #one.
	one tierNewAppendWithKey: #two.

	one writableDictionary at: #a put: 1.
	one next writableDictionary at: #b put: 2.
	one next writableDictionary at: #b2 put: 22.

	self assert: one deepSize equals: 3.

	^ one
]

{ #category : 'examples' }
TTDictionaryTieredExamples >> nextNilClearsLinkKeepsEarlierTiers [
	<gtExample>
	<return: #TTDictionaryTiered>

	one := self threeTierEmpty.
	three := one next next.

	three next: nil.

	self assert: three next isNil.
	self assert: one tierKeys equals: #(#one #two #three).
	self assert: (one tierAt: #three) equals: three.

	^ one
]

{ #category : 'examples' }
TTDictionaryTieredExamples >> setDictionarySwapsWritableDictionary [
	<gtExample>
	<return: #TTDictionaryTiered>

	one := TTDictionaryTiered newWithKey: #one.

	self assert: one writableDictionary isEmpty.

	one setDictionary: (Dictionary with: #pre -> #loaded).

	self assert: (one writableDictionary at: #pre) equals: #loaded.

	^ one
]

{ #category : 'examples' }
TTDictionaryTieredExamples >> threeTierEmpty [
	<gtExample>
	<return: #TTDictionaryTiered>

	one := TTDictionaryTiered newWithKey: #one.
	one tierNewAppendWithKey: #two.
	one tierNewAppendWithKey: #three.

	self assert: one tierKeys equals: #(#one #two #three).
	self assert: one tiers size equals: 3.

	^ one
]

{ #category : 'examples' }
TTDictionaryTieredExamples >> tierAddingANewTierToFrontKinda [
	<gtExample>
	<return: #TTDictionaryTiered>

	one := TTDictionaryTiered newWithKey: #one.
	one tierNewAppendWithKey: #tail.

	self assert: one tierKeys equals: #(#one #tail).

	head := TTDictionaryTiered newWithKey: #head.
	head tierInsert: one .

	self assert: head tierKeys equals: #(#head #one #tail).
	
	^ head
]

{ #category : 'examples' }
TTDictionaryTieredExamples >> tierAtWalksTheChain [
	<gtExample>
	<return: #TTDictionaryTiered>

	one := self threeTierEmpty.

	self assert: (one tierAt: #one) equals: one.
	self assert: (one tierAt: #two) equals: one next.
	self assert: (one tierAt: #three) equals: one next next.
	self assert: (one tierAt: #missing) isNil.

	^ one
]

{ #category : 'examples' }
TTDictionaryTieredExamples >> tierNewAppendExtendsTheChainAtTheLeaf [
	<gtExample>
	<return: #TTDictionaryTiered>

	one := TTDictionaryTiered newWithKey: #one.

	self assert: one tierKeys equals: #(#one).

	one tierNewAppendWithKey: #two.
	self assert: one tierKeys equals: #(#one #two).

	one tierNewAppendWithKey: #three.
	self assert: one tierKeys equals: #(#one #two #three).

	^ one
]

{ #category : 'examples' }
TTDictionaryTieredExamples >> tierNewInsertAfterNamedAnchorExtendsChain [
	<gtExample>
	<return: #TTDictionaryTiered>

	one := TTDictionaryTiered newWithKey: #one.
	one tierNewAppendWithKey: #tail.

	self assert: one tierKeys equals: #(#one #tail).

	one tierNewInsertWithKey: #middle after: #one.
	self assert: one tierKeys equals: #(#one #middle #tail).

	^ one
]

{ #category : 'examples' }
TTDictionaryTieredExamples >> tierNewInsertFailsForMissingAnchor [
	<gtExample>
	<return: #TTDictionaryTiered>

	one := TTDictionaryTiered newWithKey: #one.
	one tierNewAppendWithKey: #two.

	self
		should: [ one tierNewInsertWithKey: #orphan after: #nope ]
		raise: MessageNotUnderstood.

	self assert: one tierKeys equals: #(#one #two).

	^ one
]

{ #category : 'examples' }
TTDictionaryTieredExamples >> vaultRefreshSegmentsEntriesByHost [
	<gtExample>
	<return: #TTVault>

	| vault tier dotenv |
	dotenv := TTDictionaryDotEnv new
		valueWriter: TTVaultValueWriter new;
		source: './pharo-local/iceberg/keithy/Glamorous-Tactical-Tools/fixtures/dummy.env' asFileReference;
		readSource;
		yourself.

	tier := TTDictionaryTiered newWithKey: #dotenv.
	tier setDictionary: dotenv.

	vault := TTVault new.
	vault setConfig: tier.
	vault refresh.

	self assert: vault options keys  
		equals: #('default' 'host2').

	self assert: (vault vault at: 'default') keys asSortedCollection asArray
		equals: #('GITLAB_ONPREM_TOKEN' 'GITLAB_ONPREM_URL' 'GITLAB_ONPREM_USER' 'GITLAB_SAAS_TOKEN' 'GITLAB_SAAS_URL' 'GITLAB_SAAS_USER' 'JIRA_API_KEY' 'JIRA_EMAIL' 'JIRA_PASS' 'JIRA_URL' 'JIRA_USER' 'MY_COOL_APP_TOKEN').

	self assert: (vault vault at: 'host2') keys asSortedCollection asArray
		equals: #('JIRA_TOKEN' 'JIRA_USER').

	self assert: ((vault vault at: 'default') at: 'JIRA_PASS') class
		equals: TTStringObfuscated.

	^ vault
]

{ #category : 'examples' }
TTDictionaryTieredExamples >> writableDictionaryIsPerTier [
	<gtExample>
	<return: #TTDictionaryTiered>

	one := TTDictionaryTiered newWithKey: #one.
	one tierNewAppendWithKey: #two.
	one tierNewAppendWithKey: #three.

	one writableDictionary at: #a put: 1.
	one next writableDictionary at: #b put: 2.
	one next next writableDictionary at: #c put: 3.

	self assert: one writableDictionary size equals: 1.
	self assert: (one next writableDictionary at: #b) equals: 2.
	self assert: (one next next writableDictionary at: #c) equals: 3.

	^ one
]
