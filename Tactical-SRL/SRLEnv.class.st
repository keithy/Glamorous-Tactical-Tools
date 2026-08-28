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
	 ^ self new thing: aVarName; resolve
   
    
]

{ #category : 'as yet unclassified' }
SRLEnv class >> example [
	<gtExample>
	^ #env: / #USER
]

{ #category : 'as yet unclassified' }
SRLEnv class >> exampleMatchesShortCut [
	<gtExample>
	^ (#env: // #USER) == (self env: #USER)
]

{ #category : 'accessing' }
SRLEnv >> resolve [
	^ resolved := self resolve: thing
]

{ #category : 'accessing' }
SRLEnv >> resolve: envKey [ 
	
	^ self hub osEnvironment at: envKey ifAbsent: nil
]

{ #category : 'accessing' }
SRLEnv >> thing: envRef [
		
	| envKey |
	
	envKey := envRef withoutPrefix: '${'.
	envKey := envKey withoutSuffix: '}'.
	
	thing := envKey asSymbol.
			
]
