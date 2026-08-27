Class {
	#name : 'TTStringEncoded',
	#superclass : 'Object',
	#instVars : [
		'encoded',
		'decodeSelector'
	],
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'as yet unclassified' }
TTStringEncoded class >> newFrom: aString [

	^ (self new)
	     setEncoded: aString
	     yourself 
]

{ #category : 'accessing' }
TTStringEncoded >> allRangesOfRegexMatches: match [

	"stringish behavior"
	^ #()
]

{ #category : 'accessing' }
TTStringEncoded >> asHint [

	| n |
	
	n := 1.
	
	encoded size > 10 ifTrue: [  n := 3 ].
	encoded size > 20 ifTrue: [  n := 6 ].
	
	^ (self decode first: n), '****'
	
	
]

{ #category : 'accessing' }
TTStringEncoded >> asRopedText [

 ^ BlRunRopedText string: self value
]

{ #category : 'accessing' }
TTStringEncoded >> asString [

	^ self decode
]

{ #category : 'accessing' }
TTStringEncoded >> beBase64 [

	decodeSelector := #decodeBase64
]

{ #category : 'accessing' }
TTStringEncoded >> beCyphered [

	decodeSelector := #decodeCyphered
]

{ #category : 'accessing' }
TTStringEncoded >> bePlain [

	decodeSelector := #decodePlain
]

{ #category : 'accessing' }
TTStringEncoded >> decode [

	^ self perform: decodeSelector
]

{ #category : 'accessing' }
TTStringEncoded >> decodeBase64 [

	^ encoded base64Decoded asString
]

{ #category : 'accessing' }
TTStringEncoded >> decodeCyphered [

	^ #decypher://encoded
]

{ #category : 'accessing' }
TTStringEncoded >> decodePlain [

	^ encoded 
]

{ #category : 'accessing' }
TTStringEncoded >> displayStringOn: aStream [
	"Make sure that this is not printOn: because we do not want to have multiple quotes."
	aStream nextPutAll: self value
]

{ #category : 'accessing' }
TTStringEncoded >> encoded [
	^ encoded
]

{ #category : 'accessing' }
TTStringEncoded >> explain [

	^ decodeSelector withoutPrefix: 'decode'
]

{ #category : 'accessing' }
TTStringEncoded >> gtActionCopy: anAction [
	<gtAction>
	^ anAction button
		priority: 105;
		icon: BrGlamorousVectorIcons clipboard;
		label: 'Copy to Clipboard';
		action: [ :button |  Clipboard clipboardText: self asString]
		
]

{ #category : 'accessing' }
TTStringEncoded >> gtDisplayOn: aStream [
	"Make sure that this is not printOn: because we do not want to have multiple quotes."
	aStream nextPutAll: self value
	
	
]

{ #category : 'accessing' }
TTStringEncoded >> gtDisplayString [
	
	^ self value
	
	
]

{ #category : 'accessing' }
TTStringEncoded >> gtViewHintFor: aView [
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

{ #category : 'accessing' }
TTStringEncoded >> printOn: aStream [
	"Make sure that this is not printOn: because we do not want to have multiple quotes."
	aStream nextPutAll: self value
]

{ #category : 'accessing' }
TTStringEncoded >> setEncoded: anObject [
	encoded := anObject
]

{ #category : 'accessing' }
TTStringEncoded >> value [

	^ '[**', self explain, '**]'
]
