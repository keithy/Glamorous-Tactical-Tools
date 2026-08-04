Extension { #name : 'PlatformResolver' }

{ #category : '*Tactical-Fixes' }
PlatformResolver >> preferences [

	^ self subclassResponsibility
]

{ #category : '*Tactical-Fixes' }
PlatformResolver >> temp [
	"Where to put files that are not supposed to last long"

	^ self subclassResponsibility
]
