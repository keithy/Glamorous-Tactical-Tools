Class {
	#name : 'TTOneJobManySuppliers',
	#superclass : 'TTApiClientAbstract',
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'accessing' }
TTOneJobManySuppliers class >> checkNewVault: appConfig [

	 ^ appConfig at: #url ifPresent: [ :url | url = self urlHostApi ] ifAbsent: [ false ].
	  
]

{ #category : 'as yet unclassified' }
TTOneJobManySuppliers class >> checkPotentialVault: aVaultable [

	^ aVaultable getVault lookupHasFields: #(url)
]

{ #category : 'accessing' }
TTOneJobManySuppliers class >> urlHostApi [

	"subclassResponsibility"

   ^ 'nemo://'
]
