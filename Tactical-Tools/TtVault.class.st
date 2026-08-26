Class {
	#name : 'TTVault',
	#superclass : 'TTVaultAbstract',
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'instance creation' }
TTVault class >> makeDictionaryMiseFor: projectDirectory [

	^ TTDictionaryMiseEnv  newSource: projectDirectory
				 
]

{ #category : 'instance creation' }
TTVault class >> makeDictionaryWithAll: collection [
	^ collection asDictionary
]

{ #category : 'instance creation' }
TTVault class >> makeTierMiseFor: project [
	
	<gtExample>
	  
  ^ (self makeTierWithKey:#mise) 
			setDictionary: (self makeDictionaryMiseFor: project);
			yourself
				 
]

{ #category : 'instance creation' }
TTVault class >> makeTierRW [
	<gtExample>
	^ Dictionary new asTier
				tierKey: #rw;
				yourself
	
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
	"^ self newWithRWConfigOSEnv"
	^ self newWithAllReaderClasses
]

{ #category : 'instance creation' }
TTVault class >> newReading: readers [
	<gtExample>
	^ self
		newUsing: [ :newVault | 
			readers
				do: [ :aClassName | newVault config tierAppend: (#class: // aClassName) makeWithAllSubclassesAsTiers ].

			newVault ]
]

{ #category : 'instance creation' }
TTVault class >> newUsing: aBlock [
	"creation pattern ensuring initialization is last"

	| newVault |
	newVault := self basicNew.
	newVault setConfig: self makeTierRW.

	^ (aBlock value: newVault) initialize
]

{ #category : 'instance creation' }
TTVault class >> newWithAllReaderClasses [

^ self newReading: self readerClasses
]

{ #category : 'instance creation' }
TTVault class >> newWithRW [
	<gtExample>
	^ self newUsing: [ :newVault | newVault ]
		 

]

{ #category : 'instance creation' }
TTVault class >> newWithRWConfigOSEnv [
	<gtExample>
	^ self
		newUsing: [ :newVault | 
			newVault config
				tierAppend: TTDictionaryConfigEnv makeAsTier;
				tierAppend: TTDictionaryOSEnv makeAsTier ]
]

{ #category : 'instance creation' }
TTVault class >> readerClasses [

	^ #(TTDictionaryConfigEnv TTDictionaryOSEnv)
]

{ #category : 'instance creation' }
TTVault class >> traceCurrentSearchPath [
	
	<gtExample>
	
	^ FileNotification collectDuring: [ self reset currentVault ]
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
