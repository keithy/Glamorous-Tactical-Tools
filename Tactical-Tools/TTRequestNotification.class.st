Class {
	#name : 'TTRequestNotification',
	#superclass : 'Notification',
	#instVars : [
		'request'
	],
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'accessing' }
TTRequestNotification >> defaultAction [
	"No action is taken. The value nil is returned as the value of the message that signaled the exception."
	
	^ request
]

{ #category : 'accessing' }
TTRequestNotification >> defaultResumeValue [
	"No action is taken. The value nil is returned as the value of the message that signaled the exception."

	^ request
]

{ #category : 'accessing' }
TTRequestNotification >> defaultReturnValue [
	"No action is taken. The value nil is returned as the value of the message that signaled the exception."

	^ request
]

{ #category : 'accessing' }
TTRequestNotification >> request [
	^ request
]

{ #category : 'accessing' }
TTRequestNotification >> request: anObject [
	request := anObject
]
