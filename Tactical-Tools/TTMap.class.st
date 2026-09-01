Class {
	#name : 'TTMap',
	#superclass : 'Object',
	#instVars : [
		'models',
		'input',
		'output',
		'prototype',
		'collection'
	],
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'accessing' }
TTMap >> cull: payload cull: result [

  input := payload.
 
	self isDictionary ifTrue: [ ^ output := self modelFrom: input ].
	self mapEachToPrototype.
	
  ^ output  
]

{ #category : 'accessing' }
TTMap >> gtThunkEntries [

^ #(prototype collection)
]

{ #category : 'accessing' }
TTMap >> into: aCollection [

	collection := aCollection
]

{ #category : 'accessing' }
TTMap >> isBlock [
	"ducking it"

	^ true
]

{ #category : 'accessing' }
TTMap >> mapEachToPrototype [
	models := input collect: [ :each | self modelFrom: each ].

	collection
		ifNotNil: [ collection isArray
				ifTrue: [ output := collection copyWithAll: models ]
				ifFalse: [ output := collection copy
							addAll: models;
							yourself ] ]
]

{ #category : 'accessing' }
TTMap >> modelFrom: dict [
 ^ prototype copy
					rawData: dict;
					yourself 
	 
]

{ #category : 'accessing' }
TTMap >> prototype: aModel [

	prototype := aModel
]
