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

{ #category : 'accessing' }
AnObsoleteSRLClient >> asDictionary [

	^ ((SRLClass class: subject) // thing) asDictionary
	
]

{ #category : 'accessing' }
AnObsoleteSRLClient >> asString [

	^ ((SRLClass class: subject) // thing) asString
	
]

{ #category : 'accessing' }
AnObsoleteSRLClient >> resolve: aThing [
	"defer decision to a client class"

	"Resolve a string to myself, pending next action"
	thing := aThing.
	subject := #TTApiThinClient.

	(aThing isClass or: [ aThing isSymbol ])
		ifTrue: [ 
			subject := SRLClass class: aThing.
			thing := ''.
		].	
	
	^ self
]
