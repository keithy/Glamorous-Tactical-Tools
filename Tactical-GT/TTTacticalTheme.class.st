Class {
	#name : 'TTTacticalTheme',
	#superclass : 'TTOriginalTheme',
	#category : 'Tactical-GT-Views',
	#package : 'Tactical-GT',
	#tag : 'Views'
}

{ #category : 'accessing' }
TTTacticalTheme class >> arrayExpansion [

^ #(#set)
]

{ #category : 'accessing' }
TTTacticalTheme class >> dictionaryExpansion [

^ #(#dictionary)
]

{ #category : 'accessing' }
TTTacticalTheme class >> limitExpansion [

^ #(#string #symbol #block)
]

{ #category : 'accessing' }
TTTacticalTheme class >> specialExpansion [

^ #(#set #dictionary)
]

{ #category : 'accessing' }
TTTacticalTheme class >> titleRawView [

	^ 'Raw™'
]

{ #category : 'as yet unclassified' }
TTTacticalTheme >> icon [
	
		object gtInspectorIcon ifNotNil: [ :icon | ^ (object className) -> icon ].

	^ (self askFor: (self iconSelector) ifAbsent: [ ^ self iconNotFound ])
]

{ #category : 'accessing' }
TTTacticalTheme >> iconFromText: text [  

	^ self iconFromText: text  color: Color gray
]

{ #category : 'accessing' }
TTTacticalTheme >> iconFromText: text color: color [
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
TTTacticalTheme >> iconNamed: aSymbol [

	^ Smalltalk ui icons iconNamed: aSymbol
]

{ #category : 'accessing' }
TTTacticalTheme >> iconNotFound [

	^ #notFound -> (self iconNamed: #glamorousBug)
]

{ #category : 'as yet unclassified' }
TTTacticalTheme >> iconSelector [

	^ ('icon_', type) asSymbol
]

{ #category : 'accessing' }
TTTacticalTheme >> icon_array [
	^ #array -> (self iconFromText:'[  ]')
]

{ #category : 'accessing' }
TTTacticalTheme >> icon_bag [
	^ #bag -> (self iconFromText:'{_}')
]

{ #category : 'accessing' }
TTTacticalTheme >> icon_block [
	^ #block -> (self iconFromText:'[:a]')
]

{ #category : 'accessing' }
TTTacticalTheme >> icon_class [

	^ #instance -> (self iconNamed: #class)
]

{ #category : 'accessing' }
TTTacticalTheme >> icon_classAbstract [

	^ #classAbstract -> (self iconNamed: #classAbstract)
]

{ #category : 'accessing' }
TTTacticalTheme >> icon_collection [

	^ #collection -> (self iconNamed: #collection)
]

{ #category : 'accessing' }
TTTacticalTheme >> icon_compiled [

	^ #compiled -> (self iconFromText: '[:::]')
]

{ #category : 'accessing' }
TTTacticalTheme >> icon_context [
	^ #context -> (self iconFromText:'[ . ]')
]

{ #category : 'accessing' }
TTTacticalTheme >> icon_dictionary [

	^ #dictionary -> (self iconFromText: '{»}')
]

{ #category : 'accessing' }
TTTacticalTheme >> icon_empty [

	^ #empty -> (self iconNamed: #glamorousHelp)
]

{ #category : 'accessing' }
TTTacticalTheme >> icon_false [

	^ #false -> (self iconNamed: #mooseCancel "#glamorousCancel")
]

{ #category : 'accessing' }
TTTacticalTheme >> icon_hubClass [

	^ #hubClass -> (self iconFromText: '⎈')
]

{ #category : 'accessing' }
TTTacticalTheme >> icon_instance [

	^ #instance ->  (self iconNamed: #glamorousGrayCircle)
]

{ #category : 'accessing' }
TTTacticalTheme >> icon_magnitude [

	^ #magnitude -> (self iconNamed: #magnitude)
]

{ #category : 'accessing' }
TTTacticalTheme >> icon_method [

	^ #method -> (self iconFromText: '[>>]')
]

{ #category : 'accessing' }
TTTacticalTheme >> icon_nil [

	^ #nil -> (self iconNamed: #glamorousGrayCircleEmpty)
]

{ #category : 'accessing' }
TTTacticalTheme >> icon_pragma [

	^ #pragma -> (self iconFromText: '< >')
]

{ #category : 'accessing' }
TTTacticalTheme >> icon_set [

	^ #set -> (self iconFromText: '{#}')
]

{ #category : 'accessing' }
TTTacticalTheme >> icon_string [

	^ #string -> (self iconNamed: #string)
]

{ #category : 'accessing' }
TTTacticalTheme >> icon_symbol [
	^ #symbol -> (self iconFromText:'#')
]

{ #category : 'accessing' }
TTTacticalTheme >> icon_true [

	^ #true -> (self iconNamed: #mooseAccept "#glamorousAccept")
]
