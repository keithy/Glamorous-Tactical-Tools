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

	  maxDelay := (vault at: #max_delay) ifNil: 0.
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
TTWorldClockClient >> openapi [

	^ vault openapi ifNil: [ self class openapi ]
]

{ #category : 'accessing' }
TTWorldClockClient >> randomDelayWait [

	(Delay forMilliseconds: ((self minDelay * 1000) max: (maxDelay * 1000) atRandom)) wait
]
