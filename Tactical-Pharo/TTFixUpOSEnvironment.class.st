Class {
	#name : 'TTFixUpOSEnvironment',
	#superclass : 'Object',
	#category : 'Tactical-Pharo-StartUp-ShutDown',
	#package : 'Tactical-Pharo',
	#tag : 'StartUp-ShutDown'
}

{ #category : 'as yet unclassified' }
TTFixUpOSEnvironment class >> fixUp [
	
	<ttOSEnvironment>
	
	"Since we are more likely to be passing on an environment to
	 other tools, fixing it up makes sense"
	
	OSEnvironment current in: [ :env |
	
		"May there always be a #USER - (windows)"
		env at: #USER ifAbsentPut: [ env at: #USERNAME ifAbsent: 'Nemo' ].
		env at: #NICKNAME ifAbsentPut: [ (env at: #USER) capitalized ].
		env at: #PLATFORM ifAbsentPut: [  OSPlatform current family  ]
 
	]
]

{ #category : 'as yet unclassified' }
TTFixUpOSEnvironment class >> startUpAtSystemPriority: isImageStarting [
	<ttStartUp>
	(Hub pragmasClassSideNamed: #ttOSEnvironment in: self)
		do: [ :pragma | pragma method valueWithReceiver: self arguments: #() ]
]
