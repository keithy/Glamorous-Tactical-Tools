Class {
	#name : 'SRLClient',
	#superclass : 'SRLClass',
	#category : 'Tactical-SRL-Schemes',
	#package : 'Tactical-SRL',
	#tag : 'Schemes'
}

{ #category : 'as yet unclassified' }
SRLClient class >> canRoute: aSymbol [
 
	^ aSymbol == #client:
]

{ #category : 'as yet unclassified' }
SRLClient class >> client: aVarName [

	"local shortcut"
	^ self new resolve: aVarName
   
    
]

{ #category : 'as yet unclassified' }
SRLClient class >> example [
	<gtExample>
	^ #client: //  #TTApiThinClient
]

{ #category : 'as yet unclassified' }
SRLClient class >> exampleGetUrl [
	<gtExample>
	^ self exampleUrl asDictionary
]

{ #category : 'as yet unclassified' }
SRLClient class >> exampleUrl [
	<gtExample>
	^ (#client: //  #TTApiThinClient) // 'https://httpbin.org/json'
]

{ #category : 'accessing' }
SRLClient >> asDictionary [

	^ ((SRLClass class: subject) // thing) asDictionary
	
]

{ #category : 'accessing' }
SRLClient >> asString [

	^ ((SRLClass class: subject) // thing) asString
	
]

{ #category : 'accessing' }
SRLClient >> resolve: aThing [ 
	
	"defer decision to a client class"
	(aThing isClass or: [ aThing isSymbol])
		ifTrue: [ subject := (super resolve: aThing). thing:= ''.  ^self ].

  "Resolve a string to myself, pending next action"
  thing := aThing.
	subject := #TTApiThinClient.
	
	^ self
]
