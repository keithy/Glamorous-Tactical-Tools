Extension { #name : 'FileLocator' }

{ #category : '*Tactical-Tools' }
FileLocator class >> ramdisk [

	<origin>
	
	Transcript crShow: thisContext shortDebugStack
	.
	
	^ self origin: #ramdisk
]
