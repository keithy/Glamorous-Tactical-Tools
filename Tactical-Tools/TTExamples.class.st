Class {
	#name : 'TTExamples',
	#superclass : 'Object',
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'as yet unclassified' }
TTExamples >> testGlobalsMiseEnvironment [

<gtExample>

Hub for: #osEnvironment respondWith: { ('USER' -> 'Me'). } asDictionary
during:
[
	self assert: (Hub osEnvironment at: 'USER') equals: 'Me'.
]

]

{ #category : 'as yet unclassified' }
TTExamples >> testGlobalsOsEnvironment [

<gtExample>

Hub for: #osEnvironment respondWith: { ('USER' -> 'Me'). } asDictionary
during:
[
	self assert: (Hub osEnvironment at: 'USER') equals: 'Me'.
]

]
