Class {
	#name : 'TTFixerUpper',
	#superclass : 'TTResultBoltOn',
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'as yet unclassified' }
TTFixerUpper >> payloadFixDateFields: keys [
	
	result payloadAssociationsSelect: [ :assoc | keys includes: assoc key ] andModify: [ :v | v asDate ]
	
]

{ #category : 'as yet unclassified' }
TTFixerUpper >> payloadFixDateFieldsAuto [
		
		result payloadAssociationsSelect: [ :assoc  | (#(name) includes: assoc key) not ] andModify: [ :v | [ v asDate  ] ifErrorDo: [ v ] ]
]

{ #category : 'as yet unclassified' }
TTFixerUpper >> payloadFixUnixEpochFieldsSelect: aBlock [

	result payloadAssociationsSelect: [ :assoc |  aBlock value: assoc key ] andModify: [  :v | Hub unixMillisToDate: v ] 
	
]
