Class {
	#name : 'TTOneJobManySuppliers',
	#superclass : 'TTApiClient',
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'accessing' }
TTOneJobManySuppliers class >> checkNewVault: appConfig [

	 ^ appConfig at: #url ifPresent: [ :url | url = self class urlHost ] ifAbsent: [ false ].
	  
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
