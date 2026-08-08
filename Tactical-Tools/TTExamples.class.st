Class {
	#name : 'TTExamples',
	#superclass : 'Object',
	#category : 'Tactical-Tools-Result',
	#package : 'Tactical-Tools',
	#tag : 'Result'
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
