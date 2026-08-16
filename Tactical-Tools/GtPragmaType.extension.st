Extension { #name : 'GtPragmaType' }

{ #category : '*Tactical-Tools' }
GtPragmaType >> gtPragmasBetterFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Better';
		priority: 0;
		items: [ self pragmas sorted: [:a :b | a gtDisplayString < b gtDisplayString] ];
		column: 'Class' text: [:each | each methodClass name ];
		column: 'Selector' text: [:each | each method selector];
		
		"Added Comment"
		column: 'Comment' text: [:each | each method comment ifNil: '' ]
]

{ #category : '*Tactical-Tools' }
GtPragmaType >> gtPragmasFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Pragmas';
		priority: 1;
		items: [ self pragmas sorted: [:a :b | a gtDisplayString < b gtDisplayString] ];
		column: 'Class' text: [:each | each methodClass name ];
		column: 'Selector' text: [:each | each method selector ]
]
