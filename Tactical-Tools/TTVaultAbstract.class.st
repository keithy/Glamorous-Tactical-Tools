Class {
	#name : 'TTVaultAbstract',
	#superclass : 'Object',
	#instVars : [
		'options',
		'config',
		'appKey',
		'search',
		'apps'
	],
	#classInstVars : [
		'currentVault'
	],
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'accessing' }
TTVaultAbstract class >> basicNew [
   self isAbstract ifTrue: [ self error:self name, ' is abstract' ].
 ^ super basicNew
]

{ #category : 'instance creation' }
TTVaultAbstract class >> currentVault [
	^ currentVault ifNil: [ currentVault := self newDefaultVault ]
]

{ #category : 'instance creation' }
TTVaultAbstract class >> getDefaultVault [

	self subclassResponsibility
]

{ #category : 'accessing' }
TTVaultAbstract class >> isAbstract [

	^ self == TTVaultAbstract
]

{ #category : 'instance creation' }
TTVaultAbstract class >> makeSearch: aSelection [
	
	aSelection == #default ifTrue: [ ^ self makeSearchDefault ].
	
	^ self makeSearchDefault copyWithFirst: { #options. aSelection asSymbol. }
	
	 

	 
]

{ #category : 'instance creation' }
TTVaultAbstract class >> makeSearchDefault [

	^ #((options default) (config))

	 
]

{ #category : 'accessing' }
TTVaultAbstract class >> reset [

  currentVault := nil
]

{ #category : 'accessing' }
TTVaultAbstract class >> searchInitial [
	^ #((options '*' default) (config))
]

{ #category : 'instance creation' }
TTVaultAbstract class >> shutDown: quitting [

  <ttShutDown>

  quitting ifTrue: [ self reset ]
	
	
]

{ #category : 'instance creation' }
TTVaultAbstract class >> startUp: isImageStarting [

	<ttStartUp>
	
	isImageStarting ifFalse: [ self reset ]
	
	
]

{ #category : 'instance creation' }
TTVaultAbstract class >> vaultId [

	^ (self name withoutSuffix: 'TT') asLowercase
]

{ #category : 'accessing' }
TTVaultAbstract >> appKey [
	^ appKey
]

{ #category : 'accessing' }
TTVaultAbstract >> appKey: anObject [
	appKey := anObject 
]

{ #category : 'accessing' }
TTVaultAbstract >> apps [

	^ apps ifNil: [ apps := self getApps ]
]

{ #category : 'accessing' }
TTVaultAbstract >> asDictionary [

	^ (IdentityDictionary new) 
			at: #config put: self config;
			at: #options put: self options;
			yourself
			 
 
]

{ #category : 'accessing' }
TTVaultAbstract >> at: aKey [  

	"convenience"
	
	"for #at:ifAbsent: (vault at: #use ifNil: 'me')"
	"for #at:ifPresent: (vault at: #use ifNotNil: [ :v | ])"

	^ self lookup: aKey 
 
]

{ #category : 'accessing' }
TTVaultAbstract >> at: aKey ifPresent: pBlock [

 "convenience: this is only implemented for users who wish to use
  aVault interchangably with aDictionary since the semantics of 
  #at: are different (returns nil rather than error when absent)
  but at least this behaves the same"

  | vault |
  ^ (vault at: aKey) ifNotNil: pBlock


]

{ #category : 'accessing' }
TTVaultAbstract >> bundleId [

	"update later"
	
	^ TheHub bundleId
]

{ #category : 'accessing' }
TTVaultAbstract >> config [
	^ config ifNil: [ config := Dictionary new ]
]

{ #category : 'accessing' }
TTVaultAbstract >> configForApp [

	
	"The normalized form of the keys is an array
	#(<option> <App Key> <field>)
	
	1. options are lowercase
	2. App keys are uppercase
	3. Field keys are uppercase
	"
	
	^ self config associations 
	
	collect: [ :in | self funcNormalizeOn: in ] 
	thenSelect: [ :out | self funcAppFilter: out ]
]

{ #category : 'accessing' }
TTVaultAbstract >> configNormalized [

	
	"The normalized form of the keys is an array
	#(<option> <App Key> <field>)
	
	1. options are lowercase
	2. App keys are uppercase
	3. Field keys are uppercase
	"
	
	^ self config associations 
	
	collect: [ :in | self funcNormalizeOn: in ] 
	thenSelect: #notNil
]

{ #category : 'accessing' }
TTVaultAbstract >> configRefresh [
 
  "don't everyone do this"
  
  self config refreshReading.
  apps := nil.
  options := nil.
]

{ #category : 'accessing' }
TTVaultAbstract >> configuredApps [

	"scan for list of apps, key is pre-parsed"
	
	| apps |
	
	apps := Set new.
 
	self configNormalized do: [ :assoc | 
	
			apps add: assoc key second.
	
	].
		
	^ apps

	 
]

{ #category : 'accessing' }
TTVaultAbstract >> copyForAll [

	^ (self copy)
			appKey: nil;
			setOptionsForAll;
			yourself
	 
			 
	
	 
]

{ #category : 'accessing' }
TTVaultAbstract >> doesNotUnderstand: aMessage [
	aMessage hasArguments ifFalse: [ 
	
		(self lookup: aMessage selector) ifNotNil: [ :v | ^ v ]
		
	].
	^ super doesNotUnderstand: aMessage
]

{ #category : 'accessing' }
TTVaultAbstract >> errorKeyNotFound: aKey [

	KeyNotFound signalFor: aKey
]

{ #category : 'accessing' }
TTVaultAbstract >> funcAppFilter: assoc [

	"select function on appKey, assumes normalized pre-parsed assoc form"
 
 | app |
 
 "key was niled in order to be ignored"
 assoc ifNil: [ ^ false ].
 
 appKey ifNil: [ ^ true ].
 
 "key is pre parsed"
 app := assoc key second.
 
 "allow for the possibility that appKey is a '', glob or regex"
 ^ appKey matches: app
 
		
 
	
]

{ #category : 'accessing' }
TTVaultAbstract >> funcNormalizeOn: in [ 

	^ self subclassResponsibility
]

{ #category : 'accessing' }
TTVaultAbstract >> getApps [

  | result applyToAllApps |

  applyToAllApps := OrderedCollection new.
  result := Dictionary new.

  self configForApp do: [ :assoc |
    | key option app field |
    key := assoc key.
    option := key first.
    app := key second.
    field := key third.

    app isEmpty
      ifTrue: [ applyToAllApps add: assoc ]
      ifFalse: [
        (result at: app ifAbsentPut: [ Dictionary new ])
          at: option at: field put: assoc value ]
  ].

  applyToAllApps do: [ :assoc |
    | key option field |
    key := assoc key.
    option := key first.
    field := key third.
    result do: [ :dict |
      dict at: option at: field put: assoc value ]
  ].

  ^ result
]

{ #category : 'gt-views' }
TTVaultAbstract >> gtAppsConfigFor: aView [
	<gtView>
	
	^ aView columnedTree
		title: 'Apps';
		priority: 6;
		
		"top row buttons"
		in: [ :view | view actionButtonIcon: BrGlamorousVectorIcons "save" restart 
												id: GtPhlowViewRefreshContentButtonId
												tooltip: 'Re-read Configuration'
												action: [ :aButton :aTab | 
														self configRefresh.
														aTab phlow fireViewUpdateWish ]];
		actionUpdateButtonTooltip: 'Update item list';
		
		items: [ self apps associations sort: (#key collatedBy: #asString) ];
		children: [ :each | 
			each value isDictionary
				ifTrue: [ each value associations sort: (#key collatedBy: #asString) ]
				ifFalse: [ 
					(each value isArray and: [ each value allSatisfy: #isDictionary ])
						ifTrue: [ each value collectWithIndex: [ :x :i | i -> x ] ]
						ifFalse: [ #() ] ] ];
		column: 'Key' text: [ :assoc | assoc key ];
		column: 'Value' text: [ :assoc | 
		
		
		assoc value isDictionary ifTrue: [ '' ] ifFalse: [ assoc value ]
		
		
		
		] weight: 3;
		
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
]

{ #category : 'gt-views' }
TTVaultAbstract >> gtConfigFor: aView [
	<gtView>
	
	^ aView forward
		title: 'Config';
		priority: 9;
		in: [ :view | view actionButtonIcon: BrGlamorousVectorIcons "save" restart 
												id: GtPhlowViewRefreshContentButtonId
												tooltip: 'Re-read Configuration'
												action: [ :aButton :aTab | 
														self configRefresh.
														aTab phlow fireViewUpdateWish ]];
														
		in: [ :view | view actionButtonIcon: BrGlamorousVectorIcons search 
												id: GtPhlowViewRefreshContentButtonId
												tooltip: 'Search Path'
												action: [ :aButton :aTab | 
														self configRefresh.
														aButton phlow spawnObject: self class traceCurrentSearchPath ]];														
														
		actionUpdateButtonTooltip: 'Update item list';
		object: [ config ];
		view: #gtItemsFor:
]

{ #category : 'gt-views' }
TTVaultAbstract >> gtConfiguredAppsFor: aView [
	<gtView>
	
	^ aView forward
		title: 'Apps List';
		priority: 1;
		object: [ self configuredApps];
		view: #gtItemsFor:
]

{ #category : 'gt-views' }
TTVaultAbstract >> gtNormalizedFilteredFor: aView [
	<gtView>
	
	^ aView forward
		title: 'Filtered';
		priority: 15;
		object: [ self configForApp];
		view: #gtItemsFor:
]

{ #category : 'gt-views' }
TTVaultAbstract >> gtNormalizedFor: aView [
	<gtView>
	
	^ aView forward
		title: 'Normalized';
		priority: 10;
		object: [ self configNormalized];
		view: #gtItemsFor:
]

{ #category : 'gt-views' }
TTVaultAbstract >> gtOptionsFor: aView [
	<gtView>
	
	^ aView columnedTree
		title: 'Client';
		priority: 3;
		
		"top row buttons"
		in: [ :view | view actionButtonIcon: BrGlamorousVectorIcons "save" restart 
												id: GtPhlowViewRefreshContentButtonId
												tooltip: 'Re-read Configuration'
												action: [ :aButton :aTab | 
														self configRefresh.
														aTab phlow fireViewUpdateWish ]];
		actionUpdateButtonTooltip: 'Update item list';
		
		items: [ self options associations sort: (#key collatedBy: #asString) ];
		children: [ :each | 
			each value isDictionary
				ifTrue: [ each value associations sort: (#key collatedBy: #asString) ]
				ifFalse: [ 
					(each value isArray and: [ each value allSatisfy: #isDictionary ])
						ifTrue: [ each value collectWithIndex: [ :x :i | i -> x ] ]
						ifFalse: [ #() ] ] ];
		column: 'Key' text: [ :assoc | assoc key ];
		column: 'Value' text: [ :assoc | 
		
		
		assoc value isDictionary ifTrue: [ '' ] ifFalse: [ assoc value ]
		
		
		
		] weight: 3;
		
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
]

{ #category : 'accessing' }
TTVaultAbstract >> hubId [

	"update later"
	
	^ TheHub current hubId
]

{ #category : 'accessing' }
TTVaultAbstract >> initialize [

	"We construct this instance without initialization
	 this cascades the initialization"
	  
	self config initialize.
	 
	
]

{ #category : 'testing' }
TTVaultAbstract >> isWhoAmI [

	<ttWhoAmI>
	
	"Identity read from configuration"

	^ true
]

{ #category : 'accessing' }
TTVaultAbstract >> lookup: aKey [  

	"
	search = #( #(options default) #(config) )
	attempt1, receiver is self (theVault)
	
	Thought of offering a wildcard option on the search, but it has limited use.

	"
	| start |
	
	start := (IdentityDictionary new) 
			at: #config put: self config;
			at: #options put: self options;
			yourself.
 
	self search do: [ :attempt |
	
		((attempt inject: start into: [ :target :each | (target at: each) ifNil: [ ^ nil ]])  at: aKey)
			ifNotNil: [ :v | ^v ].
						
	].
	
	^ nil

	
	
	
	
]

{ #category : 'accessing' }
TTVaultAbstract >> lookup: aKey ifPresent: pBlock [

	"
	search = #( #(options default) #(config) )
	attempt1, receiver is self (theVault)
	
	Thought of offering a wildcard option on the search, but it has limited use.
	"
	
	| start |
	
	start := self lookupStart.
 
	self search do: [ :attempt |
	
		(attempt inject: start into: [ :target :each | target at: each ]) at: aKey ifPresent: pBlock.
						
	].
	
	^ nil

	
	
	
	
]

{ #category : 'accessing' }
TTVaultAbstract >> lookupHasFields: aList [
	
	aList do: [ :aField |	
	
		(self lookup: aField ifPresent: true) ifNil: [ ^ false ]
	
	].
	
	^ true
	
	
	
	
]

{ #category : 'accessing' }
TTVaultAbstract >> lookupStart [

	^ (IdentityDictionary new) 
			at: #config put: self config;
			at: #options put: self options;
			yourself.
 
	 
	
	
]

{ #category : 'accessing' }
TTVaultAbstract >> options [
    ^ options ifNil: [ options := self apps at: appKey ifAbsent: [ Dictionary new ]]
]

{ #category : 'accessing' }
TTVaultAbstract >> optionsSelect: anOption [

	options := nil.
	search := self class makeSearch: anOption


]

{ #category : 'accessing' }
TTVaultAbstract >> projectId [

	"update later"
	
	^ TheHub projectId
]

{ #category : 'accessing' }
TTVaultAbstract >> refresh [

	apps := nil.
	options := nil.
	self options.
		
]

{ #category : 'accessing' }
TTVaultAbstract >> search [ 

	^ search ifNil: [ search := self class makeSearchDefault ]
]

{ #category : 'accessing' }
TTVaultAbstract >> setConfig: anyRespondsToAssociations [
	config := anyRespondsToAssociations
]

{ #category : 'accessing' }
TTVaultAbstract >> setSearch: anArray [
	search := anArray
]

{ #category : 'accessing' }
TTVaultAbstract >> userId [

	"update later"
	
	^ TheHub userId
]
