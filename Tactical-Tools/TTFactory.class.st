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

	"Mise-En-Place - dev tools management"
	
	<ttClient>

	^ self 
			make: #TTMiseEnPlaceCli  
			andConfigure: [ :mise | mise ]

	
]

{ #category : 'as yet unclassified' }
TTFactory >> newOpenApiBrowser: aStreamable [

	"OpenAPI - parser"
	
	<ttParser>
	
	^ (#GtOpenApiParser asClassIfAbsent: [ ^ nil ])  
			readString: aStreamable
			yourself
	
]

{ #category : 'as yet unclassified' }
TTFactory >> newWorldClockClient [

	"World Clock"
	
	<ttApiClient>

  ^ self 
			make: #TTWorldClockClient  
			andConfigure: [ :wc | wc ]

]
