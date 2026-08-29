Class {
	#name : 'TTPayloadReader',
	#superclass : 'TTResultBoltOn',
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'as yet unclassified' }
TTPayloadReader class >> dateAndTimeFromExcelFieldsMatching: aMatcher [
	^ self
		fieldsMatching: aMatcher
		transform: [ :v | 
			| days |
			days := v asNumber.
			days >= 60 ifTrue: [ days := days - 1 ].
			(DateAndTime
				year: 1900
				month: 1
				day: 1) + (days - 1) days ]
]

{ #category : 'as yet unclassified' }
TTPayloadReader class >> dateAndTimeFromISOFieldsMatching: aMatcher [
	^ self fieldsMatching: aMatcher transform: [ :v | DateAndTime fromString: v ]
]

{ #category : 'as yet unclassified' }
TTPayloadReader class >> dateAndTimeFromUnixMillisFieldsMatching: aMatcher [
	
	^ self fieldsMatching: aMatcher transform:[ :v | DateAndTime fromUnixTime: v asInteger // 1000 ]
]

{ #category : 'as yet unclassified' }
TTPayloadReader class >> dateAndTimeFromUnixTimeFieldsMatching: aMatcher [
	
	^ self fieldsMatching: aMatcher transform:[ :v | DateAndTime fromUnixTime:  v]
]

{ #category : 'as yet unclassified' }
TTPayloadReader class >> fieldsMatching: aMatcher transform: monadicBlock [

	^ self newFromMessage: thisContext
]

{ #category : 'as yet unclassified' }
TTPayloadReader >> fieldsMatching: aMatcherOrBlock transform: monadicBlock [

	| matchBlock |
	
	matchBlock := [ :assoc | aMatcherOrBlock matches: assoc key ].
	
	aMatcherOrBlock isBlock ifTrue: [ matchBlock := aMatcherOrBlock ].

	result payloadAssociationsSelect: matchBlock andModify: monadicBlock


]
