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

^ currentVault ifNil: [ currentVault := self newWithCacheMiseConfigEnv ]
]

{ #category : 'instance creation' }
TTVault class >> makeStoreCache [
	
	"top tier"

		<gtExample>
	
	^ TTDictionaryTiered newCache
				valueWriter: self makeValueWriter;
				yourself 
 
]

{ #category : 'instance creation' }
TTVault class >> makeStoreLocal [
	
	"top tier"

		<gtExample>
	
	^ TTDictionaryTiered newLocal
				valueWriter: self makeValueWriter;
				yourself 
 
]

{ #category : 'instance creation' }
TTVault class >> makeStoreLocalConfigOSEnv [
	
	"our test show it all"
	
	<gtExample>
	 
	
	| files store user projectId project |
	
	store  := self makeStoreLocalOSEnv.
	
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
TTVault class >> makeStoreLocalEnvEmpty [
	
	<gtExample>
	<return: #String>
	
	| dotEnv local|
	
	dotEnv := TTDictionaryDotEnv new tierKey: #dotEnv; yourself.
	local  := TTDictionaryTiered newLocal.
							
	local appendTier: dotEnv.
							
	^ self basicNew
			store: local
			initialize
]

{ #category : 'instance creation' }
TTVault class >> makeStoreLocalMiseConfigOSEnv [
	
	"our test show it all"
	
	<gtExample>
	 
	
	| files store user projectId project |
	
	store  := self makeStoreLocalConfigOSEnv.
	
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
TTVault class >> makeStoreLocalOSEnv [
	
	"our test show it all"
	
	<gtExample>
	 
	
	| store |
	
	store  := self makeStoreLocal.
 
	TTDictionaryTiered new
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
TTVault class >> newWithCacheMiseConfigEnv [

 <gtExample>

 ^ self basicNew
		store: self makeStoreLocalMiseConfigOSEnv
		yourself
		
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
TTVault class >> test [

	<gtExample>
	
	| vault |
	
	vault := self newWithCacheMiseConfigEnv 
	
	assocLocalUser
		
]

{ #category : 'instance creation' }
TTVault class >> vaultId [

	^ self name asLowercase
]

{ #category : 'as yet unclassified' }
TTVault >> assocForApp: anApp user: aUserAssoc field: field ifAbsent: aBlock [
	| user keys app |
	
	app := anApp asString. "?"
	
	user :=  aUserAssoc value.
	
	self logStartApp: app field: field user: aUserAssoc.

	keys := { (user, '__', app , '_' , field). (user asLowercase, '__', app , '_' , field). }. 

	store deepAssociationAt: keys ifPresent: [ :a | ^ a ].

	keys := app , '_' , field.
	
	store deepAssociationAt: keys ifPresent: [ :a  | ^ a  ].

	^ aBlock value
	
]

{ #category : 'as yet unclassified' }
TTVault >> assocLocalUser [

	^ store deepAt: #('USER' 'USERNAME') ifPresent: [ :v :k :t | t -> v copyReplaceAll: '-' with: '_' ]
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

	aTieredDict valueWriter: self class makeValueWriter.
	store := aTieredDict
]
