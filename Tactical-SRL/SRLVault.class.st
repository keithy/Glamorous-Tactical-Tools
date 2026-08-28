Class {
	#name : 'SRLVault',
	#superclass : 'SRLEnv',
	#category : 'Tactical-SRL-Schemes',
	#package : 'Tactical-SRL',
	#tag : 'Schemes'
}

{ #category : 'as yet unclassified' }
SRLVault class >> canRoute: aSymbol [

	^ aSymbol == #vault:
]

{ #category : 'as yet unclassified' }
SRLVault class >> vault: aVarName [

	"local shortcut"
	 ^ self new thing: aVarName; resolve
   
    
]

{ #category : 'as yet unclassified' }
SRLVault >> +/ aKey [
	
	^ resolved at: aKey
	
]

{ #category : 'as yet unclassified' }
SRLVault >> +// anOption [
	
	resolved optionsSelect: anOption.
]

{ #category : 'as yet unclassified' }
SRLVault >> asString [

^ self resolve asString
	
]

{ #category : 'as yet unclassified' }
SRLVault >> getVault [ 
	
	^ self hub getVault 
]

{ #category : 'as yet unclassified' }
SRLVault >> gtOptionsFor: aView [
	<gtView>
	^ aView forward
		title: 'Vault Options';
		priority: 5;
		object: [ resolved ];
		view: #gtOptionsFor:
]

{ #category : 'as yet unclassified' }
SRLVault >> gtVaultViewFor: aView [
	<gtView>
	^ aView forward
		title: 'Vault Config';
		priority: 10;
		object: [ resolved ];
		view: #gtConfigFor:
]

{ #category : 'as yet unclassified' }
SRLVault >> resolve [
	thing ifNil: [ ^ self ].
	^ self resolve: thing
]

{ #category : 'as yet unclassified' }
SRLVault >> resolve: aThing [

	^ resolved at: aThing
]

{ #category : 'as yet unclassified' }
SRLVault >> thing: aThing [
	
	thing := nil.
	
	resolved ifNil: [ resolved := self getVault ].
	
	aThing isAssociation
		ifTrue: [  ^ resolved := resolved copyForAppKey: aThing key optionKey: aThing value ].
	
	aThing isSymbol
		ifTrue: [ ^ resolved := resolved copyForAppKey: aThing optionKey: #default ].

	thing := aThing.
			
]
