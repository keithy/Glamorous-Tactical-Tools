Class {
	#name : 'TTWorldClockClient',
	#superclass : 'TTOneJobManySuppliers',
	#instVars : [
		'maxDelay'
	],
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'accessing' }
TTWorldClockClient class >> vaultAppKey [

	"Same for subclasses"
	
	^ 'worldclock'
]

{ #category : 'accessing' }
TTWorldClockClient >> handlers [

	^ Array with: TTCloudflareStatusHandler
]

{ #category : 'accessing' }
TTWorldClockClient >> initialize [

	  maxDelay := (self 	getVault at: #max_delay) ifNil: 60.
]

{ #category : 'accessing' }
TTWorldClockClient >> maxDelay [
	^ maxDelay
]

{ #category : 'accessing' }
TTWorldClockClient >> maxDelay: anObject [
	maxDelay := anObject
]

{ #category : 'accessing' }
TTWorldClockClient >> minDelay [
	^ 0
]

{ #category : 'accessing' }
TTWorldClockClient >> randomDelayWait [

	(Delay forMilliseconds: ((self minDelay * 1000) max: (maxDelay * 1000) atRandom)) wait
]
