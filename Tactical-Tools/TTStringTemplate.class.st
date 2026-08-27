Class {
	#name : 'TTStringTemplate',
	#superclass : 'ByteString',
	#type : 'bytes',
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'printing' }
TTStringTemplate >> asRopedText [

 ^ BlRunRopedText string: self value
]

{ #category : 'printing' }
TTStringTemplate >> asString [

	^ self envSubst: Hub current currentVault
]

{ #category : 'printing' }
TTStringTemplate >> displayStringOn: aStream [
	"Make sure that this is not printOn: because we do not want to have multiple quotes."
	aStream nextPutAll: self value
]

{ #category : 'printing' }
TTStringTemplate >> envSubst: aDict [
	| in |
	in := self readStream.

	^ String
		streamContents: [ :out | 
			[ out nextPutAll: (in upToAll: '${').
			in atEnd ]
				whileFalse: [ | var |
					var := in upTo: $}.
					out nextPutAll: (aDict at: var ifAbsent: [ var ]) ] ]
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
