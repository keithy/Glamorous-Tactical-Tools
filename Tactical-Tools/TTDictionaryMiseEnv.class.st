Class {
	#name : 'TTDictionaryMiseEnv',
	#superclass : 'TTDictionaryProxy',
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'as yet unclassified' }
TTDictionaryMiseEnv class >> newHomeDir [

<gtExample>

^ (self new)
		tierKey: #miseHome;
		valueWriter: (TTVault newValueWriter);
		readSource: '~'; yourself
]

{ #category : 'accessing' }
TTDictionaryMiseEnv >> at: key putReading: value [

	^ valueWriter fromMiseAt: key put: value
]

{ #category : 'as yet unclassified' }
TTDictionaryMiseEnv >> execMiseEnv [

	| cd |
	
	cd := source ifNil: '' ifNotNil: [ cd := 'cd ', source, ' && ' ].
	
^ (GtExternalProcessBuilder new)
		command: 'bash';
		arguments: {'-c'. (cd, '~/.local/bin/mise env --json-extended').};
		yourself
]

{ #category : 'as yet unclassified' }
TTDictionaryMiseEnv >> initialize [ 
	super initialize.
	tierKey := 'mise'
]

{ #category : 'as yet unclassified' }
TTDictionaryMiseEnv >> readSource [
	
	self reset.
	self readingFromStream: self execMiseEnv output stdout
	
]

{ #category : 'as yet unclassified' }
TTDictionaryMiseEnv >> readingFromStream: aStreamable [
	
	(STONJSON fromStream: aStreamable readStream)	
		
	keysAndValuesDo: [ :key :data |
	
		self at: key putReading: data
	
	].
	 
]
