Extension { #name : 'Class' }

{ #category : '*Tactical-Fixes' }
Class >> withAllSubclassesDo: aBlock [

	<reflection: 'Class structural inspection - Iterating and querying hierarchy'>
	<ttFix>
	
	aBlock value: self.
	self subclassesDo: [ :each | each withAllSubclassesDo: aBlock ]
]
