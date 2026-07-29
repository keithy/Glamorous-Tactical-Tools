Extension { #name : 'SessionManager' }

{ #category : '*Tactical-Tools-Fixes' }
SessionManager >> gtViewShutdownListFor: aView [
	<gtView>
	
	^ aView columnedList 
		title: 'Shutdown list';
		priority: 25;
		items: [ 
			self gtStartupListWithDetails  reversed ];
		column: 'Category' text: [ :data | data first name ] width: 120;
		column: 'Priority' text: [ :data | data second ] width: 150;
		column: 'Handler' text: [ :data | data third ];
		send: [ :data | data third ]
]
