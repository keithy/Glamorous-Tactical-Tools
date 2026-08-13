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

{ #category : 'accessing' }
TTFactoryAbstract >> make: aClassName andConfigure: configureBlock [

	^ configureBlock value: 
		((aClassName asSymbol asClassIfAbsent: [ ^ nil ])
				basicNewForFactory: self ifFail: [ ^nil ]) initialize
				
	
	 
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
