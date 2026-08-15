Class {
	#name : 'TTStartUpShutDown',
	#superclass : 'Object',
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'environment' }
TTStartUpShutDown class >> initialize [
	
	TheHub sessionManager
		registerSystemClassNamed: self name
		atPriority: 50.
	
	self startUp: true.
]

{ #category : 'spokes' }
TTStartUpShutDown class >> mustBeClassSide: pragma [
	
	^ pragma method isClassSide ifFalse: [
			Warning signal: pragma displayString , 'Needs to be set Class Side'.
			false.
		] ifTrue: [ true ]
			
]

{ #category : 'spokes' }
TTStartUpShutDown class >> pragmasAll_ttShutDown [

	"Tactical-Tools startUp methods <ttShutDown>"
	
	"<ttSpoke>"
	
	^ Pragma allNamed: #ttShutDown
]

{ #category : 'spokes' }
TTStartUpShutDown class >> pragmasAll_ttStartUp [

	"Tactical-Tools startUp methods <ttStartUp>"
	
	"<ttSpoke>"
	
	^ Pragma allNamed: #ttStartUp
]

{ #category : 'environment' }
TTStartUpShutDown class >> shutDown: quitting [

	 self pragmasAll_ttShutDown
			do: [ :pragma | 
			
				(self mustBeClassSide: pragma) ifTrue:[ 
				
						(pragma method selector = 'shutDown:') ifFalse: [ self error ].
						
						TTStartUpNotification signal:pragma displayString withTag: pragma method.
						pragma method methodClass soleInstance 
							perform: pragma method selector 
							with: quitting
							
						] 
				].
				

		
]

{ #category : 'environment' }
TTStartUpShutDown class >> shutDownDryRun [

	"Sanity test startUp methods without the risk of breaking the image"
	
	^ TTStartUpNotification collectDuring: [ 
		
		   self shutDown: true
		]



]

{ #category : 'environment' }
TTStartUpShutDown class >> startUp: isImageStarting [

	^ self pragmasAll_ttStartUp
			do: [ :pragma | 
			
				(self mustBeClassSide: pragma) ifTrue:[ 
				
				
						(pragma method selector = 'startUp:') ifFalse: [ self error ].

						TTStartUpNotification signal:pragma displayString withTag: pragma method.
						pragma method methodClass soleInstance 
							perform: pragma method selector 
							with: isImageStarting
							
						] 
				].
		
]

{ #category : 'environment' }
TTStartUpShutDown class >> startUpDryRun [

	"Sanity test startUp methods without the risk of breaking the image"
	
	^ TTStartUpNotification collectDuring: [ 
		 
		 self startUp: true
		 
	  ]



]
