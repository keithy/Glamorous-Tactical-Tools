Extension { #name : 'File' }

{ #category : '*Tactical-Tools' }
File class >> // it [ 

^ Hub fileReferenceFrom: it
]

{ #category : '*Tactical-Tools' }
File >> basename [
	^self name
]
