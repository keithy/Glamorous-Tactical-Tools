Class {
	#name : 'TTClientAbstract',
	#superclass : 'Object',
	#traits : 'T2Namespace',
	#classTraits : 'T2Namespace classTrait',
	#instVars : [
		'vault',
		'result',
		'classTool',
		'requestErrorHandler',
		'workingDirectory'
	],
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'as yet unclassified' }
TTClientAbstract class >> // aClassNameOrClass [

"Simplifies To: 
(self basicNewFor: Hub current) initialize // aSymbolUrlStringOrClass
"

^ Hub current startDoubleSlashFromClientClass: self with: aClassNameOrClass
]

{ #category : 'as yet unclassified' }
TTClientAbstract class >> asHub [
	
	"Any Client class can be a hub on its own resources"
	
  ^ Hub current newBrowsing: self
]

{ #category : 'accessing' }
TTClientAbstract class >> basicNew [
   self isAbstract ifTrue: [ self error:(self name, ' is abstract') ].
 ^ super basicNew
]

{ #category : 'factory' }
TTClientAbstract class >> basicNewFor: aVaultable [
	
 	^ (self basicNew)
					setVault:  aVaultable getVault
					yourself


]

{ #category : 'factory' }
TTClientAbstract class >> basicNewForPotential: aVaultable [
	
 	^ self basicNewFor:  ((self makeNewVaultFor: aVaultable) ifNil: [ ^ nil ])
					yourself


]

{ #category : 'factory' }
TTClientAbstract class >> checkNewVault: aVaultable [ 

	^ self subclassResponsibility
]

{ #category : 'accessing' }
TTClientAbstract class >> checkPotentialVault: aVault [

	^ self subclassResponsibility
]

{ #category : 'factory' }
TTClientAbstract class >> checkVault: aVaultable [  
	
	"the failblock pattern allows subclasses to inherit the whole method
	 and build upon what we have here, rather than replace it"

	| myVault |
	
	 (self checkPotentialVault: aVaultable ) ifFalse: [ ^ nil ].
	
	 myVault := (aVaultable getVault copy) 
									appKey: self vaultAppKey;
									optionsSelect: #default;
									refresh;
									yourself.
								
   (self checkMyNewVault: aVaultable ) ifFalse: [  ^ nil ].
				
 	^ myVault


]

{ #category : 'as yet unclassified' }
TTClientAbstract class >> clientId [

	^ ((self name withoutPrefix: 'TT') withoutSuffix: 'Client') asLowercase
]

{ #category : 'as yet unclassified' }
TTClientAbstract class >> collectAllTheOptionKeysAsASetFor: aVaultable [

	^ (aVaultable 
		appKey: self vaultAppKey
		refresh) options keys

]

{ #category : 'as yet unclassified' }
TTClientAbstract class >> doubleDispatchFromAFileReference: aFileReference andCH: hub [

	^ (self basicNewFor: hub) 
	        "doubleDispatchFrom: hub andAFileReference: aFileReference (possible0"
					setFileReference: aFileReference;
					initialize
]

{ #category : 'as yet unclassified' }
TTClientAbstract class >> doubleDispatchFromFileClass: fileClass [
	
	^ self workingDirectory
]

{ #category : 'as yet unclassified' }
TTClientAbstract class >> doubleDispatchWithCH: hub to: aSymbolUrlStringOrClass [
   
	^ (self basicNewFor: hub) initialize // aSymbolUrlStringOrClass
]

{ #category : 'as yet unclassified' }
TTClientAbstract class >> doubleSlashFromFactoryClass: aFactory andCH: hub [

	^ aFactory new askAll: self


]

{ #category : 'as yet unclassified' }
TTClientAbstract class >> fileReferenceFrom: aHub [

	^ self workingDirectory
]

{ #category : 'as yet unclassified' }
TTClientAbstract class >> fromClassClass: theClass [

	"double dispatch from //"
	^ self new
]

{ #category : 'accessing' }
TTClientAbstract class >> isAbstract [

	^ self == TTClientAbstract
]

{ #category : 'accessing' }
TTClientAbstract class >> makeBasicResult [

	^ TTResult basicNew
]

{ #category : 'as yet unclassified' }
TTClientAbstract class >> makeBasicResultForClient: aClient [

  ^ (self makeBasicResult) 
  			basicSetupForClient: aClient
  			yourself
]

{ #category : 'as yet unclassified' }
TTClientAbstract class >> makeBasicResultForModel: aClient [

  ^ (self makeBasicResult) 
  			basicSetupForModel: aClient
  			yourself
]

{ #category : 'as yet unclassified' }
TTClientAbstract class >> makeBasicResultForResult: aClient [

  ^ (self makeBasicResult) 
  			basicSetupForResult: aClient
  			yourself
]

{ #category : 'factory' }
TTClientAbstract class >> makeNewVaultFor: aVaultable [  
	
	| myVault |
	
	 (self checkPotentialVault: aVaultable ) ifFalse: [ ^ nil ].
	
	 myVault := (aVaultable getVault copy) 
									appKey: self vaultAppKey;
									optionsSelect: #default;
									refresh;
									yourself.
								
   (self checkNewVault: myVault ) ifFalse: [  ^ nil ].
				
 	^ myVault


]

{ #category : 'factory' }
TTClientAbstract class >> makeNewVaultsForAllOptionsOf: aVaultable [  
	
	| theOptions |
	
	 (self checkPotentialVault: aVaultable ) ifFalse: [ ^ nil ].
	
	 theOptions := self collectAllTheOptionKeysAsASetFor:aVaultable.
	
	 ^ theOptions collect: [ :optionKey |
	
	 		| newVault |
	 		
	 		newVault := (aVaultable getVault copy) 
									appKey: self vaultAppKey;
									optionsSelect: optionKey;
									refresh;
									yourself.
								
   		(self checkNewVault: newVault ) ifFalse: [ nil ].
				
 	]


]

{ #category : 'as yet unclassified' }
TTClientAbstract class >> makeVaultEmpty [

^ TTVault newEmpty
]

{ #category : 'accessing' }
TTClientAbstract class >> vaultAppKey [

	^ self clientId
]

{ #category : 'as yet unclassified' }
TTClientAbstract class >> withAllSubclassesCollectSuccessfulVaultsFor: aVaultable [
	"return all items that succeeds making a vault"

	^ self withAllSubclasses
							collect: [ :ea | (ea makeNewVaultFor: aVaultable) -> ea ]
							thenSelect: #notNil
]

{ #category : 'as yet unclassified' }
TTClientAbstract class >> withAllSubclassesCollectSuccessfulVaultsForAllOptionsOf: aVaultable [
	"return all items that succeeds making a vault"

	^ (self withAllSubclasses
		flatCollect: [ :ea | 
		
					(ea makeNewVaultsForAllOptionsOf: aVaultable) 
															collect: [ :vault | vault -> ea ] ])
					
		select: #notNil
]

{ #category : 'as yet unclassified' }
TTClientAbstract class >> withAllSubclassesDetectSuccessfulMakeFor: aVaultable [ 

	"return the first item that succeeds in instanciation"
	
	self withAllSubclassesDo: [ :ea | 
	
			(ea basicNewForPotential: aVaultable ) ifNotNil: [ :success | ^ success ] 
	].
	
	^ nil

]

{ #category : 'as yet unclassified' }
TTClientAbstract class >> workingDirectory [ 

^ Hub fileReferenceFrom: ('./', self ttLocalName)
]

{ #category : 'initialization' }
TTClientAbstract >> @ option [
	
	vault @ option
]

{ #category : 'as yet unclassified' }
TTClientAbstract >> getUser [

^ vault user
]

{ #category : 'accessing' }
TTClientAbstract >> getVault [
	^ vault ifNil: [ vault := self class makeVaultEmpty ]
]

{ #category : 'accessing' }
TTClientAbstract >> gtOptionsFor: aView [
	<gtView>
	^ aView forward
		title: 'Vault Options';
		priority: 5;
		object: [ self getVault ];
		view: #gtOptionsFor:
]

{ #category : 'accessing' }
TTClientAbstract >> gtVaultViewFor: aView [
	<gtView>
	^ aView forward
		title: 'Vault Config';
		priority: 10;
		object: [ self getVault ];
		view: #gtConfigFor:
]

{ #category : 'factory' }
TTClientAbstract >> initializeFor: aVaultable [  

	^ self initialize


]

{ #category : 'factory' }
TTClientAbstract >> initializeFor: aVaultable ifFail: fBlock [

	^ self initialize


]

{ #category : 'factory' }
TTClientAbstract >> isAuthRequired [

	^ false
]

{ #category : 'accessing' }
TTClientAbstract >> makeBasicRequestFor: aResult [

	^ classTool ttClassApiRequest new
	
]

{ #category : 'factory' }
TTClientAbstract >> makeInitializeRequest: aRequest [

	aRequest isAuthRequired: self isAuthRequired  
]

{ #category : 'instance creation' }
TTClientAbstract >> newRequest [

	 ^ self newResult newRequest
]

{ #category : 'instance creation' }
TTClientAbstract >> newResult [

	"The client keeps the last result context as convenience for the user.
	This is multi-threaded unsafe etc.
	
	Each result-request pair represents an atomic query.
	
	Each result-request pair keeps a reference to the client, so that it is
	easy to make further api calls of its own"

	^ result := self class makeBasicResultForClient: self
]

{ #category : 'accessing' }
TTClientAbstract >> requestErrorHandler [

	^ requestErrorHandler ifNil: [ [ :err | err pass ] ]
]

{ #category : 'accessing' }
TTClientAbstract >> setClassTool: aClass [
	classTool := aClass
]

{ #category : 'as yet unclassified' }
TTClientAbstract >> setDirectory: aFR [
	workingDirectory := aFR
]

{ #category : 'as yet unclassified' }
TTClientAbstract >> setFile: aFR [ 

	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
TTClientAbstract >> setFileReference: aFR [
	aFR isDirectory ifTrue: [ ^ self setDirectory: aFR ].
	aFR isFile ifTrue: [ self setFile: aFR ].
	
	self setNewFileReference: aFR.
]

{ #category : 'as yet unclassified' }
TTClientAbstract >> setNewFileReference: aFR [ 
	self subclassResponsibility
]

{ #category : 'initialization' }
TTClientAbstract >> setRequestErrorHandler: errorHandler [

	requestErrorHandler := errorHandler
]

{ #category : 'initialization' }
TTClientAbstract >> setVault: aVault [
	vault := aVault  
]

{ #category : 'as yet unclassified' }
TTClientAbstract >> with: aSymbolUrlStringOrClass [
	^ (self basicNewFor: Hub) // aSymbolUrlStringOrClass
]
