Class {
	#name : 'BaselineOfTacticalToolkit',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfTacticalTools',
	#package : 'BaselineOfTacticalTools'
}

{ #category : 'loading' }
BaselineOfTacticalToolkit class >> loadLepiter [
	IceRepository registry  
		detect: [ :aRepository |
			aRepository name = 'Glamorous-Tactical-Toolkit' ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties addRegisteredDirectory: aRepository repositoryDirectory / 'lepiter'.
			defaultDatabase reload ]
		ifNone: [
			self inform: 'Repository not found.' ]
]

{ #category : 'baseline' }
BaselineOfTacticalToolkit >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'TacticalToolkit'
		]
]
