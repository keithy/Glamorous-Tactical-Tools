Class {
	#name : 'TTFixUpOSEnvironment',
	#superclass : 'Object',
	#category : 'Tactical-Pharo-StartUp-ShutDown',
	#package : 'Tactical-Pharo',
	#tag : 'StartUp-ShutDown'
}

{ #category : 'as yet unclassified' }
TTFixUpOSEnvironment class >> fixUpCode [
	
	<ttOSEnvironment>
	
	Transcript crShow: (thisContext method printString).
	
	
	OSEnvironment current in: [ :env |
	
		env at: #CODE_DIR ifAbsentPut: [ '..' ].

	]
]

{ #category : 'as yet unclassified' }
TTFixUpOSEnvironment class >> fixUpProject [
	
	<ttOSEnvironment>
	
	OSEnvironment current in: [ :env |
	
		env at: #projectId ifAbsentPut: [ 'Xanadu' ].
		env at: #projectDir ifAbsentPut: [ (File // #code / 'xanadu') fullName ].
		env at: #projectName ifAbsentPut: [ 'Xanadu'  ]
 
	]
]

{ #category : 'as yet unclassified' }
TTFixUpOSEnvironment class >> fixUpWhoAmI [
	
	<ttOSEnvironment>
	
	"Since we are more likely to be passing on an environment to
	 other tools, fixing it up makes sense"
	
	OSEnvironment current in: [ :env |
	
		"May there always be a #USER - (windows)"
		env at: #USER ifAbsentPut: [ env at: #USERNAME ifAbsent: 'Nemo' ].
		env at: #userId ifAbsentPut: [ (env at: #USER) capitalized ].
		env at: #platformId ifAbsentPut: [  OSPlatform current family  ]
	]
]

{ #category : 'as yet unclassified' }
TTFixUpOSEnvironment class >> startUpAtSystemPriority: isImageStarting [
	<ttStartUp>
	(Hub pragmasClassSideNamed: #ttOSEnvironment in: self)
		do: [ :pragma | pragma method valueWithReceiver: self arguments: #() ]
]
