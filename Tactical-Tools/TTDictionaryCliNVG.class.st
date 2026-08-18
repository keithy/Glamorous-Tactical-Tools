Class {
	#name : 'TTDictionaryCliNVG',
	#superclass : 'TTDictionaryBacked',
	#instVars : [
		'shell',
		'argString',
		'exes',
		'readBlock'
	],
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'as yet unclassified' }
TTDictionaryCliNVG class >> defaultArgString [

	^ '-1'
]

{ #category : 'as yet unclassified' }
TTDictionaryCliNVG class >> defaultExe [

	^ 'ls'  
]

{ #category : 'as yet unclassified' }
TTDictionaryCliNVG class >> defaultExes [

	^ (self getExesFrom: Hub osEnvironment) ifNil: [ #('/bin/ls') ] 
]

{ #category : 'as yet unclassified' }
TTDictionaryCliNVG class >> defaultReadBlock [

	^ [ :line |  (line splitOn: ' ') first -> line ]
]

{ #category : 'as yet unclassified' }
TTDictionaryCliNVG class >> defaultShell [

	^ self getShellFrom: Hub osEnvironment
]

{ #category : 'as yet unclassified' }
TTDictionaryCliNVG class >> execMiseEnv: project [

	| cd |
	
	cd := project ifNil: '' ifNotNil: [ cd := 'cd ', project, ' && ' ].
	
	^ (GtExternalProcessBuilder new)
				command: 'bash';
				arguments: {'-c'. (cd, '~/.local/bin/mise env --json-extended').};
				yourself
]

{ #category : 'as yet unclassified' }
TTDictionaryCliNVG class >> getExesFrom: osEnvironmentLike [

	 "used in specific subclasses"
	 
	 ^ nil
]

{ #category : 'as yet unclassified' }
TTDictionaryCliNVG class >> getShellFrom: aDict [

	aDict at: 'SHELL' ifPresent: [ :v | ^ v ].
	
	^ '/bin/sh'
]

{ #category : 'as yet unclassified' }
TTDictionaryCliNVG class >> newHomeDir [

<gtExample>

^ (self new)
		tierKey: #miseHome;
		setValueWriter: (TTVault makeValueWriter);
		setSource: '~'; yourself
]

{ #category : 'accessing' }
TTDictionaryCliNVG >> argString [
	^ argString ifNil:  [ argString := self class defaultArgString ]
]

{ #category : 'accessing' }
TTDictionaryCliNVG >> argString: anObject [
	argString := anObject
]

{ #category : 'accessing' }
TTDictionaryCliNVG >> exes [
	^ exes ifNil: [ Array with: self class defaultExe ]
]

{ #category : 'accessing' }
TTDictionaryCliNVG >> exes: anObject [
	exes := anObject
]

{ #category : 'accessing' }
TTDictionaryCliNVG >> getExe [

	self exes do: [ :ea | 
	
		| exe |
		
		exe := self class asFile: ea.
		exe exists ifTrue: [ ^ exe ] 
	].
	
	^ self error: 'Executable not found' 
]

{ #category : 'as yet unclassified' }
TTDictionaryCliNVG >> gtFileReferencePathFor: aView [
	<gtView>
	^ aView forward
		title: 'Project Directory';
		priority: 1;
		object: [ self source asFileReference ];
		view: #gtContentsFor:
]

{ #category : 'as yet unclassified' }
TTDictionaryCliNVG >> initialize [
	
		"skip the first initialization"
		
	^ super initialize
	 
]

{ #category : 'as yet unclassified' }
TTDictionaryCliNVG >> initializeReadingWith: topTierConfigToReferToIfNeeded [
 
  self readSourceTooSoon ifTrue: [ ^ self ].
 
	"now its our turn"
	exes := self getExecutablesFrom: topTierConfigToReferToIfNeeded.
		
	self readSource.
	
]

{ #category : 'as yet unclassified' }
TTDictionaryCliNVG >> performExec [

	| cd |
	
	cd := self source ifNil: '' ifNotNil: [ cd := 'cd ', source, ' && ' ].
	
^ (GtExternalProcessBuilder new)
		command: 'bash';
		arguments: {'-c'. (cd, self getExe,' ',  self argString).};
		yourself
]

{ #category : 'accessing' }
TTDictionaryCliNVG >> readBlock [

	^ readBlock ifNil: [ self class defaultReadBlock ] 
]

{ #category : 'as yet unclassified' }
TTDictionaryCliNVG >> readFromStream: aStreamable [
	
		[ aStreamable atEnd ] whileFalse: [ 
		
			self readBlock value: aStreamable nextLine
		
		]
]

{ #category : 'as yet unclassified' }
TTDictionaryCliNVG >> readSource [
	
	self removeAll.
	self readFromStream: self performExec output stdout
	
]

{ #category : 'accessing' }
TTDictionaryCliNVG >> readUsing: aBlock [
	readBlock := aBlock
]

{ #category : 'accessing' }
TTDictionaryCliNVG >> setProjectDirectory: anObject [
	projectDirectory := anObject
]

{ #category : 'accessing' }
TTDictionaryCliNVG >> shell [

	^ shell ifNil: [ shell := self class defaultShell ]
]

{ #category : 'accessing' }
TTDictionaryCliNVG >> shell: anObject [
	shell := anObject
]
