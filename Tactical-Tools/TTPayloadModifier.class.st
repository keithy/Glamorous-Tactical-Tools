Class {
	#name : 'TTPayloadModifier',
	#superclass : 'Object',
	#instVars : [
		'select',
		'modify'
	],
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'accessing' }
TTPayloadModifier >> cull: payl cull: result [

  | list selectBlock  |
  
  list := payl isDictionary ifTrue: [ Array with: payl ] ifFalse: [ payl ].
  
  selectBlock := select.
  select isBlock ifFalse: [ selectBlock := [ :aKey :aValue | select matches: aKey ] ].
  
  list do: [ :record | 
  
  	record associationsDo: [ :assoc |
  			| key value |
  			key := assoc key.
  			value := assoc value.
				(selectBlock value: key value: value) 
				ifTrue: [ record at: key put: (modify value: value) ]
    ]
  ].
  
  ^ payl
]

{ #category : 'accessing' }
TTPayloadModifier >> gtThunkEntries [

^ #(select modify)
]

{ #category : 'accessing' }
TTPayloadModifier >> isBlock [
	"ducking it"
	^ true
]

{ #category : 'accessing' }
TTPayloadModifier >> key: symbol [
	select := symbol
]

{ #category : 'accessing' }
TTPayloadModifier >> modify: aModifyBlock [

	modify := aModifyBlock
]

{ #category : 'accessing' }
TTPayloadModifier >> select: aMatcherOrBlock [
	select := aMatcherOrBlock
]
