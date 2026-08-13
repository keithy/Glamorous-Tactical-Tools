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
TTWorldClockClient >> randomDelayWait [

  maxDelay = 0 ifTrue: [ ^ self ].
  
	(Delay forMilliseconds: (maxDelay * 1000) atRandom) wait
]
