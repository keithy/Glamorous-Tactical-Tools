Extension { #name : 'SystemResolver' }

{ #category : '*Tactical-Tools' }
SystemResolver >> code [
	<origin>
	^  self home / 'code'
]

{ #category : '*Tactical-Tools' }
SystemResolver >> project [

	^ Hub current projectDir
]

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
