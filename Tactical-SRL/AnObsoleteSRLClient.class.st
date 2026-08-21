Class {
	#name : 'AnObsoleteSRLClient',
	#superclass : 'SRLRouter',
	#category : 'Tactical-SRL-Misc',
	#package : 'Tactical-SRL',
	#tag : 'Misc'
}

{ #category : 'as yet unclassified' }
AnObsoleteSRLClient class >> canRoute: aSymbol [
 
	^ false "aSymbol == #client:"
]

{ #category : 'as yet unclassified' }
AnObsoleteSRLClient class >> client: aVarName [

	"local shortcut"
	^ self new resolve: aVarName
   
    
]

{ #category : 'as yet unclassified' }
AnObsoleteSRLClient class >> example [
	<gtExample>
	^ #client: //  #TTApiThinClient
]

{ #category : 'as yet unclassified' }
AnObsoleteSRLClient class >> exampleGetUrl [
	<gtExample>
	^ self exampleUrl asDictionary
]

{ #category : 'as yet unclassified' }
AnObsoleteSRLClient class >> exampleUrl [
	<gtExample>
	^ (#client: //  #TTApiThinClient) // 'https://httpbin.org/json'
]
