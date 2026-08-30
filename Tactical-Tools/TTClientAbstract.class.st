Class {
	#name : 'TTClientAbstract',
	#superclass : 'Object',
	#instVars : [
		'vault',
		'result',
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
	
 	"Will create instance  even if configuration is incomplete"
 	^ (self basicNew)
					setVault:  aVaultable getVault;
					yourself


]

{ #category : 'factory' }
TTClientAbstract class >> basicNewForPotential: aVaultable [
	
		"Will create instance requiring complete confiuration or return nil"

 	^ self basicNewFor:  ((self configureAndValidateVault: aVaultable option: #default) ifNil: [ ^ nil ])
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
TTClientAbstract class >> classTool [

	^ self
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

{ #category : 'factory' }
TTClientAbstract class >> configureAndValidateVault: aVaultable option: anOptionKey [
	| myVault |
	(self checkPotentialVault: aVaultable) ifFalse: [ ^ nil ].

	myVault := self configureVault: aVaultable option: anOptionKey.
			
	(self checkNewVault: anOptionKey) ifFalse: [ ^ nil ].

	^ myVault
]

{ #category : 'instance creation' }
TTClientAbstract class >> configureResult: aResult [

	^ aResult apply: TTToolOutputParser passAsString.

]

{ #category : 'factory' }
TTClientAbstract class >> configureVault: aVaultable option: anOptionKey [
	
	^ aVaultable getVault
			copyForAppKey: self vaultAppKey
			optionKey: #default.
	
]

{ #category : 'as yet unclassified' }
TTClientAbstract class >> fileReferenceFrom: aHub [

	^ self workingDirectory
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
TTClientAbstract class >> makeNewVaultsForAllOptionsOf: aVaultable [
	| theOptions |
	(self checkPotentialVault: aVaultable) ifFalse: [ ^ nil ].

	theOptions := self collectAllTheOptionKeysAsASetFor: aVaultable.

	^ theOptions
		collect: [ :optionKey | 
			| newVault |
			newVault := aVaultable copyForAppKey: self vaultAppKey optionKey: optionKey.

			(self checkNewVault: newVault) ifFalse: [ nil ] ]
]

{ #category : 'instance creation' }
TTClientAbstract class >> makeRequestForClient: aClient [

	^ (#class://#'ˆToolRequest') newForClient: aClient

]

{ #category : 'instance creation' }
TTClientAbstract class >> makeResultForRequest: request [
	
	"Each result-request pair represents a query round trip"
	
	"Each result-request pair keeps a reference to the client,
	so that it can make further api calls of its own"

	^ TTResult newForRequest: request
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
	^ (self basicNewFor: (self configureVault: aVaultable option: #default))
		initialize
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
							collect: [ :ea | (ea configureAndValidateVault: aVaultable option: #default) -> ea ]
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

{ #category : 'as yet unclassified' }
TTClientAbstract >> gtRawFor: aView [
	<gtView>
	^ self ttTheme viewRawOn: self for: aView
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
	^ result := self class makeRequestForClient: self
]

{ #category : 'instance creation' }
TTClientAbstract >> makeResultForRequest: request [
	"initially the request doubles as the result 
	 this is the thin client configuration"
	 
	"The client keeps the last result context as convenience for the user."
	 
	^ result := self class makeResultForRequest: request
]

{ #category : 'factory' }
TTClientAbstract >> prepareRequest: aRequest [

	^ self 
]

{ #category : 'accessing' }
TTClientAbstract >> requestErrorHandler [
	^ nil
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
 
	aVault appKey ifNil: [ self error: 'Vault should be a configured copy' ].
	
	vault := aVault
]

{ #category : 'as yet unclassified' }
TTClientAbstract >> with: aSymbolUrlStringOrClass [
	^ (self basicNewFor: Hub) // aSymbolUrlStringOrClass
]
