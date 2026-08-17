Class {
	#name : 'FileLookedForNotification',
	#superclass : 'Notification',
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'as yet unclassified' }
FileLookedForNotification class >> signal: fileReference [

	^ super signal: fileReference asFileReference fullName 
]
