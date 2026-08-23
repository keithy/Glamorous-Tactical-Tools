"
Subclasses can stand in for TTRequest upstream of a TTResult
"
Class {
	#name : 'SRLRequestAbstract',
	#superclass : 'SRLRouter',
	#instVars : [
		'result',
		'client',
		'stdout'
	],
	#category : 'Tactical-SRL-Schemes',
	#package : 'Tactical-SRL',
	#tag : 'Schemes'
}

{ #category : 'as yet unclassified' }
SRLRequestAbstract class >> canRoute: aSymbol [

	^ false
]

{ #category : 'as yet unclassified' }
SRLRequestAbstract class >> isAbstract [

	^ self == SRLRequestAbstract
]

{ #category : 'as yet unclassified' }
SRLRequestAbstract class >> makeResult [

	^ TTResult new
]

{ #category : 'accessing' }
SRLRequestAbstract >> asDictionary [

	^ STONJSON fromString: self asString
	
]

{ #category : 'accessing' }
SRLRequestAbstract >> asResult [

	^ self getResult.
	
]

{ #category : 'accessing' }
SRLRequestAbstract >> asString [

	^ self getVerifiedContents
	
]

{ #category : 'as yet unclassified' }
SRLRequestAbstract >> client [
 
 	^ client ifNil: [ self ]
]

{ #category : 'accessing' }
SRLRequestAbstract >> client: anObject [
	client := anObject
]

{ #category : 'as yet unclassified' }
SRLRequestAbstract >> getOutputProvider [
	"the object responsible for providing output"
	^ self result request output
]

{ #category : 'accessing' }
SRLRequestAbstract >> getRawContents [

	^ self getOutputProvider stdout
]

{ #category : 'as yet unclassified' }
SRLRequestAbstract >> getResult [
	^ result ifNil: [ result := self getOutputProvider getResult ]
]

{ #category : 'accessing' }
SRLRequestAbstract >> getVerifiedContents [
	"take the raw contents possibly adjust, verify status errors etc."
	^ self getRawContents
]

{ #category : 'accessing' }
SRLRequestAbstract >> in: aBlock [

	aBlock value: self getResult	
]

{ #category : 'as yet unclassified' }
SRLRequestAbstract >> makeResultForRequest: request [
 
 ^ self class makeResult
			setRequest: request;
			initialize
]

{ #category : 'as yet unclassified' }
SRLRequestAbstract >> output [
	
	^ self 
]

{ #category : 'as yet unclassified' }
SRLRequestAbstract >> result [
	"thin client behaviour, we are our own result"
	^ result ifNil: [ self ]
]

{ #category : 'accessing' }
SRLRequestAbstract >> result: aBlock [

	aBlock value: self getResult.
	
	^ result
]

{ #category : 'as yet unclassified' }
SRLRequestAbstract >> stdout [

	self subclassResponsibility
]

{ #category : 'accessing' }
SRLRequestAbstract >> useGET [

	^ self getResult.
	
]
