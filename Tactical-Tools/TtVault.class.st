Class {
	#name : 'TTVault',
	#superclass : 'TTVaultAbstract',
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

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

	^ self newWithRW
		
]

{ #category : 'instance creation' }
TTVault class >> newWithRW [ 

 <gtExample>

 ^ self basicNew
		setConfig: self makeTierRW
		initialize
		
]

{ #category : 'instance creation' }
TTVault class >> newWithRWConfigOSEnv [

 <gtExample>

 | nonBackedStore |
 
 nonBackedStore := self makeTierRW.
 						
 (nonBackedStore tierInsert: self makeTierConfig) tierInsert: self makeTierOSEnv.
  					 
 ^ (self basicNew)
		setConfig: nonBackedStore;
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
TTVault class >> traceCurrentSearchPath [
	
	<gtExample>
	
	^ FileLookedForNotification collectDuring: [ self getCurrentVault ]


	

]

{ #category : 'accessing' }
TTVault >> configRefresh [
  
  "don't everyone do this"
  | unique |
  
	unique := config tiersCollect: [ :tier | tier writableDictionary ] on: IdentitySet new.
	unique do: [ :dict | dict askFor: #readSource ]
	
]

{ #category : 'accessing' }
TTVault >> funcNormalizeOn: assoc [

	"pass thru function that 
	
		1. prepends default__ option to any <key>__<field> pair that has no given option.
		2. any keys that had __<key> prefix are prefixed _<key> to avoid confusing the parser
		3. any standalone <key> becomes default____<key>.
		4. standardised capitalisation is applied <toLowercase>__<toUppercase>__<toUppercase>
		
	  SEE CLASS COMMENT for format decision tree"

			| key size preserveCase |
		 
		  preserveCase := false.
			key := (assoc key,'__') splitOn: '__'.
			size := key size.
 
			size = 4 ifFalse: [  
			
				size = 3 ifTrue:  [ 
				  key addFirst: 'default'. 
					key second ifEmpty: [ preserveCase := true. key at: 3 put: ('__', (key at: 3)) ]
				].
			  
			  size = 2 ifTrue: [
			  	preserveCase := true.
			  	key addFirst: ''. 
			  	key addFirst: 'default' 
			  ]
			].
			
			preserveCase ifFalse: [
				key at: 1 put: (key at: 1) asLowercase.
				key at: 2 put: (key at: 2) asLowercase.
				key at: 3 put: (key at: 3) asLowercase.
			].
			
			key removeLast.
			
			"leaving the key as a pre-parsed array for downstream"
			
  	^ (assoc copy)
  			key: key asArray;
  			yourself				

		
 
	
]
