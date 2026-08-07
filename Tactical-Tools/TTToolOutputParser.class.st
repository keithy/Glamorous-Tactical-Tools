Class {
	#name : 'TTToolOutputParser',
	#superclass : 'TTResultBoltOn',
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'as yet unclassified' }
TTToolOutputParser >> getAsString [
	
	^ result getStdout asString
]

{ #category : 'as yet unclassified' }
TTToolOutputParser >> getAsXML [

	^ XMLDOMParser parse: self getContents
	
]

{ #category : 'as yet unclassified' }
TTToolOutputParser >> parseAsSTON [

	^ STON fromString: (result getStdout ifNil: [ ^ #() ])

]
