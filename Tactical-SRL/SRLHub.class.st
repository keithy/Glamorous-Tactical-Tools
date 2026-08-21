Class {
	#name : 'SRLHub',
	#superclass : 'SRLRouter',
	#category : 'Tactical-SRL-Schemes',
	#package : 'Tactical-SRL',
	#tag : 'Schemes'
}

{ #category : 'as yet unclassified' }
SRLHub class >> canRoute: aSymbol [

	^ #(#hub:) includes: aSymbol
]

{ #category : 'as yet unclassified' }
SRLHub class >> example [
	<gtExample>
	^ #hub: // #TacticalToolsHub
]

{ #category : 'as yet unclassified' }
SRLHub class >> exampleMatchesShortCut [
	<gtExample>
	^ self example == (self pragma: #ttUtility)
]

{ #category : 'as yet unclassified' }
SRLHub class >> hub: aPragmaSymbol [

	"local shortcut"
	 ^ self new resolve: aPragmaSymbol
   
    
]

{ #category : 'as yet unclassified' }
SRLHub class >> pragma: aPragmaSymbol [

	"local shortcut"
	 ^ self new resolve: aPragmaSymbol
   
    
]

{ #category : 'as yet unclassified' }
SRLHub >> resolve: aClassSymbolOrName [

	 
   ^ (#class://aClassSymbolOrName) open
]
