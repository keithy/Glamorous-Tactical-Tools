Class {
	#name : 'TTVaultAbstract',
	#superclass : 'Object',
	#instVars : [
		'options',
		'config',
		'appKey'
	],
	#classInstVars : [
		'currentVault'
	],
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'instance creation' }
TTVaultAbstract class >> currentVault [
	^ currentVault ifNil: [ currentVault := self getCurrentVault ]
]

{ #category : 'instance creation' }
TTVaultAbstract class >> getCurrentVault [

	self subclassResponsibility
]

{ #category : 'accessing' }
TTVaultAbstract class >> reset [

currentVault := nil
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
TTVaultAbstract >> bundleId [

	"update later"
	
	^ TheHub bundleId
]

{ #category : 'accessing' }
TTVaultAbstract >> config [
	^ config
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
	thenSelect: [ :out | self funcAppFilter: out ]
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
TTVaultAbstract >> funcAppFilter: assoc [

	"select function on appKey, assumes normalized pre-parsed assoc form"
 
 | app |
 
 "key was niled in order to be ignored"
 assoc ifNil: [ ^ false ].
 
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
TTVaultAbstract >> getOptions [ 

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
	 								
	 				(result at: app ifAbsentPut:[ Dictionary new ])
	 						at: option at: field put: assoc value
	 	]
	 ].
	 	
 	applyToAllApps do: [ :assoc |
 		
 		result do: [ :dict | 
 		
 				dict at: assoc first at: assoc third put: assoc value
 		]
 	].
 
 	^ result
	
]

{ #category : 'as yet unclassified' }
TTVaultAbstract >> gtItemsFor: aView [
	<gtView>
	
	^ aView forward
		title: 'Items';
		priority: 10;
		object: [ config ];
		view: #gtItemsFor:
]

{ #category : 'as yet unclassified' }
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

{ #category : 'as yet unclassified' }
TTVaultAbstract >> isWhoAmI [

	<ttWhoAmI>
	
	"Can provide identity"

	^ true
]

{ #category : 'accessing' }
TTVaultAbstract >> options [
    ^ options
]

{ #category : 'accessing' }
TTVaultAbstract >> projectId [

	"update later"
	
	^ TheHub projectId
]

{ #category : 'accessing' }
TTVaultAbstract >> refresh [

	self setOptions
		
]

{ #category : 'accessing' }
TTVaultAbstract >> setConfig: anObject [
	config := anObject
]

{ #category : 'accessing' }
TTVaultAbstract >> setOptions [

	 options := self getOptions
 
	
]

{ #category : 'accessing' }
TTVaultAbstract >> setOptionsForAll [

	 options := self getOptionsForAll
 
	
]

{ #category : 'accessing' }
TTVaultAbstract >> userId [

	"update later"
	
	^ TheHub userId
]
