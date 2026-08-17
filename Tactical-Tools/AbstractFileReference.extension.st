Extension { #name : 'AbstractFileReference' }

{ #category : '*Tactical-Tools' }
AbstractFileReference >> // aThing [
	 
	 ^ Hub current startDoubleSlashFromAFileReference: self with: aThing
]
