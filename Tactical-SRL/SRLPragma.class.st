Class {
	#name : 'SRLPragma',
	#superclass : 'SRLRouter',
	#category : 'Tactical-SRL-Schemes',
	#package : 'Tactical-SRL',
	#tag : 'Schemes'
}

{ #category : 'as yet unclassified' }
SRLPragma class >> canRoute: aSymbol [

	^ #(#pragma: #pragmas:) includes: aSymbol
]

{ #category : 'as yet unclassified' }
SRLPragma class >> example [
	<gtExample>
	^ #pragma: // #ttUtility
]

{ #category : 'as yet unclassified' }
SRLPragma class >> exampleMatchesShortCut [
	<gtExample>
	^ self example == (self pragma: #ttUtility)
]

{ #category : 'as yet unclassified' }
SRLPragma class >> pragma: aPragmaSymbol [

	"local shortcut"
	 ^ self new resolve: aPragmaSymbol
   
    
]

{ #category : 'as yet unclassified' }
SRLPragma >> resolve: aPragmaSymbol [

	 
   ^ nil
]
