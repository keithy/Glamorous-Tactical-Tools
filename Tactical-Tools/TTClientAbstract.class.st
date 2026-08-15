Class {
	#name : 'TTClientAbstract',
	#superclass : 'Object',
	#traits : 'T2Namespace',
	#classTraits : 'T2Namespace classTrait',
	#instVars : [
		'vault',
		'result',
		'classTool',
		'requestErrorHandler'
	],
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'as yet unclassified' }
TTClientAbstract class >> asHub [
	
	"Any Client class can be a hub on its own resources"
	
  ^ TheHub current newBrowsing: self
]

{ #category : 'accessing' }
TTClientAbstract class >> basicNew [
   self isAbstract ifTrue: [ self error:(self name, ' is abstract') ].
 ^ super basicNew
]

{ #category : 'factory' }
TTClientAbstract class >> basicNewForVault: aVault ifFail: fBlock [
	
	"the failblock pattern allows subclasses to inherit the whole method
	 and build upon what we have here, rather than replace it"

	(self suitsVault: aVault) ifFalse: [ ^ fBlock value ].
	
	^ (self basicNew)
				setVault: ((aVault copy) 
											appKey: self vaultAppKey;
											optionsSelect: #default;
											refresh;
											yourself);
				yourself


]

{ #category : 'as yet unclassified' }
TTClientAbstract class >> clientId [

	^ ((self name withoutPrefix: 'TT') withoutSuffix: 'Client') asLowercase
]

{ #category : 'as yet unclassified' }
TTClientAbstract class >> findSuitableFor: aVaultable [
	
	"return first match"

	aVaultable askFor: #vault ifAbsent: [ ^ self error: 'Expected aFactory or aClient' ].
	
	self withAllSubclassesDo: [ :ea | (ea isSuitableFor: aVaultable) ifTrue: [ ^ ea ] ].
	
	^ nil
]

{ #category : 'accessing' }
TTClientAbstract class >> isAbstract [

	^ self == TTClientAbstract
]

{ #category : 'as yet unclassified' }
TTClientAbstract class >> isSuitableFor: aFactoryOrClient [

	^ false
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

{ #category : 'as yet unclassified' }
TTClientAbstract class >> makeVaultEmpty [

^ TTVault newEmpty
]

{ #category : 'accessing' }
TTClientAbstract class >> suitsVault: aVault [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
TTClientAbstract class >> vaultAppKey [

	^ self clientId
]

{ #category : 'as yet unclassified' }
TTClientAbstract >> getUser [

^ vault user
]

{ #category : 'accessing' }
TTClientAbstract >> gtOptionsFor: aView [
	<gtView>
	^ aView forward
		title: 'Vault Options';
		priority: 5;
		object: [ self vault ];
		view: #gtOptionsFor:
]

{ #category : 'accessing' }
TTClientAbstract >> gtVaultViewFor: aView [
	<gtView>
	^ aView forward
		title: 'Vault Config';
		priority: 10;
		object: [ self vault ];
		view: #gtConfigFor:
]

{ #category : 'factory' }
TTClientAbstract >> initializeForFactory: aFactory ifFail: fBlock [

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

{ #category : 'initialization' }
TTClientAbstract >> setRequestErrorHandler: errorHandler [

	requestErrorHandler := errorHandler
]

{ #category : 'initialization' }
TTClientAbstract >> setVault: aVault [
	vault := aVault  
]

{ #category : 'accessing' }
TTClientAbstract >> vault [
	^ vault ifNil: [ vault := self class makeVaultEmpty ]
]
