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
	
	^ (self basicNew)
			setValueWriter: TTVaultValueWriter new;
	 		setSource: 

	'HELLO=WORLD
	HELLO1=WORLD1
	HELLO2_PASS="WORLD2" 
	HELLO3_ENCODED="V09STEQz"';
	    yourself
	
 
	 
]

{ #category : 'as yet unclassified' }
TTDictionaryDotEnv >> gtFileReferencePathFor: aView [
	<gtView>
	^ aView forward
		title: 'Source';
		priority: 1;
		object: [ self source asFileReference ];
		view: #gtContentsFor:
]

{ #category : 'as yet unclassified' }
TTDictionaryDotEnv >> readFromStream: aStream [

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
TTDictionaryDotEnv >> readSource [
	
	self removeAll.
	self readFromStream: self source readStream.
	
]
