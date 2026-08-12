Class {
	#name : 'TTVaultExamplesOld',
	#superclass : 'Object',
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'examples - funcNormalizeOn:' }
TTVaultExamplesOld >> funcNormalizeOn_appField_prependsDefault [
  <gtExample>
  <return: #Association>

  | assoc normalized |
  assoc := 'App__Field' -> 'v'.
  normalized := TTVault basicNew funcNormalizeOn: assoc.

  self assert: normalized key equals: #('default' 'app' 'field').
  self assert: normalized value equals: 'v'.

  ^ normalized
]

{ #category : 'examples - funcNormalizeOn:' }
TTVaultExamplesOld >> funcNormalizeOn_leadingDoubleUnderscore_ignored [
  <gtExample>
  <return: #Association>

  | assoc normalized |
  assoc := '__CFBundleIdentifier' -> 'v'.
  normalized := TTVault new funcNormalizeOn: assoc.

  self assert: normalized key equals: #('default' '' '__CFBundleIdentifier' ).
  self assert: normalized value equals: 'v'.

  ^ normalized
]

{ #category : 'examples - funcNormalizeOn:' }
TTVaultExamplesOld >> funcNormalizeOn_loneField_ignored [
  <gtExample>
  <return: #Association>

  | assoc normalized |
  assoc := 'fieLD_Of_Dreams' -> 'v'.
  normalized := TTVault basicNew funcNormalizeOn: assoc.

  self assert: normalized key equals: #('default' '' 'fieLD_Of_Dreams').
  self assert: normalized value equals: 'v'.

  ^ normalized
]

{ #category : 'examples - funcNormalizeOn:' }
TTVaultExamplesOld >> funcNormalizeOn_loneField_is_preseved_WrappedAsDefaultEmptyApp [
  <gtExample>
  <return: #Association>

  | assoc normalized |
  assoc := 'fieLD_Of_Dreams' -> 'v'.
  normalized := TTVault basicNew funcNormalizeOn: assoc.

  self assert: normalized key equals: #('default' '' 'fieLD_Of_Dreams').
  self assert: normalized value equals: 'v'.

  ^ normalized
]

{ #category : 'examples - funcNormalizeOn:' }
TTVaultExamplesOld >> funcNormalizeOn_optionAppField_keepsOption [
  <gtExample>
  <return: #Association>

  | assoc normalized |
  assoc := 'Option__App__Field' -> 'v'.
  normalized := TTVault basicNew funcNormalizeOn: assoc.

  self assert: normalized key equals: #('option' 'app' 'field').
  self assert: normalized value equals: 'v'.

  ^ normalized
]

{ #category : 'examples - vault' }
TTVaultExamplesOld >> vault_mixedFormAndExplicitOption_resolveUnderSameApp [
  <gtExample>
  <return: #TTVault>

  | vault tier dotenv options jiraDefault |
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
  options := vault options.

  "jira merges from passthrough (no option) and explicit-form (no option) entries;
  both end up in the same default sub-dict under jira."

  jiraDefault := nil.
  (options at: 'jira') keysAndValuesDo: [ :option :optDict |
    option = 'default' ifTrue: [ jiraDefault := optDict ] ].

  self assert: (jiraDefault keys asSortedCollection asArray)
    equals: #('Preserve_My_Case_Please' 'SOME_LLM_API_KEY' '__MISE_EXE' '__Problem_Child' 'api_key' 'email' 'pass' 'url' 'user').

  self assert: (jiraDefault at: 'url') asString equals: 'https://jira.example.com'.
  self assert: (jiraDefault at: 'user') asString equals: 'alice'.

  ^ vault
]

{ #category : 'examples - vault' }
TTVaultExamplesOld >> vault_passthroughKeys_landInDefaultOption [
  <gtExample>
  <return: #TTVault>

  | vault tier dotenv normalized |
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

  "The fixture has 4 passthrough entries (no option__ prefix):
    Preserve_My_Case_Please=keep_me   -> lone field, parses as ('default', '', 'Preserve_My_Case_Please')
    SOME_LLM_API_KEY=my_key           -> lone field, parses as ('default', '', 'SOME_LLM_API_KEY')
    __Problem_Child=problem_value    -> app-only form, parses as ('default', '', '__Problem_Child')
    __MISE_EXE=/usr/local/bin/mise   -> app-only form, parses as ('default', '', '__MISE_EXE')
  The case is preserved in the field slot. Option is filled-in as 'default'."

  normalized := vault configNormalized.
  normalized := normalized collect: [ :assoc | assoc key ].

  self assert: (normalized includes: #('default' '' 'Preserve_My_Case_Please')).
  self assert: (normalized includes: #('default' '' 'SOME_LLM_API_KEY')).
  self assert: (normalized includes: #('default' '' '__Problem_Child')).
  self assert: (normalized includes: #('default' '' '__MISE_EXE')).

  ^ vault
]
