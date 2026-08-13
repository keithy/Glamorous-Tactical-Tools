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

{ #category : 'accessing' }
TTVaultAbstract class >> lookup: aKey ifAbsent: aBlock [

	self lookup: aKey ifPresent: [ :v | ^ v ].
	
	^ aBlock value
	
	
]

{ #category : 'accessing' }
TTVaultAbstract class >> lookup: aKey ifPresent: pBlock [

	"
	search = #( #(options default) #(config) )
	attempt1, receiver is self (theVault)
	
	Thought of offering a wildcard option on the search, but it has limited use.

	"
	| start |
	
	start := self asDictionary.
 
	self search do: [ :attempt |
	
		(attempt inject: start into: [ :target :each | target at: each ]) at: aKey ifPresent: pBlock.
						
	].
	
	^ nil

	
	
	
	
]

{ #category : 'accessing' }
TTVaultAbstract class >> lookupHasFields: aList [
	
	aList do: [ :aField |	
	
		(self lookup: aField ifPresent: true) ifNil: [ ^ false ]
	
	].
	
	^ true
	
	
	
	
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
  ^ self lookup: aKey ifPresent:[ :v | ^ v ]
 
]

{ #category : 'accessing' }
TTVaultAbstract >> at: aKey  ifAbsent: aBlock [
	
	"convenience"
 ^ (self lookup: aKey ifPresent: [ :v | ^ v ]) ifNil: aBlock
 
]

{ #category : 'accessing' }
TTVaultAbstract >> at: aKey  ifPresent: pBlock [
	
	"convenience"
 ^ self lookup: aKey ifPresent: pBlock
 
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

	^ self subclassResponsibility
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
	
		self lookup: aMessage selector ifPresent: [ :v | ^ v ]
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

  self configNormalized do: [ :assoc |
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
TTVaultAbstract >> gtClientFor: aView [
	<gtView>
	
	^ aView forward
		title: 'Client';
		priority: 1;
		object: [ self options];
		view: #gtItemsFor:
]

{ #category : 'gt-views' }
TTVaultAbstract >> gtConfigFor: aView [
	<gtView>
	
	^ aView forward
		title: 'Config';
		priority: 5;
		object: [ config ];
		view: #gtItemsFor:
]

{ #category : 'gt-views' }
TTVaultAbstract >> gtConfiguredAppsFor: aView [
	<gtView>
	
	^ aView forward
		title: 'Apps';
		priority: 10;
		object: [ self configuredApps];
		view: #gtItemsFor:
]

{ #category : 'gt-views' }
TTVaultAbstract >> gtNormalizedAppFor: aView [
	<gtView>
	
	^ aView forward
		title: 'N4App';
		priority: 10;
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

{ #category : 'accessing' }
TTVaultAbstract >> hubId [

	"update later"
	
	^ TheHub hubId
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
	
	"Can provide identity"

	^ true
]

{ #category : 'accessing' }
TTVaultAbstract >> optionSelect: anOption [

	options := nil.
	search := self class makeSearch: anOption


]

{ #category : 'accessing' }
TTVaultAbstract >> options [
    ^ options ifNil: [ options := self apps at: appKey ifAbsent: [ Dictionary new ]]
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
