Class {
	#name : 'TTDictionarySshKeys',
	#superclass : 'TTDictionaryBacked',
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'as yet unclassified' }
TTDictionarySshKeys class >> newTest [

	<gtExample>
	 
	| store |
	
	^ (self new)
			setValueWriter: TTVaultValueWriter new;
	 		setSource: 

	'HELLO=WORLD
	HELLO1=WORLD1
	HELLO2_PASS="WORLD2" 
	HELLO3_ENCODED="V09STEQz"'.
	
 
	 
]

{ #category : 'as yet unclassified' }
TTDictionarySshKeys >> readFromStream: aStream [

	[ [ aStream atEnd ]
		whileFalse: [ | line key value |
			line := aStream nextLine readStream.
			key := line upTo: $=.
			value := line upToEnd.
			(key beginsWith: '#')
				ifFalse: [ value isEmpty
						ifFalse: [ self at: key write: value trimRight withoutQuoting ] ] ] ]
						
		ensure: [ aStream close ]
]

{ #category : 'as yet unclassified' }
TTDictionarySshKeys >> readSource [
	
	self removeAll.
	self readFromStream: self source readStream.
	
]
