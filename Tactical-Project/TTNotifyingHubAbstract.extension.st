Extension { #name : 'TTNotifyingHubAbstract' }

{ #category : '*Tactical-Project' }
TTNotifyingHubAbstract class >> projectDir [

	^ self osEnvironment at: 'PROJECT_DIR' ifAbsent: 'xanadu' 
]

{ #category : '*Tactical-Project' }
TTNotifyingHubAbstract class >> projectId [

	^ self osEnvironment at: 'PROJECT_ID' ifAbsent: 'Xandadu'
]

{ #category : '*Tactical-Project' }
TTNotifyingHubAbstract class >> projectName [

	^ self osEnvironment at: 'PROJECT_NAME' ifAbsent: [ self projectId]
]
