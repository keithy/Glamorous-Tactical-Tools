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
TTVault class >> currentVault [
	^ currentVault ifNil: [ currentVault := self getCurrentVault ]
]

{ #category : 'instance creation' }
TTVault class >> getCurrentVault [
	^ self newWithLocalConfigOSEnv
]

{ #category : 'instance creation' }
TTVault class >> makeDictionaryDotEnvFile: file [

	^ TTDictionaryDotEnv new
				valueWriter: TTVaultValueWriter new;
				source: file;
				readSource;
				yourself
]

{ #category : 'instance creation' }
TTVault class >> makeDictionaryFrom: streamable [


]

{ #category : 'instance creation' }
TTVault class >> makeDictionaryMiseFor: projectDirectory [

	^ TTDictionaryMiseEnv new
				valueWriter: TTVaultValueWriter new;
				source: projectDirectory;
				yourself
]

{ #category : 'instance creation' }
TTVault class >> makeDictionaryOSEnv [

	^ TTDictionaryOSEnv new
				source: TheHub;
				valueWriter: TTVaultValueWriter new;
				readSource;
				yourself
]

{ #category : 'instance creation' }
TTVault class >> makeDictionaryWithAll: collection [
	^ collection asDictionary
]

{ #category : 'instance creation' }
TTVault class >> makeTierConfig [
	"our test show it all"

	<gtExample>
	
	| lastTier firstTier newTier|
	
	((self searchPathFor: TheHub current) select: [ :keyAndFileReference | keyAndFileReference value exists ])
	
			reverseDo: [ :assoc | 
	
			  newTier := self makeTierWithKey: assoc key. 
				
				newTier setDictionary: (self makeDictionaryDotEnvFile: assoc value) .
													
				lastTier 
	  				ifNil: [ firstTier := newTier. lastTier := newTier ]
	  				ifNotNil: [ lastTier := lastTier tierInsert: newTier ].
			].

	^ firstTier
]

{ #category : 'instance creation' }
TTVault class >> makeTierLocal [
	
		<gtExample>
	
	^ self makeTierWithKey:#local

]

{ #category : 'instance creation' }
TTVault class >> makeTierMiseFor: project [
	
	<gtExample>
	  
  ^ (self makeTierWithKey:#mise) 
			in: [ :newTier | newTier setDictionary: (self makeDictionaryMiseFor: project)    ];
			yourself
				 
]

{ #category : 'instance creation' }
TTVault class >> makeTierOSEnv [

	<gtExample>

	^ (self makeTierWithKey:#os) 
			in: [ :newTier | newTier setDictionary: (self makeDictionaryOSEnv) ];
			yourself
]

{ #category : 'instance creation' }
TTVault class >> makeTierWithKey: key [
	
		<gtExample>
	
	^ TTDictionaryTiered newWithKey: key

]

{ #category : 'instance creation' }
TTVault class >> makeValueWriter [

	^ TTVaultValueWriter new
]

{ #category : 'instance creation' }
TTVault class >> new [

^ self newWithLocalConfigOSEnv
		
]

{ #category : 'instance creation' }
TTVault class >> newWithLocal [ 

 <gtExample>

 ^ self basicNew
		store: self makeTierLocal
		initialize
		
]

{ #category : 'instance creation' }
TTVault class >> newWithLocalConfigOSEnv [

 <gtExample>

 | store |
 
 store := self makeTierLocal.
 						
 (store tierInsert: self makeTierConfig) tierInsert: self makeTierOSEnv.
  					 
 ^ (self basicNew)
		store: store;
		initialize
		
]

{ #category : 'accessing' }
TTVault class >> reset [

currentVault := nil
]

{ #category : 'instance creation' }
TTVault class >> searchPath [
	<gtExample>
 
	^ self searchPathFor: (TheHub current)
]

{ #category : 'instance creation' }
TTVault class >> searchPathFor: whoami [
	"Prefer / (a,'.env) over / a , 'env' " 

	| bundleId hubId userId |
	
	(whoami askFor: #isWhoAmI) ifFalse: [ self error: 'Must provide identity' ].
	
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
	
	^ FileLookedForNotification collectDuring: [ self getCurrentVault ]


	

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
 
	store := aTieredDict
]
