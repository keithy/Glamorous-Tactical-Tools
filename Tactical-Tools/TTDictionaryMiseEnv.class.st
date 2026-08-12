Class {
	#name : 'TTDictionaryMiseEnv',
	#superclass : 'TTDictionaryBacked',
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'as yet unclassified' }
TTDictionaryMiseEnv class >> newHomeDir [

<gtExample>

^ (self new)
		tierKey: #miseHome;
		setValueWriter: (TTVault makeValueWriter);
		setSource: '~'; yourself
]

{ #category : 'as yet unclassified' }
TTDictionaryMiseEnv >> execMiseEnv [

	| cd |
	
	cd := self source ifNil: '' ifNotNil: [ cd := 'cd ', source, ' && ' ].
	
^ (GtExternalProcessBuilder new)
		command: 'bash';
		arguments: {'-c'. (cd, '~/.local/bin/mise env --json-extended').};
		yourself
]

{ #category : 'as yet unclassified' }
TTDictionaryMiseEnv >> gtFileReferencePathFor: aView [
	<gtView>
	^ aView forward
		title: 'Project Directory';
		priority: 1;
		object: [ self source asFileReference ];
		view: #gtContentsFor:
]

{ #category : 'as yet unclassified' }
TTDictionaryMiseEnv >> readFromStream: aStreamable [
	
	(STONJSON fromStream: aStreamable readStream)	
		
	keysAndValuesDo: [ :key :data |
	
		self at: key write: data
	
	].
	 
]

{ #category : 'as yet unclassified' }
TTDictionaryMiseEnv >> readSource [
	
	self removeAll.
	self readFromStream: self execMiseEnv output stdout
	
]

{ #category : 'accessing' }
TTDictionaryMiseEnv >> setProjectDirectory: anObject [
	projectDirectory := anObject
]
