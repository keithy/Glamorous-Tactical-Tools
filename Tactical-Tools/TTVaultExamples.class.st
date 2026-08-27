Class {
	#name : 'TTVaultExamples',
	#superclass : 'Object',
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'examples - funcNormalizeOn:' }
TTVaultExamples >> funcNormalizeOn_appField_prependsDefault [
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
TTVaultExamples >> funcNormalizeOn_leadingDoubleUnderscore_ignored [

	"new scheme ignores keys that do not play our tune"
	
  <gtExample>
 
  | assoc normalized |
  
  assoc := '__CFBundleIdentifier' -> 'v'.
  normalized := TTVault new funcNormalizeOn: assoc.

  self assert: normalized equals: nil.

  ^ normalized
]

{ #category : 'examples - funcNormalizeOn:' }
TTVaultExamples >> funcNormalizeOn_loneField_ignored [
  <gtExample>
  <return: #Association>

  | assoc normalized |
  assoc := 'fieLD_Of_Dreams' -> 'v'.
  normalized := TTVault basicNew funcNormalizeOn: assoc.

  self assert: normalized  equals: nil.
  
  ^ normalized
]

{ #category : 'examples - funcNormalizeOn:' }
TTVaultExamples >> funcNormalizeOn_optionAppField_keepsOption [
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
TTVaultExamples >> vault_from_fixture [
  <gtExample>
  <return: #TTVault>

  | tier dotenv normalized |
  dotenv := TTDictionaryConfigEnv new
    setValueWriter: TTVaultValueWriter new;
    source: (#file://'./pharo-local/iceberg/keithy/Glamorous-Tactical-Tools/fixtures/dummy.env' );
    readSource;
    yourself.

  tier := TTDictionaryTiered newWithKey: #dotenv.
  tier setDictionary: dotenv.

  ^ (TTVault basicNew)
  						setConfig: tier;
  						initialize;
  						refresh

 
]

{ #category : 'examples - vault' }
TTVaultExamples >> vault_mixedFormAndExplicitOption_resolveUnderSameApp [
  <gtExample>
  <return: #TTVault>

  | vault apps jiraDefault |
   
  vault := self vault_from_fixture.
  apps := vault apps.

  "jira merges from passthrough (no option) and explicit-form (no option) entries;
  both end up in the same default sub-dict under jira."

  jiraDefault := apps at: 'jira' at: 'default'.

  self assert: (jiraDefault keys asSortedCollection asArray)
    equals: #('api_key' 'email' 'pass' 'url' 'user').

  self assert: (jiraDefault at: 'url') asString equals: 'https://jira.example.com'.
  self assert: (jiraDefault at: 'user') asString equals: 'alice'.

  ^ vault
]

{ #category : 'examples - vault' }
TTVaultExamples >> vault_passthroughKeys_accessible_via_config [
  <gtExample>
  <return: #TTVault>

  | vault config |
    
    vault := self vault_from_fixture.
    
  "The fixture has 4 passthrough entries (no option__ prefix):
    Preserve_My_Case_Please=keep_me   -> lone field, parses as ('default', '', 'Preserve_My_Case_Please')
    SOME_LLM_API_KEY=my_key           -> lone field, parses as ('default', '', 'SOME_LLM_API_KEY')
    __Problem_Child=problem_value    -> app-only form, parses as ('default', '', '__Problem_Child')
    __MISE_EXE=/usr/local/bin/mise   -> app-only form, parses as ('default', '', '__MISE_EXE')
  The case is preserved in the field slot. Option is filled-in as 'default'."

  config := vault config asDictionary.
   
  self assert: (config includesKey: 'Preserve_My_Case_Please').
  self assert: (config includesKey: 'SOME_LLM_API_KEY').
  self assert: (config includesKey: '__Problem_Child').
  self assert: (config includesKey: '__MISE_EXE').

  ^ vault
]

{ #category : 'examples - vault' }
TTVaultExamples >> vault_passthroughKeys_accessible_via_lookup [
  <gtExample>
  <return: #TTVault>

  | vault |
    
    vault := self vault_from_fixture.
    
    vault setSearch: #(#(options) #(config)).
    
  "The fixture has 4 passthrough entries (no option__ prefix):
    Preserve_My_Case_Please=keep_me   -> lone field, parses as ('default', '', 'Preserve_My_Case_Please')
    SOME_LLM_API_KEY=my_key           -> lone field, parses as ('default', '', 'SOME_LLM_API_KEY')
    __Problem_Child=problem_value    -> app-only form, parses as ('default', '', '__Problem_Child')
    __MISE_EXE=/usr/local/bin/mise   -> app-only form, parses as ('default', '', '__MISE_EXE')
  The case is preserved in the field slot. Option is filled-in as 'default'."

  self assert: (vault at: 'Preserve_My_Case_Please') equals: 'keep_me'.
  self assert: (vault at: 'SOME_LLM_API_KEY') equals: 'my_key'.
  self assert: (vault at: '__Problem_Child') equals: 'problem_value'.
  self assert: (vault at: '__MISE_EXE') equals: '/usr/local/bin/mise'.
  
  ^ vault
]
