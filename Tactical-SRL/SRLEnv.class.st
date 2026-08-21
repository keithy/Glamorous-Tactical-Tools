Class {
	#name : 'SRLEnv',
	#superclass : 'SRLRouter',
	#category : 'Tactical-SRL-Schemes',
	#package : 'Tactical-SRL',
	#tag : 'Schemes'
}

{ #category : 'as yet unclassified' }
SRLEnv class >> canRoute: aSymbol [

	^ aSymbol == #env:
]

{ #category : 'as yet unclassified' }
SRLEnv class >> env: aVarName [

	"local shortcut"
	 ^ self new resolve: aVarName
   
    
]

{ #category : 'as yet unclassified' }
SRLEnv class >> example [
	<gtExample>
	^ #env: / #USER
]

{ #category : 'as yet unclassified' }
SRLEnv class >> exampleMatchesShortCut [
	<gtExample>
	^ #env: / #USER == (self env: #USER)
]

{ #category : 'accessing' }
SRLEnv >> getEnv: varNameWithDollar [

	"go via vault later"
	
	| varName |
	
	varName := varNameWithDollar withoutPrefix: '${'.
	varName := varName withoutSuffix: '}'.
	
	^ self hub osEnvironment at: (varName asSymbol) ifAbsent: nil
]

{ #category : 'accessing' }
SRLEnv >> resolve [

	| varName |
	
	varName := thing withoutPrefix: '${'.
	varName := varName withoutSuffix: '}'.
	
	^ self resolve: varName
	 
	 
]

{ #category : 'accessing' }
SRLEnv >> resolve: varName [ 
	
	^ self hub osEnvironment at: (varName asSymbol) ifAbsent: nil
]
