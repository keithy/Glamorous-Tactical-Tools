Class {
	#name : 'BaselineOfTacticalTools',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfTacticalTools',
	#package : 'BaselineOfTacticalTools'
}

{ #category : 'baseline' }
BaselineOfTacticalTools >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'TacticalTools'
		]
]
