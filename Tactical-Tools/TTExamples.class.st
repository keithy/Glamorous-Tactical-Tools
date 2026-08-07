Class {
	#name : 'TTExamples',
	#superclass : 'Object',
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'as yet unclassified' }
TTExamples >> testGlobalsMiseEnvironment [

<gtExample>

TheHub for: #osEnvironment respondWith: { ('USER' -> 'Me'). } asDictionary
during:
[
	self assert: (TheHub osEnvironment at: 'USER') equals: 'Me'.
]

]

{ #category : 'as yet unclassified' }
TTExamples >> testGlobalsOsEnvironment [

<gtExample>

TheHub for: #osEnvironment respondWith: { ('USER' -> 'Me'). } asDictionary
during:
[
	self assert: (TheHub osEnvironment at: 'USER') equals: 'Me'.
]

]
