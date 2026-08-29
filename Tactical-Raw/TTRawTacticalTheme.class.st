Class {
	#name : 'TTRawTacticalTheme',
	#superclass : 'TTRawOriginalTheme',
	#category : 'Tactical-Raw-Theme',
	#package : 'Tactical-Raw',
	#tag : 'Theme'
}

{ #category : 'accessing' }
TTRawTacticalTheme class >> limitExpansion [

^ #(#string #symbol #block)
]

{ #category : 'as yet unclassified' }
TTRawTacticalTheme >> icon [

	^ (self askFor: (self iconSelector) ifAbsent: [ ^ self iconNotFound ])
]

{ #category : 'accessing' }
TTRawTacticalTheme >> iconFrom: text [

 ^ [ BlElement new
          size: 16 @ 16;
          addChild: (BlTextElement new
              text: (text asRopedText
   fontSize: 12;   
                  foreground: Color darkGray);
              position: 4 @ 0);
          yourself ] asStencil
          
]

{ #category : 'accessing' }
TTRawTacticalTheme >> iconNamed: aSymbol [

	^ Smalltalk ui icons iconNamed: aSymbol
]

{ #category : 'accessing' }
TTRawTacticalTheme >> iconNotFound [

	^ #notFound -> (self iconNamed: #glamorousBug)
]

{ #category : 'as yet unclassified' }
TTRawTacticalTheme >> iconSelector [

	^ ('icon_', type) asSymbol
]

{ #category : 'accessing' }
TTRawTacticalTheme >> icon_array [
	^ #symbol -> (self text:'[  ]')
]

{ #category : 'accessing' }
TTRawTacticalTheme >> icon_block [
	^ #symbol -> (self text:'[:a]')
]

{ #category : 'accessing' }
TTRawTacticalTheme >> icon_collection [

	^ #collection -> (self iconNamed: #collection)
]

{ #category : 'accessing' }
TTRawTacticalTheme >> icon_compiled [

	^ #compiled -> self text: '[:]'
]

{ #category : 'accessing' }
TTRawTacticalTheme >> icon_empty [

	^ #empty -> (self iconNamed: #glamorousHelp)
]

{ #category : 'accessing' }
TTRawTacticalTheme >> icon_false [

	^ #false -> (self iconNamed: #glamorousCancel)
]

{ #category : 'accessing' }
TTRawTacticalTheme >> icon_instance [

	^ #instance -> (self iconNamed: #glamorousGrayCircle)
]

{ #category : 'accessing' }
TTRawTacticalTheme >> icon_magnitude [

	^ #magnitude -> (self iconNamed: #magnitude)
]

{ #category : 'accessing' }
TTRawTacticalTheme >> icon_nil [

	^ #nil -> (self iconNamed: #glamorousGrayCircleEmpty)
]

{ #category : 'accessing' }
TTRawTacticalTheme >> icon_string [

	^ #string -> (self iconNamed: #string)
]

{ #category : 'accessing' }
TTRawTacticalTheme >> icon_symbol [
	^ #symbol -> (self text:'#')
]

{ #category : 'accessing' }
TTRawTacticalTheme >> icon_true [

	^ #true -> (self iconNamed: #glamorousAccept)
]

{ #category : 'accessing' }
TTRawTacticalTheme >> text: text [  

	^ self text: text  color: Color gray
]

{ #category : 'accessing' }
TTRawTacticalTheme >> text: text color: color [ 

 ^ [ BlElement new
          size: 16 @ 16;
          addChild: (BlTextElement new
              text: (text asRopedText
   fontSize: 12;   
                  foreground: color);
              position: ((text size > 1) ifTrue: 0 ifFalse: 4) @ 0);
          yourself ] asStencil
          
]
