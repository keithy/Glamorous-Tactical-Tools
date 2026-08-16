Class {
	#name : 'BaselineOfTacticalTools',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfTacticalTools',
	#package : 'BaselineOfTacticalTools'
}

{ #category : 'as yet unclassified' }
BaselineOfTacticalTools class >> loadLepiter [
	IceRepository registry  
		detect: [ :aRepository |
			aRepository name = 'Glamorous-Tactical-Tools' ]
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
BaselineOfTacticalTools >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
		
				spec package: 'Tactical-Tools' with: [ spec requires: #('Tactical-Fixes') ].
				spec package: 'Tactical-Pharo' with: [ spec requires: #('Tactical-Tools') ].
				 
		]
]
