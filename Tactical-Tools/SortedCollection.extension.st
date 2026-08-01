Extension { #name : 'SortedCollection' }

{ #category : '*Tactical-Tools' }
SortedCollection class >> sortBy: selector [

	<ttExtension>
	
	^ self sortUsing: [ :a :b | (a perform: selector) <= ( b perform: selector) ]
]

{ #category : '*Tactical-Tools' }
SortedCollection >> sortBy: selector [

	<ttExtension>

	^ self sort: [ :a :b | (a perform: selector) <= ( b perform: selector) ]
]
