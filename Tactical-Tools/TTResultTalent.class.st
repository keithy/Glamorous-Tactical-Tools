Class {
	#name : 'TTResultTalent',
	#superclass : 'Object',
	#instVars : [
		'actionSelector',
		'arguments',
		'result'
	],
	#category : 'Tactical-Tools-Result',
	#package : 'Tactical-Tools',
	#tag : 'Result'
}

{ #category : 'accessing' }
TTResultTalent class >> doesNotUnderstand: aMessage [

	(self canUnderstand: aMessage selector) ifFalse: [ ^ super doesNotUnderstand: aMessage ].
	
	^ self basicNew 
			setActionSelector: aMessage selector arguments: aMessage arguments;
			initialize
		
]

{ #category : 'accessing' }
TTResultTalent >> applyTo: aResult [
	
		result := aResult.
		
		self perform: actionSelector withArguments: arguments
]

{ #category : 'accessing' }
TTResultTalent >> setActionSelector: aSymbol arguments: args [
	actionSelector := aSymbol.
	arguments := args
]
