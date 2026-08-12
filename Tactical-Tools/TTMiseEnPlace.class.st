Class {
	#name : 'TTMiseEnPlace',
	#superclass : 'TTClientAbstract',
	#category : 'Tactical-Tools-Clients',
	#package : 'Tactical-Tools',
	#tag : 'Clients'
}

{ #category : 'as yet unclassified' }
TTMiseEnPlace class >> basicExecMiseEnvironmentIn: source [

	"Mise environment"
	
	| cd |
	
	cd := source ifNil: '' ifNotNil: [ cd := 'cd ', source, ' && ' ].
	
	^ (GtExternalProcessBuilder new)
			command: 'bash';
			arguments: {'-c'. (cd, '~/.local/bin/mise env --json-extended').};
			yourself
]

{ #category : 'as yet unclassified' }
TTMiseEnPlace class >> clientId [

	^ 'mise'
]

{ #category : 'as yet unclassified' }
TTMiseEnPlace class >> new [

	^ (self basicNew)
			setVault: (TTVault currentVault);
			initialize
 
]

{ #category : 'as yet unclassified' }
TTMiseEnPlace >> buildMise [
]

{ #category : 'as yet unclassified' }
TTMiseEnPlace >> buildMiseViaShell [
]

{ #category : 'as yet unclassified' }
TTMiseEnPlace >> makeMiseEnv: source [

	"Mise environment"
	
	| cd |
	
	cd := source ifNil: '' ifNotNil: [ cd := 'cd ', source, ' && ' ].
	
	^ self makeShell: (self toolExe, ' env --json-extended')
				workingDirectory: source.
]

{ #category : 'as yet unclassified' }
TTMiseEnPlace >> version [

	"Mise environment"
	
	^ self versionRequest 
					getStdout;
					yourself
]

{ #category : 'as yet unclassified' }
TTMiseEnPlace >> versionNumber [

	"Mise environment"
	
	^ self version
]

{ #category : 'as yet unclassified' }
TTMiseEnPlace >> versionRequest [

	"Mise version"
	
	request := self class makeShell: 'mise version'.
]
