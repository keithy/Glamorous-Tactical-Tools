Class {
	#name : 'FileNotification',
	#superclass : 'Notification',
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'as yet unclassified' }
FileNotification class >> signal: fileReference [

	^ super signal: fileReference asFileReference fullName 
]
