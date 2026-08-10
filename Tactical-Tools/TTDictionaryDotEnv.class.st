Class {
	#name : 'TTDictionaryDotEnv',
	#superclass : 'TTDictionaryBacked',
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'as yet unclassified' }
TTDictionaryDotEnv class >> newTest [

	<gtExample>
	 
	| store |
	
	^ (self new)
			valueWriter: TTVaultValueWriter new;
	 		readSource: 

	'HELLO=WORLD
	HELLO1=WORLD1
	HELLO2_PASS="WORLD2" 
	HELLO3_ENCODED="V09STEQz"'.
	
 
	 
]

{ #category : 'as yet unclassified' }
TTDictionaryDotEnv >> readSource [
	
	self removeAll.
	self readingFromStream: self source readStream.
	
]

{ #category : 'as yet unclassified' }
TTDictionaryDotEnv >> readingFromStream: aStream [

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
