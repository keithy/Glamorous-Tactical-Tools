Extension { #name : 'ImageStoreResolver' }

{ #category : '*Tactical-Fixes' }
ImageStoreResolver >> supportedOriginsDo: aBlock [

		ImageStore withAllSubclassesDo: [ :c | 
	
				(Pragma allNamed: #origin in: c class) do: [:pragma | 
		
				"class pragma"
				aBlock value: c value: pragma methodSelector ]
  	].


]
