Class {
	#name : 'TTVault',
	#superclass : 'Object',
	#instVars : [
		'store'
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

^ currentVault ifNil: [ currentVault := self new ]
]

{ #category : 'instance creation' }
TTVault class >> newDemoRead [
	
	<gtExample>
	<return: #String>
	
	| vault |
	
	vault := self newTest.
	
	vault store in: [ :store |
	
		(store tierAt: #cache) addAll: TheHub osEnvironment.
		
		(store tierAt: #dotEnv) readSource: 'HELLO_PASS="WORLD"'.
		"'.env' asFileReference"
		
	].
	
	^ vault
]

{ #category : 'instance creation' }
TTVault class >> newStore [
	
	"our test show it all"
	
	<gtExample>
	 
	
	| files store user project |
	
	store  := TTDictionaryTiered newCache. "top tier"
 
		(TTDictionaryTiered newWithTierKey: #os)
				addAll: (TheHub osEnvironment);
				beCache;
				appendTierTo: store.
	
	user := store 
		deepAt: #USER 
		ifAbsentPut: [ store deepAt: #USERNAME 
											ifAbsent: [ self error: 'no USERNAME found' ]].
	
	project := store deepAt: #GT_PROJECT ifAbsentPut: [ 'com.gtoolkit' ].
		
	files := self searchPathName: self vaultId project: self projectId.

	files keysAndValuesDo: [ :key :file |
 
 		file exists ifTrue: [
	 		store appendTier:
					((TTDictionaryDotEnv newWithTierKey: #key) readSource: file).
		 ]
	].
							
	^ store
]

{ #category : 'instance creation' }
TTVault class >> newTestEmpty [
	
	<gtExample>
	<return: #String>
	
	| dotEnv cache|
	
	dotEnv := TTDictionaryDotEnv newWithTierKey: #dotEnv.
	cache  := TTDictionaryTiered newCache.
							
	cache appendTier: dotEnv.
							
	^ self basicNew
		store: cache
		initialize
]

{ #category : 'instance creation' }
TTVault class >> projectId [

^ 'com.gtoolkit'
]

{ #category : 'instance creation' }
TTVault class >> searchPath [
 	
  <gtExample>
 	
	^ self searchPathName: self vaultId project: self projectId.
]

{ #category : 'instance creation' }
TTVault class >> searchPathName: aName project: aProject [ 

	"Prefer / (a,'.env) over / a , 'env' " 

	^ {
		#cwd    -> ((aName , '.env') asFileReference).
		#config -> ((TheHub fileReferenceFrom: '{home}/.config') / aProject / (aName , '.env')) resolve.
	  #prefs -> ((TheHub fileReferenceFrom: '{preferences}') / (aProject,'.', aName , '.env') ) resolve.
	
	} asDictionary
]

{ #category : 'instance creation' }
TTVault class >> vaultId [

	^ self name asLowercase
]

{ #category : 'accessing' }
TTVault >> store [
	^ store
]

{ #category : 'accessing' }
TTVault >> store: anObject [
	store := anObject
]
