Class {
	#name : 'TTVault',
	#superclass : 'Object',
	#instVars : [
		'store',
		'valueWriter',
		'vault'
	],
	#classInstVars : [
		'currentVault'
	],
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'instance creation' }
TTVault class >> currentVault [
	^ currentVault ifNil: [ currentVault := self getCurrentVault ]
]

{ #category : 'instance creation' }
TTVault class >> getCurrentVault [
	^ self newWithRWConfigOSEnv
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
	
	(self searchPathFor: TheHub current) 
	
			reverseDo: [ :assoc | 
				
				| tierKey file |
				tierKey := assoc key.
				file := assoc value.
				
				FileLookedForNotification signal:file.
				
				file exists ifTrue: [
				  newTier := self makeTierWithKey: tierKey. 
					
					newTier setDictionary: (self makeDictionaryDotEnvFile: file) .
														
					lastTier 
		  				ifNil: [ firstTier := newTier. lastTier := newTier ]
		  				ifNotNil: [ lastTier := lastTier tierInsert: newTier ].
		  	]
			].

	^ firstTier
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
TTVault class >> makeTierRW [
	
		<gtExample>
	
	^ self makeTierWithKey:#rw

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

^ self newWithRWConfigOSEnv
		
]

{ #category : 'instance creation' }
TTVault class >> newWithRW [ 

 <gtExample>

 ^ self basicNew
		store: self makeTierRW
		initialize
		
]

{ #category : 'instance creation' }
TTVault class >> newWithRWConfigOSEnv [

 <gtExample>

 | store |
 
 store := self makeTierRW.
 						
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

{ #category : 'accessing' }
TTVault >> apps [

	| result hunt | 
	
	result := Set new.
	 
	hunt := #('_URL' '_USER' '_APIKEY' '_TOKEN' '_EMAIL' '_PASS').
	 
	vault do: [ :selection |
	
		(vault at: selection) associationsDo: [ :assoc |
		
			| key |
			
			key := assoc key.
			
			(hunt anySatisfy: [ :suffix | key endsWith: suffix ])
				ifTrue: [ 
							result add: (key readStream copyUpToLast: $_)
				]
		]
	].
			 
	^ result
	 
]

{ #category : 'accessing' }
TTVault >> bundleId [

	"update later"
	
	^ TheHub bundleId
]

{ #category : 'accessing' }
TTVault >> forApp: anApp [

	| result app | 
	
	result := Dictionary new.
	app := anApp asUppercase
	
	vault do: [ :selection |
	
		(vault at: selection) associationsDo: [ :assoc |
		
			| key |
			
			key := assoc key.
			(key beginsWith: app)
				ifTrue: [ 
							
						(result at: selection ifAbsentPut: [ Dictionary new ]) 
								
									at: (key withoutPrefix: app) put: assoc value.
				]
		]
	]
			 
	
	 
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

{ #category : 'accessing' }
TTVault >> hubId [

	"update later"
	
	^ TheHub hubId
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
TTVault >> projectId [

	"update later"
	
	^ TheHub projectId
]

{ #category : 'accessing' }
TTVault >> readStore [

	vault := Dictionary new.
	vault at: #default put: Dictionary new.
	

	^ store associationsDo: [ :assoc |
		
	
	]
	
	
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

{ #category : 'accessing' }
TTVault >> userId [

	"update later"
	
	^ TheHub userId
]

{ #category : 'accessing' }
TTVault >> vault [
    ^ vault
]

{ #category : 'accessing' }
TTVault >> vaultRefresh [

	vault := Dictionary new.

	^ store associations do: [ :assoc |
			| keyStr selection key |
			
			key := assoc key.
			keyStr := key readStream.
			
			selection := keyStr upToAll:'__'.
			 
			(selection = key)
				ifTrue: [ selection := 'default' ]
			  ifFalse: [ key := keyStr upToEnd ].
 
 			(vault at: selection asLowercase ifAbsentPut: [ Dictionary new ])
 				at: key asUppercase put: assoc value.
 			
		]
	
	
	
	
]
