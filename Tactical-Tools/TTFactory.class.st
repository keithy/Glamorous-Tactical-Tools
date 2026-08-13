Class {
	#name : 'TTFactory',
	#superclass : 'TTFactoryAbstract',
	#category : 'Tactical-Tools-Clients',
	#package : 'Tactical-Tools',
	#tag : 'Clients'
}

{ #category : 'as yet unclassified' }
TTFactory >> name [

	^ 'tt'
]

{ #category : 'as yet unclassified' }
TTFactory >> newMiseEnPlaceCli [

	<ttClient>

	^ self 
			make: #TTMiseEnPlaceCli  
			andConfigure: [ :mise | mise ]

	
]

{ #category : 'as yet unclassified' }
TTFactory >> newWorldClockClient [

	<ttApiClient>

  ^ self 
			make: #TTWorldClockClient  
			andConfigure: [ :wc | wc ]

]
