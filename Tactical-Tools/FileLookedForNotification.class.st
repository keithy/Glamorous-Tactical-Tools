Class {
	#name : 'FileLookedForNotification',
	#superclass : 'Notification',
	#category : 'Tactical-Tools-Exceptions',
	#package : 'Tactical-Tools',
	#tag : 'Exceptions'
}

{ #category : 'as yet unclassified' }
FileLookedForNotification class >> signal: fileReference [

	^ super signal: fileReference asFileReference fullName 
]
