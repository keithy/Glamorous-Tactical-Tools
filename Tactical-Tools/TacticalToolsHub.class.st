Class {
	#name : 'TacticalToolsHub',
	#superclass : 'Object',
	#category : 'Tactical-Tools-Demo',
	#package : 'Tactical-Tools',
	#tag : 'Demo'
}

{ #category : 'as yet unclassified' }
TacticalToolsHub class >> pragmasAllUtility [

	"Tactical-Tools utility methods"
	
	<ttSpoke>
	
	^ Pragma allNamed: #ttUtility
	
]

{ #category : 'as yet unclassified' }
TacticalToolsHub class >> pragmasAllWall [

	"Tactical-Tools wall methods <ttWall>"
	
	<ttSpoke>
	
	^ Pragma allNamed: #ttWall
	

]

{ #category : 'as yet unclassified' }
TacticalToolsHub class >> theVault [

	"Vicarious Vault"
	
	<ttSpoke>
	
	^ TtVault currentVault
]
