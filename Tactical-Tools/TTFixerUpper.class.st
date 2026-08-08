Class {
	#name : 'TTFixerUpper',
	#superclass : 'TTResultTalent',
	#category : 'Tactical-Tools-Clients',
	#package : 'Tactical-Tools',
	#tag : 'Clients'
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

	result payloadAssociationsSelect: [ :assoc |  aBlock value: assoc key ] andModify: [  :v | TheHub unixMillisToDate: v ] 
	
]
