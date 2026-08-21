Class {
	#name : 'BaselineOfTacticalTools',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfTacticalTools',
	#package : 'BaselineOfTacticalTools'
}

{ #category : 'as yet unclassified' }
BaselineOfTacticalTools class >> initializeAll [
	"url -> usl - universal smalltalk locator"

	(#class:// #TTStartUpShutDownSubsystem) initialize.
	(#class:// #TTNotifyingHubAbstract) initialize.
	(#class:// #TTImageStoreResolver) initialize.
	(#class:// #Hub) initialize.
]

{ #category : 'as yet unclassified' }
BaselineOfTacticalTools class >> initializeAllVersion1 [
	"url -> usl - universal smalltalk locator"

	(Class // #TTStartUpShutDownSubsystem) initialize.
	(Class // #TTNotifyingHubAbstract) initialize.
	(Class // #TTImageStoreResolver) initialize
]

{ #category : 'as yet unclassified' }
BaselineOfTacticalTools class >> initializeAllVersion2 [
	"url -> usl - universal smalltalk locator"

	(#class: // #TTStartUpShutDownSubsystem) initialize.
	(#class: // #TTNotifyingHubAbstract) initialize.
	(#class: // #TTImageStoreResolver) initialize
]

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
	^ spec
		for: #common
		do: [ spec
				package: 'Tactical-Tools'
				with: [ 
				
				  spec requires: #('Tactical-Hub').
					spec requires: #('Tactical-Fixes') .
					spec requires: #('Tactical-Pharo') .
        ].
		]
]
