Extension { #name : 'PlatformResolver' }

{ #category : '*Tactical-Project' }
PlatformResolver >> project [

	^ self resolveString: Hub projectDir
]
