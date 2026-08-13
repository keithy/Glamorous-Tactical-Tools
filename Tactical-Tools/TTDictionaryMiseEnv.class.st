Class {
	#name : 'TTDictionaryMiseEnv',
	#superclass : 'TTDictionaryCliNVG',
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'as yet unclassified' }
TTDictionaryMiseEnv class >> execMiseEnv: project [

	| cd |
	
	cd := project ifNil: '' ifNotNil: [ cd := 'cd ', project, ' && ' ].
	
	^ (GtExternalProcessBuilder new)
				command: 'bash';
				arguments: {'-c'. (cd, '~/.local/bin/mise env --json-extended').};
				yourself
]

{ #category : 'as yet unclassified' }
TTDictionaryMiseEnv class >> getExecutableFrom: osEnvironmentLike [

	#('__MISE_EXE' 'MISE_INSTALL_PATH') do: [ :varName |	

			osEnvironmentLike at: varName ifPresent: [ :v | ^ v ]
	 
	 ].
	 
	#('{home}/.local/bin/mise' '/opt/usr/bin/mise' 'usr/local/bin/mise')
	do: [ :fullName | 
	
		| fr |
	
		fr := TheHub fileReferenceFrom: fullName.
	
		fr exists ifTrue: [ ^ fr  ]
	
	].
	 
	 
]

{ #category : 'as yet unclassified' }
TTDictionaryMiseEnv class >> newHomeDir [

<gtExample>

^ (self new)
		tierKey: #miseHome;
		setValueWriter: (TTVault makeValueWriter);
		setSource: '~'; yourself
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
TTDictionaryMiseEnv >> initialize [
	
		"skip the first initialization"
		
	^ super initialize
	 
]

{ #category : 'as yet unclassified' }
TTDictionaryMiseEnv >> initializeReadingConfig: topTier [
	self readSourceTooSoon ifTrue: [ ^ self ].
 
	"now its our turn"
	exes := self getExecutableFrom: topTier.
		
	self readSource.
	
]

{ #category : 'as yet unclassified' }
TTDictionaryMiseEnv >> performExec [

	| cd |
	
	cd := self source ifNil: '' ifNotNil: [ cd := 'cd ', source, ' && ' ].
	
^ (GtExternalProcessBuilder new)
		command: 'bash';
		arguments: {'-c'. (cd, exes,  ' env --json-extended').};
		yourself
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
	self readFromStream: self performExec output stdout
	
]

{ #category : 'accessing' }
TTDictionaryMiseEnv >> setProjectDirectory: anObject [
	projectDirectory := anObject
]
