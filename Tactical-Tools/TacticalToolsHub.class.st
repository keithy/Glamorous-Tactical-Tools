Class {
	#name : 'TacticalToolsHub',
	#superclass : 'Object',
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'as yet unclassified' }
TacticalToolsHub class >> healthCheckExamples [

	"Tactical-Tools health check methods <ttHealthCheck>"
	
	<ttSpoke>
	
	^ #ttHealthCheck gtPragmas in: [ :p | p gtExamples runAll. p ]
	
]

{ #category : 'as yet unclassified' }
TacticalToolsHub class >> pragmasAll_ttShutDownStartUp [

	"Tactical-Tools <ttShutDown>/<ttStartUp>"
	
	<ttSpoke>
	
	^ TTStartUpShutDown pragmasAll_ttShutDown, (TTStartUpShutDown pragmasAll_ttStartUp)
	  
	
]

{ #category : 'as yet unclassified' }
TacticalToolsHub class >> pragmasAll_ttUtility [

	"Tactical-Tools utility methods <ttUtility>"
	
	<ttSpoke>
	
	^ Pragma allNamed: #ttUtility
	
]

{ #category : 'as yet unclassified' }
TacticalToolsHub class >> pragmasAll_ttWall [

	"Tactical-Tools wall methods <ttWall>"
	
	<ttSpoke>
	
	^ Pragma allNamed: #ttWall
	

]

{ #category : 'as yet unclassified' }
TacticalToolsHub class >> pragmasAll_ttWhoAmI [

	"Tactical-Tools identity providers <ttWhoAmI>"
	
	<ttSpoke>
	
	^ Pragma allNamed: #ttWhoAmI
	

]

{ #category : 'as yet unclassified' }
TacticalToolsHub class >> shutDownStartUpTTDryRun [

	"Tactical Tools shutDown/startUp methods - Dry Run"
	
	"The idea is to sanity test shutDown methods without the risk of breaking the image"
		
	<ttSpoke>
	
	^ (TTStartUpShutDown shutDownDryRun),(TTStartUpShutDown startUpDryRun)
]

{ #category : 'as yet unclassified' }
TacticalToolsHub class >> theVault [

	"Vicarious Vault"
	
	<ttSpoke>
	
	^ TTVault currentVault
]

{ #category : 'as yet unclassified' }
TacticalToolsHub class >> theVaultSearchPath [

	"Vicarious Vault - Search Path"
	
	<ttSpoke>
	
	^ TheHub collectNotificationsOfClass: FileLookedForNotification during: [ TTVault newWithLocalMiseConfigOSEnv ]
]
