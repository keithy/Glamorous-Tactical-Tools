Class {
	#name : 'TTFixUpOSEnvironment',
	#superclass : 'Object',
	#category : 'Tactical-Pharo-StartUp/ShutDown',
	#package : 'Tactical-Pharo',
	#tag : 'StartUp/ShutDown'
}

{ #category : 'as yet unclassified' }
TTFixUpOSEnvironment >> startUp: isImageStarting [

	<ttStartUp>
	
	OSEnvironment current in: [ :env |
	
		"May there always be a #USER"
		env at: #USER ifAbsent: [ env at: #USER put: (env at: #USERNAME ifAbsentPut: 'Nemo')  ]
	
	]
	
]
