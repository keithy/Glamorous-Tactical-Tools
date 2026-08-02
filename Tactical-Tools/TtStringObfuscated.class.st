Class {
	#name : 'TtStringObfuscated',
	#superclass : 'ByteString',
	#type : 'bytes',
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'printing' }
TtStringObfuscated >> asHint [

	| n |
	
	n := 1.
	
	self size > 10 ifTrue: [  n := 2 ].
	self size > 20 ifTrue: [  n := 4 ].
	
	^ '****', (self last: n)
	
	
]

{ #category : 'printing' }
TtStringObfuscated >> asRopedText [

 ^ BlRunRopedText string: self value
]

{ #category : 'printing' }
TtStringObfuscated >> displayStringOn: aStream [
	"Make sure that this is not printOn: because we do not want to have multiple quotes."
	aStream nextPutAll: self value
]

{ #category : 'printing' }
TtStringObfuscated >> explain [

	'Obfuscated'
]

{ #category : 'printing' }
TtStringObfuscated >> gtActionCopy: anAction [
	<gtAction>
	^ anAction button
		priority: 105;
		icon: BrGlamorousVectorIcons clipboard;
		label: 'Copy to Clipboard';
		action: [ :button |  Clipboard clipboardText: self ]
		
]

{ #category : 'printing' }
TtStringObfuscated >> gtDisplayOn: aStream [
	"Make sure that this is not printOn: because we do not want to have multiple quotes."
	aStream nextPutAll: self value
	
	
]

{ #category : 'printing' }
TtStringObfuscated >> gtDisplayString [
	
	^ self value
	
	
]

{ #category : 'printing' }
TtStringObfuscated >> gtViewHintFor: aView [
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
TtStringObfuscated >> printOn: aStream [
	"Make sure that this is not printOn: because we do not want to have multiple quotes."
	aStream nextPutAll: self value
]

{ #category : 'printing' }
TtStringObfuscated >> value [
	
	^ '******'
	
	
]
