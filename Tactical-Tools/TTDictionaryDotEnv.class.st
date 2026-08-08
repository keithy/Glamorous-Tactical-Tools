Class {
	#name : 'TTDictionaryDotEnv',
	#superclass : 'TTDictionaryProxy',
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'as yet unclassified' }
TTDictionaryDotEnv class >> newTest [

	<gtExample>
	<return: #TTDictionaryDotEnv>
	| store |
	
	store := self new.
	store tierKey: #test.
	store reader: TTVault new.
	store readSource: 

	'HELLO=WORLD
	HELLO1=WORLD1
	HELLO2_PASS="WORLD2" 
	HELLO3_ENCODED="V09STEQz"'.
	
	^ store
	 
]

{ #category : 'accessing' }
TTDictionaryDotEnv >> at: key write: value [

	^ valueWriter fromDotEnvAt: key put: value
]

{ #category : 'as yet unclassified' }
TTDictionaryDotEnv >> readSource [
	
	self reset.
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
