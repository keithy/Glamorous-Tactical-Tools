Extension { #name : 'SystemResolver' }

{ #category : '*Tactical-Tools' }
SystemResolver >> ramdisk [
	
	<ttPharoFix:'useful as origin'>
	<origin>
	
	^ MemoryStore currentFileSystem root
]

{ #category : '*Tactical-Tools' }
SystemResolver >> vmBinary [
	<origin>
	^ self resolveString: Smalltalk vm fullPath
]
