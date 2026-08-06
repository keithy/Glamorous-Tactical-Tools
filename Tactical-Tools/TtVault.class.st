Class {
	#name : 'TTVault',
	#superclass : 'Object',
	#instVars : [
		'store',
		'projectDirectory'
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
TTVault class >> makeStoreCache [
	
	<gtExample>
	
	^ TTDictionaryTiered newCache. "top tier"
 
]

{ #category : 'instance creation' }
TTVault class >> makeStoreCacheConfigEnv [
	
	"our test show it all"
	
	<gtExample>
	 
	
	| files store user projectId project |
	
	store  := self makeStoreCacheEnv.
	
	project := store deepAt: #GT_ID ifAbsentPut: [ self projectId].
		
	files := self searchPathName: (self vaultId) project: project.

	files reverseDo: [ :assoc |
 
 		| file |
 		file := assoc value.
 		
 		file exists ifTrue: [
					TTDictionaryDotEnv new 
						tierKey: assoc key;
						tierInsertIn: store after: #cache;
						readSource: file;
						
						
						yourself.
		 ]
	].
							
	^ store
]

{ #category : 'instance creation' }
TTVault class >> makeStoreCacheEnv [
	
	"our test show it all"
	
	<gtExample>
	 
	
	| store user project |
	
	store  := self makeStoreCache.
 
	TTDictionaryTiered new
			tierKey: #os;
			addAll: (TheHub osEnvironment);
			beCache;
			tierAppendTo: store.
	
	user := store 
		deepAt: #USER 
		ifAbsentPut: [ store deepAt: #USERNAME 
											ifAbsent: [ self error: 'no USERNAME found' ]].

	^ store
]

{ #category : 'instance creation' }
TTVault class >> makeStoreCacheMiseConfigEnv [
	
	"our test show it all"
	
	<gtExample>
	 
	
	| files store user projectId project |
	
	store  := self makeStoreCacheConfigEnv.
	
	project := store deepAt: 'PROJECT' ifAbsent: [ ^ store ].

  project asFileReference exists ifTrue: [
					
			TTDictionaryMiseEnv new 
				tierKey: #mise;
				tierInsertIn: store after: #cache;
				readSource: project
	].
				
	^ store
]

{ #category : 'instance creation' }
TTVault class >> makeStoreEmpty [
	
	<gtExample>
	<return: #String>
	
	| dotEnv cache|
	
	dotEnv := TTDictionaryDotEnv new tierKey: #dotEnv; yourself.
	cache  := TTDictionaryTiered newCache.
							
	cache appendTier: dotEnv.
							
	^ self basicNew
		store: cache
		initialize
]

{ #category : 'instance creation' }
TTVault class >> newValueWriter [

	^ TTVaultValueWriter new
]

{ #category : 'instance creation' }
TTVault class >> projectId [
  "use default"
^ TheHub osEnvironment at: '__CFBundleIdentifier' ifAbsent: 'gtoolkit' 
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
	
	}
]

{ #category : 'instance creation' }
TTVault class >> vaultId [

	^ self name asLowercase
]

{ #category : 'accessing' }
TTVault >> projectDirectory [
	^ projectDirectory ifNil: [ '.' asFileReference ]
]

{ #category : 'accessing' }
TTVault >> projectDirectory: anObject [
	projectDirectory := anObject
]

{ #category : 'accessing' }
TTVault >> store [
	^ store
]

{ #category : 'accessing' }
TTVault >> store: aTieredDict [

	aTieredDict valueWriter: self class newValueWriter.
	store := aTieredDict
]
