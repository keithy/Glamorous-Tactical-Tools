Class {
	#name : 'TTMiseEnPlaceCli',
	#superclass : 'TTClientAbstract',
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'as yet unclassified' }
TTMiseEnPlaceCli class >> basicExecMiseEnvironmentIn: source [

	"Mise environment"
	
	| cd |
	
	cd := source ifNil: '' ifNotNil: [ cd := 'cd ', source, ' && ' ].
	
	^ (GtExternalProcessBuilder new)
			command: 'bash';
			arguments: {'-c'. (cd, '~/.local/bin/mise env --json-extended').};
			yourself
]

{ #category : 'as yet unclassified' }
TTMiseEnPlaceCli class >> clientId [

	^ 'mise'
]

{ #category : 'as yet unclassified' }
TTMiseEnPlaceCli class >> new [

	^ (self basicNew)
			setVault: (Hub currentVault);
			initialize
 
]

{ #category : 'as yet unclassified' }
TTMiseEnPlaceCli >> buildMise [
]

{ #category : 'as yet unclassified' }
TTMiseEnPlaceCli >> buildMiseViaShell [
]

{ #category : 'as yet unclassified' }
TTMiseEnPlaceCli >> makeMiseEnv: source [

	"Mise environment"
	
	| cd |
	
	cd := source ifNil: '' ifNotNil: [ cd := 'cd ', source, ' && ' ].
	
	^ self makeShell: (self toolExe, ' env --json-extended')
				workingDirectory: source.
]

{ #category : 'as yet unclassified' }
TTMiseEnPlaceCli >> version [

	"Mise environment"
	
	^ self versionRequest 
					verifiedContents;
					yourself
]

{ #category : 'as yet unclassified' }
TTMiseEnPlaceCli >> versionNumber [

	"Mise environment"
	
	^ self version
]

{ #category : 'as yet unclassified' }
TTMiseEnPlaceCli >> versionRequest [

	"Mise version"
	
	request := self class makeShell: 'mise version'.
]
