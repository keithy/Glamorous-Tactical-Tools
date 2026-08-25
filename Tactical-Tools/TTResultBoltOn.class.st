Class {
	#name : 'TTResultBoltOn',
	#superclass : 'Object',
	#instVars : [
		'actionSelector',
		'arguments',
		'result'
	],
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'accessing' }
TTResultBoltOn class >> doesNotUnderstand: aMessage [
	(self canUnderstand: aMessage selector)
		ifFalse: [ ^ super doesNotUnderstand: aMessage ].

	^ self newFromMessage: aMessage
]

{ #category : 'as yet unclassified' }
TTResultBoltOn class >> isNamespaced [
  <namespaced>
	<namespaced:'TT'> 
	^ true
]

{ #category : 'accessing' }
TTResultBoltOn class >> newFromMessage: aMessage [
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
