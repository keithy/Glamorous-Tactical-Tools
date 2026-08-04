Class {
	#name : 'TtStringEncoded',
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
TtStringEncoded class >> newFrom: aString [

	^ (self new)
	     encoded: aString
	     yourself 
]

{ #category : 'accessing' }
TtStringEncoded >> allRangesOfRegexMatches: match [

	"stringish behavior"
	^ #()
]

{ #category : 'accessing' }
TtStringEncoded >> asHint [

	| n |
	
	n := 1.
	
	encoded size > 10 ifTrue: [  n := 3 ].
	encoded size > 20 ifTrue: [  n := 6 ].
	
	^ (self decode first: n), '****'
	
	
]

{ #category : 'accessing' }
TtStringEncoded >> asRopedText [

 ^ BlRunRopedText string: self value
]

{ #category : 'accessing' }
TtStringEncoded >> asString [

	^ self decode
]

{ #category : 'accessing' }
TtStringEncoded >> beBase64 [

	decodeSelector := #decodeBase64
]

{ #category : 'accessing' }
TtStringEncoded >> beCyphered [

	decodeSelector := #decodeCyphered
]

{ #category : 'accessing' }
TtStringEncoded >> bePlain [

	decodeSelector := #decodePlain
]

{ #category : 'accessing' }
TtStringEncoded >> decode [

	^ self perform: decodeSelector
]

{ #category : 'accessing' }
TtStringEncoded >> decodeBase64 [

	^ encoded base64Decoded asString
]

{ #category : 'accessing' }
TtStringEncoded >> decodeCyphered [

	^ self base64Decoded asString trimRight
]

{ #category : 'accessing' }
TtStringEncoded >> decodePlain [

	^ encoded 
]

{ #category : 'accessing' }
TtStringEncoded >> displayStringOn: aStream [
	"Make sure that this is not printOn: because we do not want to have multiple quotes."
	aStream nextPutAll: self value
]

{ #category : 'accessing' }
TtStringEncoded >> encoded [
	^ encoded
]

{ #category : 'accessing' }
TtStringEncoded >> encoded: anObject [
	encoded := anObject
]

{ #category : 'accessing' }
TtStringEncoded >> explain [

	^ decodeSelector withoutPrefix: 'decode'
]

{ #category : 'accessing' }
TtStringEncoded >> gtActionCopy: anAction [
	<gtAction>
	^ anAction button
		priority: 105;
		icon: BrGlamorousVectorIcons clipboard;
		label: 'Copy to Clipboard';
		action: [ :button |  Clipboard clipboardText: self asString]
		
]

{ #category : 'accessing' }
TtStringEncoded >> gtDisplayOn: aStream [
	"Make sure that this is not printOn: because we do not want to have multiple quotes."
	aStream nextPutAll: self value
	
	
]

{ #category : 'accessing' }
TtStringEncoded >> gtDisplayString [
	
	^ self value
	
	
]

{ #category : 'accessing' }
TtStringEncoded >> gtViewHintFor: aView [
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
TtStringEncoded >> printOn: aStream [
	"Make sure that this is not printOn: because we do not want to have multiple quotes."
	aStream nextPutAll: self value
]

{ #category : 'accessing' }
TtStringEncoded >> value [

	^ '**', self explain, '**'
]
