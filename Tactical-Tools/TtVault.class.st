Class {
	#name : 'TTVault',
	#superclass : 'TTVaultAbstract',
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'instance creation' }
TTVault class >> makeDictionaryDotEnvFile: file [

	^ TTDictionaryDotEnv new
				setValueWriter: TTVaultValueWriter new;
				setSource: file;
				yourself
]

{ #category : 'instance creation' }
TTVault class >> makeDictionaryFrom: streamable [


]

{ #category : 'instance creation' }
TTVault class >> makeDictionaryMiseFor: projectDirectory [

	^ TTDictionaryMiseEnv new
				setValueWriter: TTVaultValueWriter new;
				setSource: projectDirectory;
				yourself
]

{ #category : 'instance creation' }
TTVault class >> makeDictionaryOSEnv [

	^ TTDictionaryOSEnv new
				setSource: Hub;
				setValueWriter: TTVaultValueWriter new;
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
	
	| firstTier newTier|
	
	(self searchPathFor: Hub currentTestable) 
	
			do: [ :assoc | 
				
				| tierKey file |
				tierKey := assoc key.
				file := assoc value.
				
				FileLookedForNotification signal:file.
				
				file exists ifTrue: [
				  newTier := self makeTierWithKey: tierKey. 
					
					newTier setDictionary: (self makeDictionaryDotEnvFile: file) .
														
					firstTier ifNil: [ firstTier := newTier ]
		  							ifNotNil: [ firstTier tierAppend: newTier ].
		  	]
			].

	^ firstTier
]

{ #category : 'instance creation' }
TTVault class >> makeTierMiseFor: project [
	
	<gtExample>
	  
  ^ (self makeTierWithKey:#mise) 
			setDictionary: (self makeDictionaryMiseFor: project);
			yourself
				 
]

{ #category : 'instance creation' }
TTVault class >> makeTierOSEnv [

	<gtExample>

	^ (self makeTierWithKey:#os) 
			setDictionary: self makeDictionaryOSEnv;
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
TTVault class >> newDefaultVault [
	^ self newWithRWConfigOSEnv
]

{ #category : 'instance creation' }
TTVault class >> newEmpty [

 <gtExample>

 ^ self basicNew
		initialize
		
]

{ #category : 'instance creation' }
TTVault class >> newWithRW [ 

 <gtExample>

 ^ self basicNew
		setConfig: self makeTierRW
		yourself
		
]

{ #category : 'instance creation' }
TTVault class >> newWithRWConfigOSEnv [

 <gtExample>

 | firstTier |
 
 firstTier := (self makeTierRW)
 									tierAppend: self makeTierConfig;
									 tierAppend:self makeTierOSEnv;
									 yourself.
  					 
 ^ (self basicNew)
		setConfig: firstTier;
		initialize
		
]

{ #category : 'instance creation' }
TTVault class >> searchPath [
	<gtExample>
 
	^ self searchPathFor: (Hub current)
]

{ #category : 'instance creation' }
TTVault class >> searchPathFor: whoami [
	"Prefer / (a,'.env) over / a , 'env' " 

	| vmId hubId userId projectId |
	
	(whoami askFor: #isWhoAmI) ifFalse: [ self error: 'Must provide identity' ].
	
	vmId := whoami bundleId.
	hubId := whoami hubId.
	projectId := whoami projectId. "$PROJECT_ID"
	userId := whoami userId.
	
	"(#project is $PROJECT_DIR)"
	
	^ {
	
		#cwd     -> ((hubId , '.env') asFileReference).
		
		"likely redundant (have a different scanner for these)"
		#'embedded-project'     -> (File // projectId / (hubId, '.env')) resolve.
		#'embedded-project-config'     -> (File // projectId / 'config'/ (hubId, '.env')) resolve.
		
		"Project origin defined by $PROJECT"
		#'project-override' -> (File // #project / '.env') resolve. "gitignored"
		#'project' -> (File // #project / (projectId, '.env')) resolve.
		#'project-platform' -> (File // #project / (hubId, '.env')) resolve.
 	 #'project-platform-config' -> (File // #project / 'config' / (hubId , '.env')) resolve.

		#'user-project' -> (File // #config / projectId/ (hubId , '.env')) resolve.
	  #'user-project-prefs' -> (File // #preferences / (projectId, '.', hubId , '.env') ) resolve.

		"per user"
		#'user-platform' -> (File // #config / vmId / (hubId , '.env')) resolve.
	  #'user-platform-prefs' -> (File // #preferences / (vmId,'.', hubId , '.env') ) resolve.
	   
	}
]

{ #category : 'instance creation' }
TTVault class >> traceCurrentSearchPath [
	
	<gtExample>
	
	^ FileLookedForNotification collectDuring: [ self newDefaultVault ]
]

{ #category : 'accessing' }
TTVault >> funcNormalizeOn: assoc [

	"pass thru function that 
	
		1. Only handling keys that conform to our scheme
		   Others can remain on the search path via #config.
		   
		2. prepends default__ option to any <key>__<field> pair that has no given option.
		4. standardised capitalisation is applied <toLowercase>__<toLowercase>__<toLowercase>
		
	  SEE CLASS COMMENT for format decision tree"

			| key size preserveCase |
		 
			key := (assoc key) splitOn: '__'.
			size := key size.
 		 
			(size < 2 or: [ key first isEmpty ]) ifTrue: [ ^ nil ].
			
			size = 2 ifTrue:  [ key addFirst: 'default' ].
		
			"leaving the key as a pre-parsed array for downstream"

			1 to: 3 do:[ :n |
				key at: n put: (key at: n) asLowercase.
			].
			
  	^ (assoc copy)
  			key: key asArray;
  			yourself				

		
 
	
]
