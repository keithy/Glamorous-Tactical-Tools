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

	one wrappedDictionary at: #a put: 1.
	one next wrappedDictionary at: #b put: 2.
	one next wrappedDictionary at: #b2 put: 22.

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

	self assert: one wrappedDictionary isEmpty.

	one setDictionary: (Dictionary with: #pre -> #loaded).

	self assert: (one wrappedDictionary at: #pre) equals: #loaded.

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

{ #category : 'examples - vault' }
TTDictionaryTieredExamples >> vaultRefreshSegmentsEntriesByHost [
  <gtExample>
  <return: #TTVault>

  | vault tier dotenv |
  dotenv := TTDictionaryConfigEnv new
    setValueWriter: TTVaultValueWriter new;
    setSource: './pharo-local/iceberg/keithy/Glamorous-Tactical-Tools/fixtures/dummy.env' asFileReference;
    readSource;
    yourself.

  tier := TTDictionaryTiered newWithKey: #dotenv.
  tier setDictionary: dotenv.

  vault := TTVault new.
  vault setConfig: tier.
  vault refresh.

  "vault options is keyed by app (lowercase); each app dict is keyed by option name"
  self assert: vault options keys asSortedCollection asArray
    equals: #('gitlab_onprem' 'gitlab_saas' 'jira' 'my_cool_app').

  self assert: (vault options at: 'jira') keys asSortedCollection asArray
    equals: #('default' 'host2').

  "The passthrough entries (no option__ prefix) for the empty app land in jira's default dict
  because the empty-app passthrough is applied to every existing app."
  self assert: ((vault options at: 'jira') at: 'default') keys asSortedCollection asArray
    equals: #('Preseve_My_Case_Please' 'SOMELLM_API_KEY' '__MISE_EXE' '__Problem_Child' 'api_key' 'email' 'pass' 'url' 'user').

  self assert: ((vault options at: 'jira') at: 'host2') keys asSortedCollection asArray
    equals: #('token' 'user').

  "host2 jira user overrides default jira user"
  self assert: ((vault options at: 'jira') at: 'default' at: 'user') asString equals: 'alice'.
  self assert: ((vault options at: 'jira') at: 'host2' at: 'user') asString equals: 'bob'.

  ^ vault
]

{ #category : 'examples' }
TTDictionaryTieredExamples >> writableDictionaryIsPerTier [
	<gtExample>
	<return: #TTDictionaryTiered>

	one := TTDictionaryTiered newWithKey: #one.
	one tierNewAppendWithKey: #two.
	one tierNewAppendWithKey: #three.

	one wrappedDictionary at: #a put: 1.
	one next wrappedDictionary at: #b put: 2.
	one next next wrappedDictionary at: #c put: 3.

	self assert: one wrappedDictionary size equals: 1.
	self assert: (one next wrappedDictionary at: #b) equals: 2.
	self assert: (one next next wrappedDictionary at: #c) equals: 3.

	^ one
]
