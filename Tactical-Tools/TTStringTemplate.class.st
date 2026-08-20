Class {
	#name : 'TTStringTemplate',
	#superclass : 'Object',
	#instVars : [
		'template'
	],
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'as yet unclassified' }
TTStringTemplate class >> example [

  ^ (self newFrom: 'This is a test for ${NICKNAME} and the ${HOME} team') templateResolveUsing: Hub current getVault 
 
 

]

{ #category : 'as yet unclassified' }
TTStringTemplate class >> newFrom: aString [

	"'*${*}*' match: 'h${ello}'"

	('*${*}*' match: aString) ifFalse: [ ^ aString ].

	^ (self new)
	     setTemplate: aString
	     yourself 
]

{ #category : 'printing' }
TTStringTemplate >> asRopedText [

 ^ BlRunRopedText string: self value
]

{ #category : 'printing' }
TTStringTemplate >> displayStringOn: aStream [
	"Make sure that this is not printOn: because we do not want to have multiple quotes."
	aStream nextPutAll: self value
]

{ #category : 'printing' }
TTStringTemplate >> explain [

	'Template'
]

{ #category : 'printing' }
TTStringTemplate >> gtActionCopy: anAction [
	<gtAction>
	^ anAction button
		priority: 105;
		icon: BrGlamorousVectorIcons clipboard;
		label: 'Copy to Clipboard';
		action: [ :button |  Clipboard clipboardText: self ]
		
]

{ #category : 'printing' }
TTStringTemplate >> gtDisplayOn: aStream [
	"Make sure that this is not printOn: because we do not want to have multiple quotes."
	aStream nextPutAll: self value
	
	
]

{ #category : 'printing' }
TTStringTemplate >> gtDisplayString [
	
	^ self value
	
	
]

{ #category : 'printing' }
TTStringTemplate >> printOn: aStream [
	"Make sure that this is not printOn: because we do not want to have multiple quotes."
	aStream nextPutAll: self value
]

{ #category : 'accessing' }
TTStringTemplate >> setTemplate: anObject [
	template := anObject
]

{ #category : 'accessing' }
TTStringTemplate >> template [
	^ template
]

{ #category : 'printing' }
TTStringTemplate >> templateResolveUsing: aVault [
	| in |
	in := template readStream.

	^ String
		streamContents: [ :out | 
			[ out nextPutAll: (in upToAll: '${').
			in atEnd ]
				whileFalse: [ | var |
					var := in upTo: $}.
					out nextPutAll: ((aVault lookup: var) ifNil: [ var ]) ] ]
]
