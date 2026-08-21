Class {
	#name : 'SRLMethod',
	#superclass : 'SRLRouter',
	#category : 'Tactical-SRL-Schemes',
	#package : 'Tactical-SRL',
	#tag : 'Schemes'
}

{ #category : 'as yet unclassified' }
SRLMethod class >> canRoute: aSymbol [

	^ aSymbol == #method:
]

{ #category : 'as yet unclassified' }
SRLMethod class >> class: aClassOrName [

	"local shortcut"
	 ^ self new resolve: aClassOrName
   
    
]

{ #category : 'as yet unclassified' }
SRLMethod class >> example [
	<gtExample>
	^ #class: // #Object
]

{ #category : 'as yet unclassified' }
SRLMethod class >> exampleMatchesShortCut [
	<gtExample>
	^ self example == (self method: #Object)
]

{ #category : 'as yet unclassified' }
SRLMethod >> resolve: aClassOrSymbolOrName [

   ^ nil
]
