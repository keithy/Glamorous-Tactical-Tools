Class {
	#name : 'TTFixUpOSEnvironment',
	#superclass : 'Object',
	#category : 'Tactical-Pharo-StartUp/ShutDown',
	#package : 'Tactical-Pharo',
	#tag : 'StartUp/ShutDown'
}

{ #category : 'as yet unclassified' }
TTFixUpOSEnvironment >> fixUp [

	<ttStartUp>
	
	OSEnvironment current in: [ :env |
	
		"May there always be a #USER"
		env at: #USER ifAbsentPut: [ env at: #USERNAME ifAbsent: 'Nemo' ].
		env at: #ttPLATFORM ifAbsentPut: [  OSPlatform current family  ]
	
	]
	
]

{ #category : 'as yet unclassified' }
TTFixUpOSEnvironment >> startUpAtSystemPriority: isImageStarting [

	<ttStartUp>
	
	self fixUp
	
]
