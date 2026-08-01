Extension { #name : 'SystemResolver' }

{ #category : '*Tactical-Tools' }
SystemResolver >> ramdisk [
	
	<ttFix>
	<origin>
	
	^ MemoryStore currentFileSystem root
]

{ #category : '*Tactical-Tools' }
SystemResolver >> vmBinary [
	<origin>
	^ self resolveString: Smalltalk vm fullPath
]
