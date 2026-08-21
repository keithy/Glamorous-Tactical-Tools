Class {
	#name : 'SRLUrl',
	#superclass : 'SRLRouter',
	#category : 'Tactical-SRL-Schemes',
	#package : 'Tactical-SRL',
	#tag : 'Schemes'
}

{ #category : 'as yet unclassified' }
SRLUrl class >> canRoute: aSymbol [
 
	^ #(url: http: https:) includes: aSymbol
]

{ #category : 'as yet unclassified' }
SRLUrl class >> example [
	<gtExample>
	^ (#url: //  'https://httpbin.org/json') asDictionary
]

{ #category : 'as yet unclassified' }
SRLUrl class >> url: aVarName [

	"local shortcut"
	^ self new resolve: aVarName
   
    
]

{ #category : 'accessing' }
SRLUrl >> asDictionary [

	^ ((SRLClass class: subject) // thing) asDictionary
	
]

{ #category : 'accessing' }
SRLUrl >> asString [

	^ ((SRLClass class: subject) // thing) asString
	
]

{ #category : 'accessing' }
SRLUrl >> resolve: aThing [ 
	
	"decision to a client class"
	(aThing isClass or: [ aThing isSymbol])
		ifTrue: [ subject := aThing. thing:= ''.  ^self ].

  "Resolve a string to myself, pending next action"
  thing := aThing.
	subject := #TTApiThinClient.
	
	^ self
]
