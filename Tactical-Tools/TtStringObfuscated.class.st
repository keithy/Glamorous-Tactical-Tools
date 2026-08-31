Class {
	#name : 'TTStringObfuscated',
	#superclass : 'ByteString',
	#type : 'bytes',
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'printing' }
TTStringObfuscated >> asHint [

	| n |
	
	n := 1.
	
	self size > 10 ifTrue: [  n := 2 ].
	self size > 20 ifTrue: [  n := 4 ].
	
	^ '****', (self last: n)
	
	
]

{ #category : 'printing' }
TTStringObfuscated >> asRopedText [

 ^ BlRunRopedText string: self value
]

{ #category : 'printing' }
TTStringObfuscated >> explain [

	'Obfuscated'
]

{ #category : 'printing' }
TTStringObfuscated >> gtActionCopy: anAction [
	<gtAction>
	^ anAction button
		priority: 105;
		icon: BrGlamorousVectorIcons clipboard;
		label: 'Copy to Clipboard';
		action: [ :button |  Clipboard clipboardText: self ]
		
]

{ #category : 'printing' }
TTStringObfuscated >> gtViewHintFor: aView [
	<gtView>
	^ aView explicit
		title: 'Hint';
		priority: 9;
		stencil: [
			BrEditorElement new
				margin: (BlInsets all: 10);
				constraintsDo: [ :c | 
					c vertical matchParent. 
					c horizontal matchParent ];
				editor: (BrTextEditorModel new
					text: ( (self asHint) asRopedText
						glamorousCodeFont)).
		]
]

{ #category : 'printing' }
TTStringObfuscated >> printOn: aStream [
	"Make sure that this is not printOn: because we do not want to have multiple quotes."
	aStream nextPutAll: self value
]

{ #category : 'printing' }
TTStringObfuscated >> value [
	
	^ '******'
	
	
]
