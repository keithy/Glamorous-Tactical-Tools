Extension { #name : 'FileSystemResolver' }

{ #category : '*Tactical-Fixes' }
FileSystemResolver >> supportedOriginsDo: aBlock [
	^ (Pragma allNamed: #origin from: self class  to: FileSystemResolver) do: [:pragma | 
		
		"class classMethodSelector {pathname}"
		aBlock value: self value: pragma methodSelector
	
	]
]
