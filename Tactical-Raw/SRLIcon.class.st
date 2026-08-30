Class {
	#name : 'SRLIcon',
	#superclass : 'SRLRouter',
	#category : 'Tactical-Raw-Theme',
	#package : 'Tactical-Raw',
	#tag : 'Theme'
}

{ #category : 'as yet unclassified' }
SRLIcon class >> canRoute: aSymbol [

	^ aSymbol == #icon:
]

{ #category : 'as yet unclassified' }
SRLIcon class >> env: aVarName [

	"local shortcut"
	 ^ self new thing: aVarName; resolve
   
    
]

{ #category : 'as yet unclassified' }
SRLIcon class >> example [
	<gtExample>
	^ #env: / #USER
]

{ #category : 'as yet unclassified' }
SRLIcon class >> exampleMatchesShortCut [
	<gtExample>
	^ (#env: // #USER) == (self env: #USER)
]

{ #category : 'accessing' }
SRLIcon >> resolve [
	^ resolved := self resolve: thing
]

{ #category : 'accessing' }
SRLIcon >> resolve: envKey [ 
	
	^ self hub osEnvironment at: envKey ifAbsent: nil
]

{ #category : 'accessing' }
SRLIcon >> thing: envRef [
		
	| envKey |
	
	envKey := envRef withoutPrefix: '$'.
	envKey := envKey withoutPrefix: '{'.
	envKey := envKey withoutSuffix: '}'.
	
	thing := envKey asSymbol.
			
]
