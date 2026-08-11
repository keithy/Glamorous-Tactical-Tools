Class {
	#name : 'TTVault',
	#superclass : 'TTVaultAbstract',
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'accessing' }
TTVault class >> commonFields [
	^ #('_URL' '_USER' '_APIKEY' '_TOKEN' '_EMAIL' '_PASS')
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
	
	(self searchPathFor: TheHub currentTestable) 
	
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
		config: self makeTierRW
		initialize
		
]

{ #category : 'instance creation' }
TTVault class >> newWithRWConfigOSEnv [

 <gtExample>

 | nonBackedStore |
 
 nonBackedStore := self makeTierRW.
 						
 (nonBackedStore tierInsert: self makeTierConfig) tierInsert: self makeTierOSEnv.
  					 
 ^ (self basicNew)
		config: nonBackedStore;
		initialize
		
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

{ #category : 'accessing' }
TTVault >> configApp: anApp optionAndFieldValuesDo: aBlock [

	| ucApp |
	
	ucApp := anApp asUppercase.
	
	self configNormalized associations do: [ :assoc |
	
		| option keyStr field |
		
		keyStr := assoc key readStream.
		option := keyStr upToAll: '__'.
		keyStr upToAll: ucApp.
		
		keyStr atEnd ifFalse: [
		
			field := keyStr upToEnd.
			aBlock value: option value: ucApp value: field value: (assoc value)
		]
	].
	
	 
	
]

{ #category : 'accessing' }
TTVault >> configNormalized [

	| matcher |
	
	matcher := '__', ((appKey ifNil: '') asUppercase), '_'.

	^ self config associations collect: [ :in |
	 			(self funcUppercaseKeysOn: 
	 				(self funcNormalizeDefaultsOn: in))
		] thenSelect: [ :out | self funcApp: matcher filter: out ]
]

{ #category : 'accessing' }
TTVault >> configRefresh [
  
  "dont everyone do this"
  | unique |
  
	unique := config tiersCollect: [ :tier | tier writableDictionary ] on: IdentitySet new.
	unique do: [ :dict | dict askFor: #readSource ]
	
]

{ #category : 'accessing' }
TTVault >> configuredApps [
	"scan for list of apps in config, should not need configNormalized"

	| apps hunt |
	apps := Set new.

	hunt := self class commonFields.

	self config
		do: [ :assoc | 
			| found key keyStr |
			key := assoc key.

			(hunt
				anySatisfy: [ :suffix | 
					found := suffix.
					key endsWith: suffix ])
				ifTrue: [ key := key withoutSuffix: found.
					keyStr := assoc key readStream.
					keyStr upToAll: '__'.

					keyStr atEnd ifFalse: [ key := keyStr upToEnd ].

					apps add: key asLowercase ] ].

	^ apps
]

{ #category : 'accessing' }
TTVault >> funcApp: appMatcher filter: assoc [

	"select function on appKey"
 	
  ^ 0 < (assoc key findString: appMatcher )
	 
 
		
 
	
]

{ #category : 'accessing' }
TTVault >> funcNormalizeDefaultsOn: assoc [

	"pass thru function that prepends default__ to any keys that have no options"

			| keyStr option key newKey |
			
			key := assoc key.
			 
			option := key copyUpToSubstring: '__'.
			 
			newKey := (option = key) 
				ifTrue: [ 'default__',key ]
			  ifFalse: [ 
			  		newKey := key copy.
			  		newKey copyReplaceFrom: 1 to: option size with: option asLowercase
			  ].
 			
  	^ (assoc copy)
  			key: newKey;
  			yourself				

		
 
	
]

{ #category : 'accessing' }
TTVault >> funcUppercaseKeysOn: assoc [

	"pass thru function that ensures that keys are uppercase"

	| key newKey start stop |
			
	key := assoc key.
	
	start := key findString: '__'.
	
	"not found, set start"
	start == 0 ifTrue: [ start := 1 ].
	stop := key size.

	newKey := key copy.
  	
	start to: stop do: [ :n |
	  newKey at: n put: (newKey at: n) asUppercase
	].
		
  ^ (assoc copy)
  			key: newKey;
  			yourself				
 
		
 
	
]
