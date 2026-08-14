Class {
	#name : 'TacticalToolsHub',
	#superclass : 'TTBareHub',
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'as yet unclassified' }
TacticalToolsHub class >> currentVault [

	"Vicarious Vault (current)"
	
	<ttSpoke>
	
	^ TheHub currentVault
]

{ #category : 'as yet unclassified' }
TacticalToolsHub class >> healthCheckExamples [

	"Tactical-Tools health check methods <ttHealthCheck>"
	
	<ttSpoke>
	
	^ #ttHealthCheck gtPragmas in: [ :p | p gtExamples runAll. p ]
	
]

{ #category : 'as yet unclassified' }
TacticalToolsHub class >> llmChatRegistry [ 

	"LLM Chats"
	
  <ttSpoke>

	^ GtLChatRegistry current
]

{ #category : 'as yet unclassified' }
TacticalToolsHub class >> llmConnectionRegistry [ 

	"LLM Connections"
	
  <ttSpoke>

	^ GtLConnectionRegistry uniqueInstance updateConnections
]

{ #category : 'as yet unclassified' }
TacticalToolsHub class >> newGtChatWithProvider: aProviderOrNil [
	| chat |
	chat := GtLChat new.
	chat withDefaultSummarizers.
	aProviderOrNil ifNotNil: [ chat provider: aProviderOrNil ].
	chat
		tools: GtLTools gt;
		markdownResponse;
		pageObjectExplanation: (self ttPageExplanation: 'Tactical LLM Instructions');
		gtPageExplanation: 'Rules for Moldable Development for Glamorous Toolkit';
		gtPageExplanation: 'Examples by example'.	";
		gtPageExplanation: 'Inspector phlow views by example'"
	^ GtLChatRegistry current  registerChat: chat
]

{ #category : 'as yet unclassified' }
TacticalToolsHub class >> newTTChat [ 

	"Let Us Chat"
	
  <ttSpoke>

	^ self newGtChatWithProvider: nil
	 
]

{ #category : 'as yet unclassified' }
TacticalToolsHub class >> pragmasAll_ttClient [

	"Tactical-Tools client providers <ttClient>"
	
	<ttSpoke>
	
	^ (Pragma allNamed: #ttClient),(Pragma allNamed: #ttApiClient)
	

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
	
	"The idea is to sanity test startUp/shutDown methods without the risk of breaking the image"
		
	<ttSpoke>
	
	^ (TTStartUpShutDown shutDownDryRun),(TTStartUpShutDown startUpDryRun)
]

{ #category : 'as yet unclassified' }
TacticalToolsHub class >> theFactory [

	"Fabulous Factory"
	
	<ttSpoke>
	
	^ TTFactory new
]

{ #category : 'as yet unclassified' }
TacticalToolsHub class >> theVaultSearchPath [

	"Vicarious Vault - Search Path"
	
	<ttSpoke>
	
	^ (FileLookedForNotification collectDuring: [ TTVault newWithRWConfigOSEnv ])  
]

{ #category : 'as yet unclassified' }
TacticalToolsHub class >> ttLeDatabase [
	
	"Lepiter - Tactical Tools "
	
	<ttSpoke>
	
	^ LeDatabase databaseNamed: 'keithy/Glamorous-Tactical-Tools/lepiter'
]

{ #category : 'as yet unclassified' }
TacticalToolsHub class >> ttLlmInstructions [
	
	"Lepiter - LLM Instructions "
	
	<ttSpoke>
	
	^ self ttLeDatabase pageNamed: 'Tactical LLM Instructions'
]

{ #category : 'as yet unclassified' }
TacticalToolsHub class >> ttPageExplanation: aPageName [ 
	^ self ttLeDatabase pageNamed: aPageName
]
