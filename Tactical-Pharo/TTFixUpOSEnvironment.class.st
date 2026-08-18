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
	
		env at: #PROJECT_ID ifAbsentPut: [ 'Xanadu' ].
		env at: #PROJECT_DIR ifAbsentPut: [ (File // #code / 'xanadu') fullName ].
		env at: #PROJECT_NAME ifAbsentPut: [ 'Xanadu'  ]
 
	]
]

{ #category : 'as yet unclassified' }
TTFixUpOSEnvironment class >> fixUpWhoAmI [
	
	<ttOSEnvironment>
	
	"Fixing it up makes sense to pass no to other tools"
	
	OSEnvironment current in: [ :env |
	
		"May there always be a #USER - (windows)"
		env at: #USER ifAbsentPut: [ env at: #USERNAME ifAbsent: 'Nemo' ].
		env at: #NICKNAME ifAbsentPut: [ (env at: #USER) capitalized ].
		env at: #PLATFORM_ID ifAbsentPut: [  OSPlatform current family  ]
	]
]

{ #category : 'as yet unclassified' }
TTFixUpOSEnvironment class >> startUpAtSystemPriority: isImageStarting [
	<ttStartUp>
	(Hub pragmasClassSideNamed: #ttOSEnvironment in: self)
		do: [ :pragma | pragma method valueWithReceiver: self arguments: #() ]
]
