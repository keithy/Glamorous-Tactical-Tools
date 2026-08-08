Class {
	#name : 'TacticalToolsHub',
	#superclass : 'Object',
	#category : 'Tactical-Tools-Demo',
	#package : 'Tactical-Tools',
	#tag : 'Demo'
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
	
	^ TheHub pragmasAll_ttShutDown, (TheHub pragmasAll_ttStartUp)
	  
	
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
	
	^ (TheHub shutDownTTDryRun),(TheHub startUpTTDryRun)
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
