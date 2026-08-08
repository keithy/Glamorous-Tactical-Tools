Class {
	#name : 'TTMiseEnPlace',
	#superclass : 'Object',
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

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
