Class {
	#name : 'TTFactoryAbstract',
	#superclass : 'Object',
	#instVars : [
		'vault'
	],
	#category : 'Tactical-Tools-Clients',
	#package : 'Tactical-Tools',
	#tag : 'Clients'
}

{ #category : 'as yet unclassified' }
TTFactoryAbstract class >> factoryId [

	^ ((self name withoutPrefix: 'TT') withoutSuffix: 'Factory') asLowercase
]

{ #category : 'as yet unclassified' }
TTFactoryAbstract class >> isAbstract [

	^ self == TTFactoryAbstract
]

{ #category : 'as yet unclassified' }
TTFactoryAbstract class >> makeVaultCurrent [

	^ TTVault currentVault
]

{ #category : 'as yet unclassified' }
TTFactoryAbstract class >> makeVaultEmpty [

	^ TTVault newEmpty
]

{ #category : 'as yet unclassified' }
TTFactoryAbstract class >> new [

	^ (self basicNew)
			setVault: self makeVaultCurrent;
			initialize
]

{ #category : 'as yet unclassified' }
TTFactoryAbstract class >> pragmasAll_ttClient [

	<ttSpoke>
	
	"All of the clients... in the world"
	
	^ TheHub sortByComment: (Pragma allNamed: #ttClient)
	
]

{ #category : 'accessing' }
TTFactoryAbstract >> gtClientsFor: aView [
	<gtView>
	^ aView columnedList
		priority: 10;
		title: 'Clients Pragmas'
		items: [ self pragmas_ttClient ];
		column: 'Env'
			text: #entEnvironmentName
			width: 80;
		column: 'Name'
			text: #name
			width: 130;
		column: 'Alive?'
			stencil: (aView
					gtSoon: [ :ea | ea isAliveMessage ]
					ifPending: '??'
					ifError: nil)
			width: 150;
		column: 'Version'
			stencil: (aView
					gtSoon: [ :ea | ea serverVersion ifNil: '' ]
					ifPending: '??'
					ifError: '-')
			width: 100;
		column: 'Target' text: #gtDisplayTarget;
		contextItemLabel: 'Questions'
			action: [ :anElement :ea | anElement phlow spawnObject: (EntEnvironments with: (Array with: ea)) ];
		send: #value
]

{ #category : 'accessing' }
TTFactoryAbstract >> make: aClassName andConfigure: configureBlock [

	| aNewClass aNewInstance factoryConfiguredInstance |
	
	aNewClass := aClassName asSymbol asClassIfAbsent: [ ^ nil ].
	
	aNewInstance := (aNewClass basicNewForFactory: self ifFail: [ ^ nil ]) ifNil: [ ^ nil ].
	
	factoryConfiguredInstance := (configureBlock value: aNewInstance) ifNil: [ ^ nil ].
	
	^ factoryConfiguredInstance initialize
																		
																						 
				
	
	 
]

{ #category : 'accessing' }
TTFactoryAbstract >> setVault: anObject [
	
	"set implies that it is essential prior to #initialize"
	
	vault := anObject
]

{ #category : 'accessing' }
TTFactoryAbstract >> vault [
	^ vault
]
