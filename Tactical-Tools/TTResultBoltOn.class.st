Class {
	#name : 'TTResultBoltOn',
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
TTResultBoltOn class >> doesNotUnderstand: aMessage [

	^ self basicNew 
			setActionSelector: aMessage selector arguments: aMessage arguments;
			initialize
		
]

{ #category : 'accessing' }
TTResultBoltOn >> applyTo: aResult [
	
		result := aResult.
		
		self perform: actionSelector withArguments: arguments
]

{ #category : 'accessing' }
TTResultBoltOn >> setActionSelector: aSymbol arguments: args [
	actionSelector := aSymbol.
	arguments := args
]
