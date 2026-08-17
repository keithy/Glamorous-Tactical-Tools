Class {
	#name : 'TTVault',
	#superclass : 'TTVaultAbstract',
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'instance creation' }
TTVault class >> makeDictionaryDotEnvFile: file [

	^ TTDictionaryConfigEnv new
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

	^ TTDictionaryOSEnv makeAsTier 
			 
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
