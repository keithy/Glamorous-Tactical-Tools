Class {
	#name : 'TTApiClientAbstract',
	#superclass : 'TTClientAbstract',
	#category : 'Tactical-Tools-Clients',
	#package : 'Tactical-Tools',
	#tag : 'Clients'
}

{ #category : 'as yet unclassified' }
TTApiClientAbstract class >> basicNewForFactory: aFactory ifFail: failBlock [

	(self vaultHasWhatINeed: (aFactory vault)) ifFalse: [ ^ failBlock value ].
	
	"set things that are needed prior to initialization"
	^ (self basicNew)
					setVault: aFactory vault;
					yourself
]

{ #category : 'as yet unclassified' }
TTApiClientAbstract class >> vaultHasWhatINeed: aFactoryVault [

	^ aFactoryVault lookupHasFields: #(url)
]
