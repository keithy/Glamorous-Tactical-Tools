Extension { #name : 'AbstractFileReference' }

{ #category : '*Tactical-Fixes' }
AbstractFileReference >> gtDetailsFor: composite [
	<gtView>
	^ composite columnedList
		title: 'Details';
		priority: 60;
		items: [ self gtDetails ];
		column: 'key' text: #first;
		column: 'value' text: #second weight: 3;
		send: #last
]
