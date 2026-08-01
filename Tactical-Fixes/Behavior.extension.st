Extension { #name : 'Behavior' }

{ #category : '*Tactical-Fixes' }
Behavior >> withAllSubclassesDo: aBlock [

	<ttFix>
	
	aBlock value: self.
	self subclasses do: [ :each | each withAllSubclassesDo: aBlock ]
]
