Class {
	#name : 'TTFactory',
	#superclass : 'TTFactoryAbstract',
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
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
TTFactory >> newWorldClockClient_option1 [

	"World Clock"
	
	<ttApiClient>

  ^ self 
			use: (self tryAll)
			andConfigure: [ :wc | wc ]

]

{ #category : 'as yet unclassified' }
TTFactory >> newWorldClockClient_option2 [

	"World Clock"
	
	<ttApiClient>

  ^ self 
			use: (self tryAll: #TTWorldClockClient) 
			andConfigure: [ :wc | wc ]

]

{ #category : 'as yet unclassified' }
TTFactory >> newWorldClockClient_option3 [

	"World Clock"
	
	<ttApiClient>

  ^ self 
			makeForAll: (self askAll: #TTWorldClockClient)  
			andConfigure: [ :wc | wc ]

]

{ #category : 'as yet unclassified' }
TTFactory >> newWorldClockClient_option4 [

	"World Clock"
	
	<ttApiClient>

  ^ self 
			makeFor: ((self sort: (self askAll: #TTWorldClockClient) by: #priority) at: 1 ifAbsent: nil)
			andConfigure: [ :wc | wc ]

]
