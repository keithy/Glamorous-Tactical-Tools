Class {
	#name : 'SRLOpen',
	#superclass : 'SRLRouter',
	#category : 'Tactical-SRL-Schemes',
	#package : 'Tactical-SRL',
	#tag : 'Schemes'
}

{ #category : 'as yet unclassified' }
SRLOpen class >> canRoute: aSymbol [

	^ #(#open:) includes: aSymbol
]

{ #category : 'as yet unclassified' }
SRLOpen class >> example [
	<gtExample>
	^ #open: // #TacticalToolsHub
]

{ #category : 'as yet unclassified' }
SRLOpen class >> exampleMatchesShortCut [
	<gtExample>
	^ self example == (self pragma: #ttUtility)
]

{ #category : 'as yet unclassified' }
SRLOpen class >> open: aClassSymbolOrName [

	"local shortcut"
	 ^ self new resolve: aClassSymbolOrName
   
    
]

{ #category : 'as yet unclassified' }
SRLOpen >> resolve: aClassSymbolOrName [

	 
   ^ (#class://aClassSymbolOrName) open
]
