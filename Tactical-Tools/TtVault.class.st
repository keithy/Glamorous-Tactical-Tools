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
TTVault class >> bundleId [
  "use default"
^ TheHub osEnvironment at: '__CFBundleIdentifier' ifAbsent: 'gtoolkit' 
]

{ #category : 'instance creation' }
TTVault class >> currentVault [

^ currentVault ifNil: [ currentVault := self newWithLocalMiseConfigOSEnv ]
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
	 
	
	| files store gt_id |
	
	store  := self makeStoreLocalOSEnv.
	
	gt_id := store deepAt: #GT_ID ifAbsentPut: [ self bundleId].
		
	"Subclassing TheGlamorousHub gives you a different env file"
	files := self searchPathName: (TheHub current hubId) project: gt_id.

	files reverseDo: [ :assoc |
 
 		| file |
 		
 		file := assoc value.
 		FileLookedForNotification signal: file fullName.
 		
 		file exists ifTrue: [
			
			    (store tierKeys includes: (assoc key)) ifFalse: [
			    
						TTDictionaryDotEnv new 
							tierKey: assoc key;
							tierInsertIn: store after: #cache;
							readSource: file;
				 		 yourself.
		 ]]
	].
							
	^ store
]

{ #category : 'instance creation' }
TTVault class >> makeStoreLocalMiseConfigOSEnv [
	
	"our test show it all"
	
	<gtExample>
	 
	
	| store project |
	
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
TTVault class >> newWithLocalMiseConfigOSEnv [

 <gtExample>

 ^ self basicNew
		store: self makeStoreLocalMiseConfigOSEnv
		yourself
		
]

{ #category : 'instance creation' }
TTVault class >> searchPath [
 	
  <gtExample>
 	
	^ self searchPathName: self vaultId project: self bundleId.
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
TTVault class >> showMeTheSearchPath [
	
	<gtExample>
	
	^ self showMeTheSearchPathDuring: [ self newWithLocalMiseConfigOSEnv ]


	

]

{ #category : 'instance creation' }
TTVault class >> showMeTheSearchPathDuring: aBlock [

	| places |
	
	places := OrderedCollection new.
	
	aBlock on: FileLookedForNotification do: [ :ex | places add: ex messageText. ex pass ].

	^ places
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

	store deepAssociationAt: keys ifPresent: [ :a | ^ a ].

	keys := app , '_' , field.
	
	store deepAssociationAt: keys ifPresent: [ :a  | ^ a  ].

	^ aBlock value
	
]

{ #category : 'as yet unclassified' }
TTVault >> assocLocalUser [

	^ store deepAt: #('USER' 'USERNAME') ifPresent: [ :v :k :t | t -> v copyReplaceAll: '-' with: '_' ]
]

{ #category : 'instance creation' }
TTVault >> gtItemsFor: aView [
	<gtView>
	
	^ aView forward
		title: 'Items';
		priority: 10;
		object: [ store ];
		view: #gtItemsFor:
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
