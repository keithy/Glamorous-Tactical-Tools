Class {
	#name : 'TTWorldClockClient',
	#superclass : 'TTApiClientAbstract',
	#instVars : [
		'maxDelay'
	],
	#category : 'Tactical-Tools-Clients',
	#package : 'Tactical-Tools',
	#tag : 'Clients'
}

{ #category : 'accessing' }
TTWorldClockClient >> initialize [

	maxDelay := vault lookup: #maxdelay ifAbsent: 0.
]

{ #category : 'accessing' }
TTWorldClockClient >> maxDelay [
	^ maxDelay
]

{ #category : 'accessing' }
TTWorldClockClient >> maxDelay: anObject [
	maxDelay := anObject
]
