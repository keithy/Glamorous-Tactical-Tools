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
TTVaultAbstract >> config: anObject [
	config := anObject
]

{ #category : 'accessing' }
TTVaultAbstract >> configApp: anApp optionAndFieldValuesDo: aBlock [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
TTVaultAbstract >> configNormalized [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
TTVaultAbstract >> copyForAll [

	^ (self copy)
			appKey: nil;
			setOptionsForAll;
			yourself
	 
			 
	
	 
]

{ #category : 'accessing' }
TTVaultAbstract >> copyForApp: anApp [

	^ (self copy)
			appKey: appKey;
			setOptionsForApp: anApp;
			yourself
	 
			 
	
	 
]

{ #category : 'accessing' }
TTVaultAbstract >> getOptionsForAll [

	| result |
	
	result := Dictionary new.
	
	self configuredApps do: [ :app |
	 
	 	result at: app put: (self getOptionsForApp: app).
	 	
	]
 
 
	
]

{ #category : 'accessing' }
TTVaultAbstract >> getOptionsForApp: anAppKey [

	 | result |
	 
	 result := Dictionary new.

	 self configApp: anAppKey optionAndFieldValuesDo: [ :option :app :field :value |
	 
	 	| fields |
	 	
	 	fields := result at: option ifAbsentPut: [ Dictionary new ].
	  
	   fields at: field put: value
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

	appKey ifNil: [ self setOptionsForAll ]
		ifNotNil: [ self setOptionsForApp: appKey ]
]

{ #category : 'accessing' }
TTVaultAbstract >> setOptionsForAll [

	 options := self getOptionsForAll
 
	
]

{ #category : 'accessing' }
TTVaultAbstract >> setOptionsForApp: appFilter [

	 options := self getOptionsForApp: appFilter
 
	
]

{ #category : 'accessing' }
TTVaultAbstract >> userId [

	"update later"
	
	^ TheHub userId
]
