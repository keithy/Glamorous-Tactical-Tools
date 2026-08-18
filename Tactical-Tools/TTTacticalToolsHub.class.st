Class {
	#name : 'TTTacticalToolsHub',
	#superclass : 'TTEmptyHub',
	#traits : 'T2Namespace',
	#classTraits : 'T2Namespace classTrait',
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'as yet unclassified' }
TTTacticalToolsHub class >> currentVault [

	"Vicarious Vault (current)"
	
	<ttSpoke>
	
	^ Hub currentVault
]

{ #category : 'as yet unclassified' }
TTTacticalToolsHub class >> healthCheckExamples [

	"Tactical-Tools health check methods <ttHealthCheck>"
	
	<ttSpoke>
	
	^ #ttHealthCheck gtPragmas in: [ :p | p gtExamples runAll. p ]
	
]

{ #category : 'as yet unclassified' }
TTTacticalToolsHub class >> llmChatRegistry [ 

	"LLM Chats"
	
  <ttSpoke>

	^ GtLChatRegistry current
]

{ #category : 'as yet unclassified' }
TTTacticalToolsHub class >> llmConnectionRegistry [ 

	"LLM Connections"
	
  <ttSpoke>

	^ GtLConnectionRegistry uniqueInstance updateConnections
]

{ #category : 'as yet unclassified' }
TTTacticalToolsHub class >> newGtChatWithProvider: aProviderOrNil [
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
TTTacticalToolsHub class >> newTTChat [ 

	"Let Us Chat"
	
  <ttSpoke>

	^ self newGtChatWithProvider: nil
	 
]

{ #category : 'as yet unclassified' }
TTTacticalToolsHub class >> pragmasAll_ttClient [

	"Tactical-Tools client providers <ttClient>"
	
	<ttSpoke>
	
	^ (Pragma allNamed: #ttClient),(Pragma allNamed: #ttApiClient)
	

]

{ #category : 'as yet unclassified' }
TTTacticalToolsHub class >> pragmasAll_ttShutDownStartUp [

	"Tactical-Tools <ttShutDown>/<ttStartUp>"
	
	<ttSpoke>
	
	^ TTStartUpShutDownAtSystemPriority pragmasAll_ttShutDown, (TTStartUpShutDownAtSystemPriority pragmasAll_ttStartUp)
	  
	
]

{ #category : 'as yet unclassified' }
TTTacticalToolsHub class >> pragmasAll_ttUtility [

	"Tactical-Tools utility methods <ttUtility>"
	
	<ttSpoke>
	
	^ Pragma allNamed: #ttUtility
	
]

{ #category : 'as yet unclassified' }
TTTacticalToolsHub class >> pragmasAll_ttWall [

	"Tactical-Tools wall methods <ttWall>"
	
	<ttSpoke>
	
	^ Pragma allNamed: #ttWall
	

]

{ #category : 'as yet unclassified' }
TTTacticalToolsHub class >> pragmasAll_ttWhoAmI [

	"Identity providers <ttWhoAmI>"
	
	<ttSpoke>
	
	^ Pragma allNamed: #ttWhoAmI
	

]

{ #category : 'as yet unclassified' }
TTTacticalToolsHub class >> pragmasShutDownStartUp [

	"Tactical-Tools <ttShutDown>/<ttStartUp> (validated)"
	
	<ttSpoke>
	
	^ TTStartUpShutDownAtSystemPriority pragmasShutDown, (TTStartUpShutDownAtSystemPriority pragmasStartUp)
	  
	
]

{ #category : 'as yet unclassified' }
TTTacticalToolsHub class >> shutDownStartUpTTDryRun [

	"Tactical Tools shutDown/startUp methods - Dry Run"
	
	"The idea is to sanity test startUp/shutDown methods without the risk of breaking the image"
		
	<ttSpoke>
	
	^ (TTStartUpShutDownAtSystemPriority shutDownDryRun),(TTStartUpShutDownAtSystemPriority startUpDryRun)
]

{ #category : 'as yet unclassified' }
TTTacticalToolsHub class >> startUpShutDownSystem [
	
	"Tactical Tools - shutdown/startUp subsystem"
	<ttHub>
	^ TTStartUpShutDownSubsystem
]

{ #category : 'as yet unclassified' }
TTTacticalToolsHub class >> theFactory [

	"Fabulous Factory"
	
	<ttSpoke>
	
	^ TTFactory new
]

{ #category : 'as yet unclassified' }
TTTacticalToolsHub class >> theVaultSearchPath [

	"Vicarious Vault - Search Path"
	
	<ttSpoke>
	
	^ (FileLookedForNotification collectDuring: [ TTVault newWithRWConfigOSEnv ])  
]

{ #category : 'as yet unclassified' }
TTTacticalToolsHub class >> ttLeDatabase [
	
	"Lepiter - Tactical Tools "
	
	<ttSpoke>
	
	^ LeDatabase databaseNamed: 'keithy/Glamorous-Tactical-Tools/lepiter'
]

{ #category : 'as yet unclassified' }
TTTacticalToolsHub class >> ttLlmInstructions [
	
	"Lepiter - LLM Instructions "
	
	<ttSpoke>
	
	^ self ttLeDatabase pageNamed: 'Tactical LLM Instructions'
]

{ #category : 'as yet unclassified' }
TTTacticalToolsHub class >> ttPageExplanation: aPageName [ 
	^ self ttLeDatabase pageNamed: aPageName
]
