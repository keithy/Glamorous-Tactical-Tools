Extension { #name : 'PlatformResolver' }

{ #category : '*Tactical-Project' }
PlatformResolver >> project [
   <origin>
	^ self resolveString: Hub projectDir
]
