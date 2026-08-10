Class {
	#name : 'TTVault',
	#superclass : 'Object',
	#instVars : [
		'store',
		'valueWriter'
	],
	#classInstVars : [
		'currentVault'
	],
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'instance creation' }
TTVault class >> bundleId [
  "use default"
	^ TheHub bundleId
]

{ #category : 'instance creation' }
TTVault class >> configBasenames [
	^ {TheHub current hubId.
		TheHub current userId}
]

{ #category : 'instance creation' }
TTVault class >> currentVault [
	^ currentVault ifNil: [ currentVault := self getCurrentVault ]
]

{ #category : 'instance creation' }
TTVault class >> getCurrentVault [
	^ self newWithLocalMiseConfigOSEnv
]

{ #category : 'instance creation' }
TTVault class >> makeStoreCache [
	
	"top tier"

		<gtExample>
	
	^ TTDictionaryTieredOld newCache
				valueWriter: self makeValueWriter;
				yourself 
 
]

{ #category : 'instance creation' }
TTVault class >> makeStoreLocal [
	
	"top tier"

		<gtExample>
	
	^ TTDictionaryTieredOld newLocal
				valueWriter: self makeValueWriter;
				yourself 
 
]

{ #category : 'instance creation' }
TTVault class >> makeStoreLocalConfigOSEnv [
	"our test show it all"

	<gtExample>
	| files store gt_id |
	store := self makeStoreLocalOSEnv.	"Subclassing TheGlamorousHub gives you a different env file"
	gt_id := store deepAt: #BUNDLE_ID ifAbsentPut: [ self bundleId ].

 
	(self searchPathFor: TheHub current)
	
			reverseDo: [ :assoc | 
				self store: store addConfigFile: assoc afterTier: #local 
			].

	^ store
]

{ #category : 'instance creation' }
TTVault class >> makeStoreLocalMiseConfigOSEnv [
	
	"our test show it all"
	
	<gtExample>
	 
	
	| store project |
	
	store  := self makeStoreLocalConfigOSEnv.
	
	project := store deepAt: 'PROJECT' ifAbsent: [ ^ store ].

  project asFileReference exists ifTrue: [
					
			TTDictionaryMiseEnv new 
				tierKey: #mise;
				tierInsertIn: store after: #local;
				readSource: project
	].
				
	^ store
]

{ #category : 'instance creation' }
TTVault class >> makeStoreLocalOSEnv [
	
	"our test show it all"
	
	<gtExample>
	 
	
	| store |
	
	store  := self makeStoreLocal.
 
	TTDictionaryTieredOld new
			tierKey: #os;
			addAll: (TheHub osEnvironment);
			beCache;
			tierAppendTo: store.
	
	"see #assocLocalUser"
	"user := store 
		deepAt: #USER 
		ifAbsentPut: [ store deepAt: #USERNAME 
											ifAbsent: [ self error: 'no USERNAME found' ]]."

	^ store
]

{ #category : 'instance creation' }
TTVault class >> makeValueWriter [

	^ TTVaultValueWriter new
]

{ #category : 'instance creation' }
TTVault class >> new [

^ self newWithCache
		
]

{ #category : 'instance creation' }
TTVault class >> newWithCache [

^ self basicNew
		store: self makeStoreCache
		yourself
		
]

{ #category : 'instance creation' }
TTVault class >> newWithLocalMiseConfigOSEnv [

 <gtExample>

 ^ self basicNew
		store: self makeStoreLocalMiseConfigOSEnv
		yourself
		
]

{ #category : 'accessing' }
TTVault class >> reset [

currentVault := nil
]

{ #category : 'instance creation' }
TTVault class >> searchPath [
	<gtExample>
 
	^ self
		searchPathFor: (TheHub current)
]

{ #category : 'instance creation' }
TTVault class >> searchPathFor: whoami [
	"Prefer / (a,'.env) over / a , 'env' " 

	| bundleId hubId userId |
	
	(whoami askFor: #isWhoAmI) ifFalse: [ self error: 'Must provide identiy' ].
	
	bundleId := whoami bundleId.
	hubId := whoami hubId.
	userId := whoami userId.
	
	^ {
	  #hidden -> ('.env' asFileReference).
		#cwd    -> ((hubId , '.env') asFileReference).
		
		#uconfig -> ((TheHub fileReferenceFrom: '{home}/.config') / bundleId / (userId , '.env')) resolve.
	  #uprefs -> ((TheHub fileReferenceFrom: '{preferences}') / (bundleId,'.', userId , '.env') ) resolve.

		#config -> ((TheHub fileReferenceFrom: '{home}/.config') / bundleId / (hubId , '.env')) resolve.
	  #prefs -> ((TheHub fileReferenceFrom: '{preferences}') / (bundleId,'.', hubId , '.env') ) resolve.
	
	}
]

{ #category : 'instance creation' }
TTVault class >> showMeTheSearchPath [
	
	<gtExample>
	
	^ self showMeTheSearchPathDuring: [ self getCurrentVault ]


	

]

{ #category : 'instance creation' }
TTVault class >> showMeTheSearchPathDuring: aBlock [

	^ TheHub collectNotificationsOfClass: FileLookedForNotification during: aBlock
]

{ #category : 'instance creation' }
TTVault class >> shutDown: quitting [

  <ttShutDown>

  quitting ifTrue: [ self reset ]
	
	
]

{ #category : 'instance creation' }
TTVault class >> startUp: isImageStarting [

	<ttStartUp>
	
	isImageStarting ifFalse: [ self reset ]
	
	
]

{ #category : 'instance creation' }
TTVault class >> store: store addConfigFile: assoc afterTier: tierKey [
	| file |
	file := assoc value.
	FileLookedForNotification signal: file fullName.

	^ file exists
		ifTrue: [ (store tierKeys includes: assoc key)
				ifFalse: [ TTDictionaryDotEnv new
						tierKey: assoc key;
						tierInsertIn: store after: tierKey;
						readSource: file;
						yourself ] ]
]

{ #category : 'instance creation' }
TTVault class >> vaultId [

	^ (self name withoutSuffix: 'TT') asLowercase
]

{ #category : 'as yet unclassified' }
TTVault >> assocForApp: anApp user: aUserAssoc field: field ifAbsent: aBlock [
	| user keys app |
	
	app := anApp asString. "?"
	
	user :=  aUserAssoc value.
	
	self logStartApp: app field: field user: aUserAssoc.

	keys := { (user, '__', app , '_' , field). (user asLowercase, '__', app , '_' , field). }. 

	store deepAssociationAt: keys ifPresentAssocAndTierDo: [ :a | ^ a ].

	keys := app , '_' , field.
	
	store deepAssociationAt: keys ifPresentAssocAndTierDo: [ :a  | ^ a  ].

	^ aBlock value
	
]

{ #category : 'as yet unclassified' }
TTVault >> assocLocalUser [

	^ store deepAt: #('USER' 'USERNAME') ifPresentValueKeyAndTierDo: [ :v :k :t | t -> v copyReplaceAll: '-' with: '_' ]
]

{ #category : 'as yet unclassified' }
TTVault >> gtItemsFor: aView [
	<gtView>
	
	^ aView forward
		title: 'Items';
		priority: 10;
		object: [ store ];
		view: #gtItemsFor:
]

{ #category : 'as yet unclassified' }
TTVault >> isWhoAmI [

	<ttWhoAmI>
	
	"Can provide identity"

	^ true
]

{ #category : 'accessing' }
TTVault >> projectDirectory: anObject [
	projectDirectory := anObject
]

{ #category : 'accessing' }
TTVault >> reset [
]

{ #category : 'accessing' }
TTVault >> store [
	^ store
]

{ #category : 'accessing' }
TTVault >> store: aTieredDict [

	aTieredDict valueWriter: self class makeValueWriter.
	store := aTieredDict
]
