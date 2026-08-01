Extension { #name : 'SystemResolver' }

{ #category : '*Tactical-Tools' }
SystemResolver >> ramdisk [
	
	<origin>
	
	^ TheHub ramdiskFileSystem workingDirectory 
]

{ #category : '*Tactical-Tools' }
SystemResolver >> vmBinary [
	<origin>
	^ self resolveString: Smalltalk vm fullPath
]
