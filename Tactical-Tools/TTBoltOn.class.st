Class {
	#name : 'TTBoltOn',
	#superclass : 'Object',
	#instVars : [
		'actionSelector',
		'arguments',
		'result'
	],
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'accessing' }
TTBoltOn class >> doesNotUnderstand: aMessage [

	^ self new 
			actionSelector: aMessage selector;
			arguments: aMessage arguments;
			yourself
		
]

{ #category : 'accessing' }
TTBoltOn >> actionSelector: anObject [
	actionSelector := anObject
]

{ #category : 'accessing' }
TTBoltOn >> applyTo: aResult [
	
		| selfish |
		selfish := aResult.
		
		self perform: actionSelector withArguments: arguments
]

{ #category : 'accessing' }
TTBoltOn >> arguments: anObject [
	arguments := anObject
]
