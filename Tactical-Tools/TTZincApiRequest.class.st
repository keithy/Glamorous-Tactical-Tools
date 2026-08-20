Class {
	#name : 'TTZincApiRequest',
	#superclass : 'TTApiRequest',
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'as yet unclassified' }
TTZincApiRequest >> accept: mimeType [
 self error.
	guzzler request setAccept: mimeType
]

{ #category : 'as yet unclassified' }
TTZincApiRequest >> asDictionary [
  "convenience - replace with better"
	^ STONJSON fromString: self get
]

{ #category : 'as yet unclassified' }
TTZincApiRequest >> asString [
  "convenience - replace with better"
	^ self get
]

{ #category : 'as yet unclassified' }
TTZincApiRequest >> doesNotUnderstand: aMessage [

  "Creating Guzzler has taken on most/all of this classes funciton,
   roll up into TTAPiRequest?"
   
	"delegation"
	
	^ aMessage sendTo: guzzler
]

{ #category : 'as yet unclassified' }
TTZincApiRequest >> get [

	^ self useGET getContents
]

{ #category : 'as yet unclassified' }
TTZincApiRequest >> getContents [
	"thin client only"
	^ self send response contents
]

{ #category : 'as yet unclassified' }
TTZincApiRequest >> makeResultThin [

	client makeResultThin
]

{ #category : 'as yet unclassified' }
TTZincApiRequest >> output [

	^ guzzler response
]

{ #category : 'as yet unclassified' }
TTZincApiRequest >> timeout: n [
	guzzler timeout: n
]
