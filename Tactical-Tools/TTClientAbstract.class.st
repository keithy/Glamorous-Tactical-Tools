Class {
	#name : 'TTClientAbstract',
	#superclass : 'Object',
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

{ #category : 'accessing' }
TTClientAbstract class >> classResult [

	^ TTResult 
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

{ #category : 'instance creation' }
TTClientAbstract class >> configureResult: aResult [

	^ aResult apply: TTToolOutputParser passAsString.

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

{ #category : 'namespace' }
TTClientAbstract class >> isNamespaced [
  <namespaced>
	<namespaced:'TT'> 
	^ true
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

{ #category : 'instance creation' }
TTClientAbstract class >> makeResultForRequest: request [
	"The client keeps the last result context as convenience for the user.
	This is multi-threaded unsafe etc.
	
	Each result-request pair represents an atomic query.
	
	Each result-request pair keeps a reference to the client, so that it is
	easy to make further api calls of its own"
	
	^ self configureResult: 
						(self classResult new
								setRequest: request;
								initialize)
]

{ #category : 'as yet unclassified' }
TTClientAbstract class >> makeVaultEmpty [

^ TTVault newEmpty
]

{ #category : 'accessing' }
TTClientAbstract class >> new [

	^ self newFor: Hub current
]

{ #category : 'factory' }
TTClientAbstract class >> newFor: aVaultable [
	
 	^ (self basicNewFor:aVaultable ) initialize
					 

]

{ #category : 'accessing' }
TTClientAbstract class >> newNoConfig [

	^ self newFor: (self makeVaultEmpty)
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

^ #file: //('./', ((#namespaced: // self) value))
]

{ #category : 'initialization' }
TTClientAbstract >> @ option [
	
	self getVault @ option
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
TTClientAbstract >> isAuthRequired [

	^ false
]

{ #category : 'instance creation' }
TTClientAbstract >> makeRequest [
	"initially the request doubles as the result 
	 this is the thin client configuration"
	 
	"The client keeps the last result context as convenience for the user."
	 
	^ result := classTool classApiRequest basicNew
			setClient: self;
			initialize
]

{ #category : 'factory' }
TTClientAbstract >> prepareRequest: aRequest [

	aRequest isAuthRequired: self isAuthRequired  
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
