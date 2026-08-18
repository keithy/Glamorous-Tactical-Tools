Extension { #name : 'TTFixUpOSEnvironment' }

{ #category : '*Tactical-Project' }
TTFixUpOSEnvironment class >> fixUpProject [
	
	<ttOSEnvironment>
	
	OSEnvironment current in: [ :env |
	
		env at: #PROJECT_ID ifAbsentPut: [ 'Xanadu' ].
		env at: #PROJECT_DIR ifAbsentPut: [ (#file: // #code / 'xanadu') fullName ].
	 
	]
]
