Class {
	#name : 'TTInspectorTacticalTheme',
	#superclass : 'TTInspectorOriginalTheme',
	#category : 'Tactical-GT-Views',
	#package : 'Tactical-GT',
	#tag : 'Views'
}

{ #category : 'accessing' }
TTInspectorTacticalTheme class >> arrayExpansion [

^ #(#set)
]

{ #category : 'accessing' }
TTInspectorTacticalTheme class >> dictionaryExpansion [

^ #(#dictionary)
]

{ #category : 'accessing' }
TTInspectorTacticalTheme class >> limitExpansion [

^ #(#string #symbol #block)
]

{ #category : 'accessing' }
TTInspectorTacticalTheme class >> titleRawView [

	^ 'Raw™'
]

{ #category : 'accessing' }
TTInspectorTacticalTheme >> displayOn: aStream [
	
	stream := aStream.
	self askFor: self displaySelector ifAbsent: [ object gtDisplayOn: stream ].
	stream := nil.
	
]

{ #category : 'as yet unclassified' }
TTInspectorTacticalTheme >> displaySelector [

	^ ('display_', type) asSymbol
]

{ #category : 'accessing' }
TTInspectorTacticalTheme >> display_array [

	^ self display_collection
]

{ #category : 'accessing' }
TTInspectorTacticalTheme >> display_collection [

	object printNameOn: stream.
	stream
		space;
		nextPut: $[;
		print: object size;
		nextPutAll: (' item' asPluralBasedOn: object size);
		nextPut: $].
"		space.
	object size <= object gtCollectionSizeThreshold 
		ifTrue: [ object printElementsOn: stream ]"
]

{ #category : 'accessing' }
TTInspectorTacticalTheme >> display_dictionary [

	^ self display_collection
]

{ #category : 'accessing' }
TTInspectorTacticalTheme >> display_set [

	^ self display_collection
]

{ #category : 'as yet unclassified' }
TTInspectorTacticalTheme >> icon [
	
		object gtInspectorIcon ifNotNil: [ :icon | ^ (object className) -> icon ].

	^ (self askFor: (self iconSelector) ifAbsent: [ ^ self iconNotFound ])
]

{ #category : 'accessing' }
TTInspectorTacticalTheme >> iconFromText: text [  

	^ self iconFromText: text  color: Color gray
]

{ #category : 'accessing' }
TTInspectorTacticalTheme >> iconFromText: text color: color [
	^ [ BlElement new
		size: 16 @ 16;
		addChild: (BlTextElement new
				text: (text asRopedText
						fontSize: 12;
						foreground: color);
				position: (text size > 1 ifTrue: 0 ifFalse: 4) @ 2);
		yourself ] asStencil
]

{ #category : 'accessing' }
TTInspectorTacticalTheme >> iconNamed: aSymbol [

	^ Smalltalk ui icons iconNamed: aSymbol
]

{ #category : 'accessing' }
TTInspectorTacticalTheme >> iconNotFound [
		
		type := #notFound.
		
	^ self iconNamed: #glamorousBug
]

{ #category : 'as yet unclassified' }
TTInspectorTacticalTheme >> iconSelector [

	^ ('icon_', type) asSymbol
]

{ #category : 'accessing' }
TTInspectorTacticalTheme >> icon_array [
	^ self iconFromText:'[  ]'
]

{ #category : 'accessing' }
TTInspectorTacticalTheme >> icon_bag [
	^ self iconFromText:'{_}'
]

{ #category : 'accessing' }
TTInspectorTacticalTheme >> icon_block [
	^ self iconFromText:'[:a]'
]

{ #category : 'accessing' }
TTInspectorTacticalTheme >> icon_class [

	^ self iconNamed: #class
]

{ #category : 'accessing' }
TTInspectorTacticalTheme >> icon_classAbstract [

	^ self iconNamed: #classAbstract
]

{ #category : 'accessing' }
TTInspectorTacticalTheme >> icon_collection [

	^ self iconNamed: #collection
]

{ #category : 'accessing' }
TTInspectorTacticalTheme >> icon_compiled [

	^ self iconFromText: '[:::]'
]

{ #category : 'accessing' }
TTInspectorTacticalTheme >> icon_context [
	^ self iconFromText:'[ . ]'
]

{ #category : 'accessing' }
TTInspectorTacticalTheme >> icon_dictionary [

	^ self iconFromText: '{»}'
]

{ #category : 'accessing' }
TTInspectorTacticalTheme >> icon_empty [

	^ self iconNamed: #glamorousHelp
]

{ #category : 'accessing' }
TTInspectorTacticalTheme >> icon_false [

	^ self iconNamed: #mooseCancel "#glamorousCancel"
]

{ #category : 'accessing' }
TTInspectorTacticalTheme >> icon_hubClass [

	^ self iconFromText: '⎈'
]

{ #category : 'accessing' }
TTInspectorTacticalTheme >> icon_instance [

	^ self iconNamed: #glamorousGrayCircle
]

{ #category : 'accessing' }
TTInspectorTacticalTheme >> icon_magnitude [

	^ self iconNamed: #magnitude
]

{ #category : 'accessing' }
TTInspectorTacticalTheme >> icon_method [

	^ self iconFromText: '[>>]'
]

{ #category : 'accessing' }
TTInspectorTacticalTheme >> icon_nil [

	^ self iconNamed: #glamorousGrayCircleEmpty
]

{ #category : 'accessing' }
TTInspectorTacticalTheme >> icon_pragma [

	^ self iconFromText: '< >'
]

{ #category : 'accessing' }
TTInspectorTacticalTheme >> icon_set [

	^ self iconFromText: '{#}'
]

{ #category : 'accessing' }
TTInspectorTacticalTheme >> icon_string [

	^ self iconNamed: #string
]

{ #category : 'accessing' }
TTInspectorTacticalTheme >> icon_symbol [
	^ self iconFromText:'#'
]

{ #category : 'accessing' }
TTInspectorTacticalTheme >> icon_true [

	^  self iconNamed: #mooseAccept "#glamorousAccept"
]
