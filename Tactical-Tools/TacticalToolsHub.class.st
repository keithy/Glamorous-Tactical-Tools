Class {
	#name : 'TacticalToolsHub',
	#superclass : 'Object',
	#category : 'Tactical-Tools-Demo',
	#package : 'Tactical-Tools',
	#tag : 'Demo'
}

{ #category : 'as yet unclassified' }
TacticalToolsHub class >> pragmasAll_ttStartUp [

	"Tactical-Tools startUp methods <ttStartUp>"
	
	<ttSpoke>
	
	^ TheHub pragmasAll_ttStartUp
	  
	
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
